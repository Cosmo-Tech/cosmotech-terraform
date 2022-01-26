locals {
  resource_name         = lower("${var.organization_id}-${var.workspace_key}")
  eventhub_consumer_adx = "adx"
}

data "azuread_user" "owner" {
  user_principal_name = "${var.owner_sp_name}"
}

data "azurerm_eventhub_namespace" "eventhub_namespace" {
  name                = var.eventhub_namespace_name
  resource_group_name = var.resource_group
}

# create the Azure AD resource group
resource "azuread_group" "workspace_group" {
  display_name     = "Workspace-${local.resource_name}"
  owners           = [data.azuread_user.owner.object_id]
  security_enabled = true
  members          = [data.azuread_user.owner.object_id]
}

# ADT instance
resource "azurerm_digital_twins_instance" "adt" {
  name                = local.resource_name
  resource_group_name = var.resource_group
  location            = var.location

  tags = {
    creator = "terraform"
    organization = var.organization_id
    workspace = var.workspace_key
  }
}

resource "azurerm_role_assignment" "adt_owner" {
  scope                = azurerm_digital_twins_instance.adt.id
  role_definition_name = "Owner"
  principal_id         = azuread_group.workspace_group.object_id
}

resource "azurerm_role_assignment" "adt_data_owner" {
  scope                = azurerm_digital_twins_instance.adt.id
  role_definition_name = "Azure Digital Twins Data Owner"
  principal_id         = azuread_group.workspace_group.object_id
}

resource "azurerm_role_assignment" "adt_data_owner_app" {
  scope                = azurerm_digital_twins_instance.adt.id
  role_definition_name = "Azure Digital Twins Data Owner"
  principal_id         = var.app_adt_oid
}

# Event Hub
resource "azurerm_eventhub" "eventhub" {
  name                = local.resource_name
  namespace_name      = var.eventhub_namespace_name
  resource_group_name = var.resource_group
  partition_count     = 1
  message_retention   = 1
}

resource "time_sleep" "wait_eventhub_creation" {
  depends_on = [azurerm_eventhub.eventhub]

  create_duration = "10s"
}
resource "azurerm_eventhub_consumer_group" "eventhub_consumer_adx" {
  depends_on = [time_sleep.wait_eventhub_creation] 
  name               = local.eventhub_consumer_adx
  namespace_name      = var.eventhub_namespace_name
  eventhub_name       = local.resource_name
  resource_group_name = var.resource_group
}

resource "azurerm_role_assignment" "eventhub_owner" {
  scope                = azurerm_eventhub.eventhub.id
  role_definition_name = "Owner"
  principal_id         = azuread_group.workspace_group.object_id
}

resource "azurerm_role_assignment" "eventhub_owner_app" {
  scope                = azurerm_eventhub.eventhub.id
  role_definition_name = "Azure Event Hubs Data Sender"
  principal_id         = var.app_platform_oid
}

# ADX
resource "azurerm_kusto_database" "database" {
  name                = local.resource_name
  resource_group_name = var.resource_group
  location            = var.location
  cluster_name        = var.adx_name

  hot_cache_period   = "P31D"
  soft_delete_period = "P365D"
}

resource "azurerm_kusto_database_principal_assignment" "adx_assignment_group" {
  name                = "KustoPrincipalAssignment"
  resource_group_name = var.resource_group
  cluster_name        = var.adx_name
  database_name       = local.resource_name

  tenant_id      = var.tenant_id
  principal_id   = azuread_group.workspace_group.object_id
  principal_type = "Group"
  role           = "Admin"
}

resource "azurerm_kusto_database_principal_assignment" "adx_assignment_platform" {
  name                = "KustoPrincipalAssignment"
  resource_group_name = var.resource_group
  cluster_name        = var.adx_name
  database_name       = local.resource_name

  tenant_id      = var.tenant_id
  principal_id   = var.app_platform_oid
  principal_type = "App"
  role           = "Admin"
}

resource "azurerm_kusto_eventhub_data_connection" "adx_eventhub_connection" {
  name                = "${local.resource_name}-probesmeasures"
  resource_group_name = var.resource_group
  location            = var.location
  cluster_name        = var.adx_name
  database_name       = local.resource_name

  eventhub_id    = azurerm_eventhub.eventhub.id
  consumer_group = azurerm_eventhub_consumer_group.eventhub_consumer_adx.name

  table_name        = "ProbesMeasures"
  mapping_rule_name = "ProbesMeasuresMapping"
  data_format       = "JSON"
  compression       = "GZip"
}
