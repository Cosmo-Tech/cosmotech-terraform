locals {
  tenant_prefix = lower("csm${var.tenant_name}")
  dbName = "phoenix-core"
}

resource "azurerm_cosmosdb_account" "db" {
  name                = "${local.tenant_prefix}db"
  location            = var.location
  resource_group_name = var.resource_group_name
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
  resource_group_name = var.resource_group_name
  account_name        = azurerm_cosmosdb_account.db.name
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