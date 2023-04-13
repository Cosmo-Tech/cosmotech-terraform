terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.47.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~>2.15.0"
    }
  }

  required_version = ">= 1.3.9"
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
  subscription_id            = var.subscription_id
  client_id                  = var.client_id
  client_secret              = var.client_secret
  tenant_id                  = var.tenant_id
}

provider "azuread" {
  tenant_id     = var.tenant_id
  client_id     = var.client_id
  client_secret = var.client_secret
}
