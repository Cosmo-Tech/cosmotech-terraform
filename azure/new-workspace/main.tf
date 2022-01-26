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

data "azuread_service_principal" "app_platform" {
  display_name = var.app_platform_name
}

data "azuread_service_principal" "app_adt" {
  display_name = var.app_adt_name
}

data "azurerm_storage_account" "terraform_account" {
  name                 = var.storage_account_name
  resource_group_name  = var.resource_group
}

data "azurerm_storage_container" "terraform_container" {
  name                 = "terraform"
  storage_account_name = data.azurerm_storage_account.terraform_account.name
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
  principal_id         = data.azuread_service_principal.app_adt.id
}

# Event Hub
resource "azurerm_eventhub" "eventhub" {
  name                = local.resource_name
  namespace_name      = var.eventhub_namespace_name
  resource_group_name = var.resource_group
  partition_count     = 1
  message_retention   = 1
}

resource "azurerm_eventhub_consumer_group" "eventhub_consumer_adx" {
  name               = local.eventhub_consumer_adx
  namespace_name      = var.eventhub_namespace_name
  eventhub_name       = azurerm_eventhub.eventhub.name
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
  principal_id         = data.azuread_service_principal.app_platform.id
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
  name                = "WorkspaceGroupAssignment"
  resource_group_name = var.resource_group
  cluster_name        = var.adx_name
  database_name       = azurerm_kusto_database.database.name

  tenant_id      = var.tenant_id
  principal_id   = azuread_group.workspace_group.object_id
  principal_type = "Group"
  role           = "Admin"
}

resource "azurerm_kusto_database_principal_assignment" "adx_assignment_platform" {
  name                = "PlatformAssignment"
  resource_group_name = var.resource_group
  cluster_name        = var.adx_name
  database_name       = azurerm_kusto_database.database.name

  tenant_id      = var.tenant_id
  principal_id   = data.azuread_service_principal.app_platform.id
  principal_type = "App"
  role           = "Admin"
}

resource "azurerm_storage_blob" "kusto_script_blob" {
  name                   = "initdb.kusto"
  storage_account_name   = data.azurerm_storage_account.terraform_account.name
  storage_container_name = data.azurerm_storage_container.terraform_container.name
  type                   = "Block"
  source_content         = <<EOT
//
// Streaming ingestion
.alter database ['${local.resource_name}'] policy streamingingestion enable
//
// Batching ingestion
.alter database ['${local.resource_name}'] policy ingestionbatching '{"MaximumBatchingTimeSpan": "00:00:15"}'
//
// ProbesMeasures table
.create table ProbesMeasures(
SimulationRun:guid,
SimulationDate:datetime,
SimulationName:string,
ProbeDate:datetime,
ProbeName:string,
ProbeRun:long,
ProbeType:string,
SimulatedDate:datetime,
CommonRaw:dynamic,
FactsRaw:dynamic)
//
// Ingestion mapping
.create table ProbesMeasures ingestion json mapping "ProbesMeasuresMapping"
    '['
    '    { "column" : "SimulationRun", "Properties":{"Path":"$.simulation.run"}},'
    '    { "column" : "SimulationDate", "Properties":{"Path":"$.simulation.date"}},'
    '    { "column" : "SimulationName", "Properties":{"Path":"$.simulation.name"}},'
    '    { "column" : "ProbeDate", "Properties":{"Path":"$.probe.date"}},'
    '    { "column" : "ProbeName", "Properties":{"Path":"$.probe.name"}},'
    '    { "column" : "ProbeRun", "Properties":{"Path":"$.probe.run"}},'
    '    { "column" : "ProbeType", "Properties":{"Path":"$.probe.type"}},'
    '    { "column" : "SimulatedDate", "Properties":{"Path":"$.facts_common.MeasureDate"}},'
    '    { "column" : "CommonRaw", "Properties":{"Path":"$.facts_common"}},'
    '    { "column" : "FactsRaw", "Properties":{"Path":"$.facts"}},'
    ']'
EOT
}

data "azurerm_storage_account_blob_container_sas" "kusto_script_sas" {
  connection_string = data.azurerm_storage_account.terraform_account.primary_connection_string
  container_name    = data.azurerm_storage_container.terraform_container.name
  https_only        = true

  start  = formatdate("YYYY-MM-DD", timestamp())
  expiry = formatdate("YYYY-MM-DD", timeadd(timestamp(), "1h"))

  permissions {
    read   = true
    add    = false
    create = false
    write  = true
    delete = false
    list   = true
  }
}

resource "azurerm_kusto_script" "kusto_script" {
  name                               = "initdb"
  database_id                        = azurerm_kusto_database.database.id
  url                                = azurerm_storage_blob.kusto_script_blob.id
  sas_token                          = data.azurerm_storage_account_blob_container_sas.kusto_script_sas.sas
  continue_on_errors_enabled         = true
  force_an_update_when_value_changed = "first"
}

resource "azurerm_kusto_eventhub_data_connection" "adx_eventhub_connection" {
  depends_on          = [azurerm_kusto_script.kusto_script]
  name                = "${local.resource_name}-probesmeasures"
  resource_group_name = var.resource_group
  location            = var.location
  cluster_name        = var.adx_name
  database_name       = azurerm_kusto_database.database.name

  eventhub_id    = azurerm_eventhub.eventhub.id
  consumer_group = azurerm_eventhub_consumer_group.eventhub_consumer_adx.name

  table_name        = "ProbesMeasures"
  mapping_rule_name = "ProbesMeasuresMapping"
  data_format       = "JSON"
  compression       = "GZip"
}
