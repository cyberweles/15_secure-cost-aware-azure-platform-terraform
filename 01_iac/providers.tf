terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}

  subscription_id = "643e2b26-f9dc-4e2c-91c1-c8fc01c7f14d"
  tenant_id = "d7305505-55a5-4977-a779-76c79ca6a79d"
}
