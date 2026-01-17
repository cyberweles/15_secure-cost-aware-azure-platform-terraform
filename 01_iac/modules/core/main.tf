data "azurerm_client_config" "current" {}

locals {
  core_rg_name = "${var.prefix}-${var.env}-weu-rg-core"
  vnet_name    = "${var.prefix}-${var.env}-weu-vnet-core"
  nsg_app_name = "${var.prefix}-${var.env}-weu-nsg-app"

  storage_account_name = lower(replace("${var.prefix}${var.env}saweu01", "-", ""))
  key_vault_name       = "${var.prefix}-${var.env}-weu-kv-core"
}

resource "azurerm_resource_group" "core" {
  name     = local.core_rg_name
  location = var.location
  tags     = merge(var.common_tags, { area = "core" })
}

# Log Analytics Workspace (observability base layer)
resource "azurerm_log_analytics_workspace" "core" {
  name = "${var.prefix}-${var.env}-weu-law-core"
  location = var.location
  resource_group_name = azurerm_resource_group.core.name

  sku = "PerGB2018"
  retention_in_days = 30

  tags = merge(var.common_tags, { area = "observability" })
}

# Platform Storage Account (logs/artifacts etc.)
resource "azurerm_storage_account" "core" {
  name = local.storage_account_name
  location = var.location
  resource_group_name = azurerm_resource_group.core.name
  account_tier = "Standard"
  account_replication_type = "LRS"
  account_kind = "StorageV2"

  min_tls_version = "TLS1_2"
  allow_nested_items_to_be_public = false
  public_network_access_enabled = true

  tags = merge(var.common_tags, { area = "platform-storage" })
}

# Platform Key Vault (secrets for core + workloads)
resource "azurerm_key_vault" "core" {
  name = local.key_vault_name
  location = var.location
  resource_group_name = azurerm_resource_group.core.name
  tenant_id = data.azurerm_client_config.current.tenant_id
  sku_name = "standard"
  soft_delete_retention_days = 7
  purge_protection_enabled = true
  enabled_for_disk_encryption = false

  # MVP: RBAC-based access, network tightened later
  public_network_access_enabled = true

  tags = merge(var.common_tags, { area = "platform-kv" })
}

# Virtual Network
resource "azurerm_virtual_network" "core" {
  name                = local.vnet_name
  location            = var.location
  resource_group_name = azurerm_resource_group.core.name

  address_space = var.vnet_address_space

  tags = merge(var.common_tags, { area = "network" })
}

# Subnet: app
resource "azurerm_subnet" "app" {
  name                 = "${var.prefix}-${var.env}-weu-snet-app"
  resource_group_name  = azurerm_resource_group.core.name
  virtual_network_name = azurerm_virtual_network.core.name

  address_prefixes = [var.app_subnet_prefix]
}

# Subnet: data
resource "azurerm_subnet" "data" {
  name                 = "${var.prefix}-${var.env}-weu-snet-data"
  resource_group_name  = azurerm_resource_group.core.name
  virtual_network_name = azurerm_virtual_network.core.name

  address_prefixes = [var.data_subnet_prefix]
}

# NSG for app subnet
resource "azurerm_network_security_group" "app" {
  name                = local.nsg_app_name
  location            = var.location
  resource_group_name = azurerm_resource_group.core.name

  security_rule {
    name                       = "allow-vnet-inbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
  }

  security_rule {
    name                       = "allow-internet-outbound"
    priority                   = 200
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "Internet"
  }

  security_rule {
    name                       = "deny-all-inbound"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = merge(var.common_tags, { area = "network-nsg-app" })
}

resource "azurerm_subnet_network_security_group_association" "app" {
  subnet_id                 = azurerm_subnet.app.id
  network_security_group_id = azurerm_network_security_group.app.id
}
