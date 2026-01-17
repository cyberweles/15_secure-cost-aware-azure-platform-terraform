locals {
  base_tags = merge(
    var.common_tags,
    {
      env    = var.env
      prefix = var.prefix
    }
  )

  # Simple address scheme per env
  vnet_address_space = var.env == "dev" ? ["10.10.0.0/16"] : ["10.20.0.0/16"]
  app_subnet_prefix  = var.env == "dev" ? "10.10.1.0/24" : "10.20.1.0/24"
  data_subnet_prefix = var.env == "dev" ? "10.10.2.0/24" : "10.20.2.0/24"
}

module "core" {
  source = "./modules/core"

  env         = var.env
  location    = var.location
  prefix      = var.prefix
  common_tags = local.base_tags

  vnet_address_space = local.vnet_address_space
  app_subnet_prefix  = local.app_subnet_prefix
  data_subnet_prefix = local.data_subnet_prefix
}

module "app_main" {
  source = "./modules/app"

  env         = var.env
  location    = var.location
  prefix      = var.prefix
  common_tags = local.base_tags

  core_resource_group_name = module.core.core_rg_name

  log_analytics_workspace_id = module.core.log_analytics_workspace_id
}

resource "azurerm_consumption_budget_resource_group" "core_monthly" {
  name = "${var.prefix}-${var.env}-core-monthly-budget"

  resource_group_id = module.core.core_rg_id

  amount     = var.monthly_budget_amount
  time_grain = "Monthly"

  time_period {
    start_date = "2026-01-01T00:00:00Z"
    end_date   = "2026-12-31T00:00:00Z"
  }

  notification {
    enabled   = true
    threshold = 80.0
    operator  = "GreaterThan"

    contact_emails = var.budget_contact_emails
  }

  notification {
    enabled   = true
    threshold = 100.0
    operator  = "GreaterThan"

    contact_emails = var.budget_contact_emails
  }
}

# Platform team -> Contributor on core RG
resource "azurerm_role_assignment" "platform_core_contributor" {
  count = var.platform_principal_id == "" ? 0 : 1

  scope                = module.core.core_rg_id
  role_definition_name = "Contributor"
  principal_id         = var.platform_principal_id
}

# App team -> Contributor on app RG
resource "azurerm_role_assignment" "app_contributor" {
  count = var.app_principal_id == "" ? 0 : 1

  scope                = module.app_main.app_rg_id
  role_definition_name = "Contributor"
  principal_id         = var.app_principal_id
}