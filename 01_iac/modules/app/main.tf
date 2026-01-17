locals {
  app_rg_name      = "${var.prefix}-${var.env}-weu-rg-app-main"
  app_service_plan = "${var.prefix}-${var.env}-weu-asp-main"
  app_service_name = "${var.prefix}-${var.env}-weu-app-main"
}

resource "azurerm_resource_group" "app_main" {
  name     = local.app_rg_name
  location = var.location
  tags     = merge(var.common_tags, { area = "app" })
}

# App Service Plan (Linux)
resource "azurerm_service_plan" "main" {
  name                = local.app_service_plan
  location            = var.location
  resource_group_name = azurerm_resource_group.app_main.name

  os_type  = "Linux"
  sku_name = "B1" # DEV tier, realistic

  tags = merge(var.common_tags, { area = "app-plan" })
}

# App Service (web app)
resource "azurerm_linux_web_app" "main" {
  name                = local.app_service_name
  location            = var.location
  resource_group_name = azurerm_resource_group.app_main.name
  service_plan_id     = azurerm_service_plan.main.id

  https_only = true

  site_config {
    always_on  = false
    ftps_state = "Disabled"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = merge(var.common_tags, { area = "app-service" })
}

resource "azurerm_monitor_diagnostic_setting" "app_main" {
  name                       = "${var.prefix}-${var.env}-weu-app-diag"
  target_resource_id         = azurerm_linux_web_app.main.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "AppServiceConsoleLogs"
  }

  enabled_log {
    category = "AppServiceHTTPLogs"
  }

  enabled_log {
    category = "AppServiceAuditLogs"
  }

  enabled_log {
    category = "AppServicePlatformLogs"
  }
}

