output "app_rg_name" {
  value = azurerm_resource_group.app_main.name
}

output "app_service_name" {
  value = azurerm_linux_web_app.main.name
}

output "app_service_plan" {
  value = azurerm_service_plan.main.name
}

output "app_rg_id" {
  value = azurerm_resource_group.app_main.id
}
