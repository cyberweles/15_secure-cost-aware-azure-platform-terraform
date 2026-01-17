output "core_rg_name" {
  description = "Name of the core resource group."
  value       = azurerm_resource_group.core.name
}

output "core_rg_id" {
  description = "Resource ID of the core resource group."
  value = azurerm_resource_group.core.id
}

output "vnet_name" {
  description = "Name of the core virtual network."
  value       = azurerm_virtual_network.core.name
}

output "app_subnet_name" {
  description = "Name of the app subnet."
  value       = azurerm_subnet.app.name
}

output "data_subnet_name" {
  description = "Name of the data subnet."
  value       = azurerm_subnet.data.name
}

output "log_analytics_workspace_name" {
  description = "Name of the Log Analytics workspace."
  value = azurerm_log_analytics_workspace.core.name
}

output "log_analytics_workspace_id" {
  description = "Resource ID of the Log Analytics workspace."
  value = azurerm_log_analytics_workspace.core.id
}

output "storage_account_name" {
  description = "Name of the platform storage account."
  value = azurerm_storage_account.core.name
}

output "key_vault_name" {
  description = "Name of the platform Key Vault."
  value = azurerm_key_vault.core.name
}