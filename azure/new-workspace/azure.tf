terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.91.0"
    },
    azuread = {
      source = "hashicorp/azuread"
      version = "2.15.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

provider "azuread" {
  tenant_id = "${var.tenant_id}"
}
