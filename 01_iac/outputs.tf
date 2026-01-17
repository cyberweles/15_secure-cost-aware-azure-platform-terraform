output "core_rg_name" {
    description = "Name of the core resource group."
    value = module.core.core_rg_name
}

output "app_rg_name" {
    description = "Name of the main app resource group."
    value = module.app_main.app_rg_name
}