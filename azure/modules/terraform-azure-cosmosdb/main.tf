locals {
  tenant_prefix = lower("csm${var.tenant_name}")
  dbName = "phoenix-core"
}

data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

data "azurerm_virtual_network" "vnet" {
  count               = var.private_endpoint_enabled ? 1 : 0
  name                = var.private_endpoint_vnet_name
  resource_group_name = data.azurerm_resource_group.rg.name
}

data "azurerm_subnet" "subnet" {
  count                = var.private_endpoint_enabled ? 1 : 0
  name                 = var.private_endpoint_subnet_name
  virtual_network_name = data.azurerm_virtual_network.vnet[0].name
  resource_group_name  = data.azurerm_resource_group.rg.name
}

resource "azurerm_cosmosdb_account" "db" {
  name                = "${local.tenant_prefix}db"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"
  consistency_policy {
    consistency_level       = "Session"
    max_interval_in_seconds = 5
    max_staleness_prefix    = 100
  }
  geo_location {
    location          = var.location
    failover_priority = 0
  }
  capabilities {
    name = "EnableServerless"
  }

  public_network_access_enabled   = !var.private_endpoint_enabled
  enable_automatic_failover       = false
  enable_multiple_write_locations = false
  is_virtual_network_filter_enabled = false
  enable_free_tier                = false
  analytical_storage_enabled      = false
  create_mode                     = "Default"
  backup {
    type                = "Periodic"
    interval_in_minutes = 240
    retention_in_hours  = 8
    storage_redundancy  = "Geo"
  }
}

resource "azurerm_cosmosdb_sql_database" "db" {
  name                = local.dbName
  resource_group_name = data.azurerm_resource_group.rg.name
  account_name        = azurerm_cosmosdb_account.db.name
}

resource "azurerm_private_endpoint" "pe" {
  count               = var.private_endpoint_enabled ? 1 : 0
  name                = "${local.tenant_prefix}pe"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name
  subnet_id           = data.azurerm_subnet.subnet[0].id
  private_service_connection {
    name                           = "${local.tenant_prefix}pe"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_cosmosdb_account.db.id
    subresource_names              = ["sql"]
  }
}

output "cosmosdb_account_resource_group_name" {
  value = azurerm_cosmosdb_account.db.resource_group_name
}

output "cosmosdb_account_name" {
  value = azurerm_cosmosdb_account.db.name
}

output "cosmosdb_sql_database_name" {
  value = azurerm_cosmosdb_sql_database.db.name
}