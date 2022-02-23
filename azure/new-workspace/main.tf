locals {
  resource_name         = lower("${var.organization_id}-${var.workspace_key}")
  eventhub_consumer_adx = "adx"
  eventhub_probesmeasures = "probesmeasures"
  eventhub_scenariorun  = "scenariorun"
}

data "azuread_user" "owner" {
  count = var.aad_groups_and_assignements ? 1 : 0
  user_principal_name = "${var.owner_sp_name}"
}

data "azuread_users" "members" {
  count = var.aad_groups_and_assignements ? 1 : 0
  user_principal_names = var.aad_group_members
}

data "azurerm_eventhub_namespace" "eventhub_namespace" {
  count               = var.dedicated_eventhub_namespace ? 0 : 1
  name                = var.eventhub_namespace_name
  resource_group_name = var.resource_group
}

data "azuread_service_principal" "app_platform" {
  count = var.aad_groups_and_assignements ? 1 : 0
  display_name = var.app_platform_name
}

data "azuread_service_principal" "app_adt" {
  count = var.aad_groups_and_assignements ? 1 : 0
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
  count = var.aad_groups_and_assignements ? 1 : 0
  display_name     = "Workspace-${local.resource_name}"
  owners           = [data.azuread_user.owner[0].object_id]
  security_enabled = true
  members          = data.azuread_users.members[0].object_ids
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
  count = var.aad_groups_and_assignements ? 1 : 0
  scope                = azurerm_digital_twins_instance.adt.id
  role_definition_name = "Owner"
  principal_id         = azuread_group.workspace_group[0].object_id
}

resource "azurerm_role_assignment" "adt_data_owner" {
  count = var.aad_groups_and_assignements ? 1 : 0
  scope                = azurerm_digital_twins_instance.adt.id
  role_definition_name = "Azure Digital Twins Data Owner"
  principal_id         = azuread_group.workspace_group[0].object_id
}

resource "azurerm_role_assignment" "adt_data_owner_app" {
  count = var.aad_groups_and_assignements ? 1 : 0
  scope                = azurerm_digital_twins_instance.adt.id
  role_definition_name = "Azure Digital Twins Data Owner"
  principal_id         = data.azuread_service_principal.app_adt[0].id
}

# Event Hub
resource "azurerm_eventhub_namespace" "eventhub_namespace" {
  count               = var.dedicated_eventhub_namespace ? 1 : 0
  name                = local.resource_name
  location            = var.location
  resource_group_name = var.resource_group
  sku                 = "Standard"
  capacity            = var.eventhub_namespace_capacity

  tags = {
    creator = "terraform"
    organization = var.organization_id
    workspace = var.workspace_key
  }
}

resource "azurerm_role_assignment" "eventhub_namespace_owner" {
  count                = var.aad_groups_and_assignements && var.dedicated_eventhub_namespace ? 1 : 0
  scope                = azurerm_eventhub_namespace.eventhub_namespace[0].id
  role_definition_name = "Owner"
  principal_id         = azuread_group.workspace_group[0].object_id
}

resource "azurerm_eventhub" "eventhub_probesmeasures" {
  name                = var.dedicated_eventhub_namespace ? local.eventhub_probesmeasures : local.resource_name
  namespace_name      = var.dedicated_eventhub_namespace ? azurerm_eventhub_namespace.eventhub_namespace[0].name : var.eventhub_namespace_name
  resource_group_name = var.resource_group
  partition_count     = 1
  message_retention   = 1
}

resource "azurerm_eventhub_consumer_group" "eventhub_probesmeasures_consumer_adx" {
  name               = local.eventhub_consumer_adx
  namespace_name      = var.dedicated_eventhub_namespace ? azurerm_eventhub_namespace.eventhub_namespace[0].name : var.eventhub_namespace_name
  eventhub_name       = azurerm_eventhub.eventhub_probesmeasures.name
  resource_group_name = var.resource_group
}

resource "azurerm_role_assignment" "eventhub_probesmeasures_owner" {
  count = var.aad_groups_and_assignements ? 1 : 0
  scope                = azurerm_eventhub.eventhub_probesmeasures.id
  role_definition_name = "Owner"
  principal_id         = azuread_group.workspace_group[0].object_id
}

resource "azurerm_role_assignment" "eventhub_probesmeasures_owner_app" {
  count = var.aad_groups_and_assignements ? 1 : 0
  scope                = azurerm_eventhub.eventhub_probesmeasures.id
  role_definition_name = "Azure Event Hubs Data Sender"
  principal_id         = data.azuread_service_principal.app_platform[0].id
}

resource "azurerm_eventhub" "eventhub_scenariorun" {
  name                = var.dedicated_eventhub_namespace ? local.eventhub_scenariorun : "${local.resource_name}-${local.eventhub_scenariorun}"
  namespace_name      = var.dedicated_eventhub_namespace ? azurerm_eventhub_namespace.eventhub_namespace[0].name : var.eventhub_namespace_name
  resource_group_name = var.resource_group
  partition_count     = 1
  message_retention   = 1
}

resource "azurerm_eventhub_consumer_group" "eventhub_scenariorun_consumer_adx" {
  name               = local.eventhub_consumer_adx
  namespace_name      = var.dedicated_eventhub_namespace ? azurerm_eventhub_namespace.eventhub_namespace[0].name : var.eventhub_namespace_name
  eventhub_name       = azurerm_eventhub.eventhub_scenariorun.name
  resource_group_name = var.resource_group
}

resource "azurerm_role_assignment" "eventhub_scenariorun_owner" {
  count = var.aad_groups_and_assignements ? 1 : 0
  scope                = azurerm_eventhub.eventhub_scenariorun.id
  role_definition_name = "Owner"
  principal_id         = azuread_group.workspace_group[0].object_id
}

resource "azurerm_role_assignment" "eventhub_scenariorun_owner_app" {
  count = var.aad_groups_and_assignements ? 1 : 0
  scope                = azurerm_eventhub.eventhub_scenariorun.id
  role_definition_name = "Azure Event Hubs Data Sender"
  principal_id         = data.azuread_service_principal.app_platform[0].id
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
  count = var.aad_groups_and_assignements ? 1 : 0
  name                = "WorkspaceGroupAssignment"
  resource_group_name = var.resource_group
  cluster_name        = var.adx_name
  database_name       = azurerm_kusto_database.database.name

  tenant_id      = var.tenant_id
  principal_id   = azuread_group.workspace_group[0].object_id
  principal_type = "Group"
  role           = "Admin"
}

resource "azurerm_kusto_database_principal_assignment" "adx_assignment_platform" {
  count = var.aad_groups_and_assignements ? 1 : 0
  name                = "PlatformAssignment"
  resource_group_name = var.resource_group
  cluster_name        = var.adx_name
  database_name       = azurerm_kusto_database.database.name

  tenant_id      = var.tenant_id
  principal_id   = data.azuread_service_principal.app_platform[0].id
  principal_type = "App"
  role           = "Admin"
}

resource "azurerm_storage_blob" "kusto_script_blob" {
  count                  = var.kusto_script ? 1 : 0
  name                   = "initdb-${local.resource_name}.kusto"
  storage_account_name   = data.azurerm_storage_account.terraform_account.name
  storage_container_name = data.azurerm_storage_container.terraform_container.name
  type                   = "Block"
  source_content         = <<EOT
//
// Streaming ingestion
.alter database ['${local.resource_name}'] policy streamingingestion disable
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
// Probes measures Ingestion mapping
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
//
// Scenario Run Simulation total facts
.create table SimulationTotalFacts(
SimulationId:string,
State:string,
Type:string,
SentMessagesTotal: long,
SentFactsTotal: long)
//
// Simulation total facts ingestion mapping
.create table SimulationTotalFacts ingestion json mapping "SimulationTotalFactsMapping"
    '['
    '    { "column" : "SimulationId", "Properties":{"Path":"$.sagaId"}},'
    '    { "column" : "State", "Properties":{"Path":"$.state"}},'
    '    { "column" : "Type", "Properties":{"Path":"$.type"}},'
    '    { "column" : "SentMessagesTotal", "Properties":{"Path":"$.sentMessagesTotal"}},'
    '    { "column" : "SentFactsTotal", "Properties":{"Path":"$.sentFactsTotal"}},'
    ']'
EOT
}

data "azurerm_storage_account_blob_container_sas" "kusto_script_sas" {
  count                  = var.kusto_script ? 1 : 0
  connection_string = data.azurerm_storage_account.terraform_account.primary_connection_string
  container_name    = data.azurerm_storage_container.terraform_container.name
  https_only        = true

  start  = formatdate("YYYY-MM-DD'T'hh:mm:ssZ", timestamp())
  expiry = formatdate("YYYY-MM-DD'T'hh:mm:ssZ", timeadd(timestamp(), "1h"))

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
  depends_on                         = [azurerm_kusto_database.database]
  count                              = var.kusto_script ? 1 : 0
  name                               = "initdb"
  database_id                        = azurerm_kusto_database.database.id
  url                                = azurerm_storage_blob.kusto_script_blob[0].id
  sas_token                          = data.azurerm_storage_account_blob_container_sas.kusto_script_sas[0].sas
  continue_on_errors_enabled         = true
  force_an_update_when_value_changed = "first"
}

resource "azurerm_kusto_eventhub_data_connection" "adx_eventhub_probesmeasures_connection" {
  depends_on          = [azurerm_kusto_script.kusto_script]
  count                              = var.kusto_script ? 1 : 0
  name                = substr("${local.resource_name}-${local.eventhub_probesmeasures}", 0, 40)
  resource_group_name = var.resource_group
  location            = var.location
  cluster_name        = var.adx_name
  database_name       = azurerm_kusto_database.database.name

  eventhub_id    = azurerm_eventhub.eventhub_probesmeasures.id
  consumer_group = azurerm_eventhub_consumer_group.eventhub_probesmeasures_consumer_adx.name

  table_name        = "ProbesMeasures"
  mapping_rule_name = "ProbesMeasuresMapping"
  data_format       = "JSON"
  compression       = "GZip"
}

resource "azurerm_kusto_eventhub_data_connection" "adx_eventhub_scenariorun_connection" {
  depends_on          = [azurerm_kusto_script.kusto_script]
  count                              = var.kusto_script ? 1 : 0
  name                = substr("${local.resource_name}-${local.eventhub_scenariorun}", 0, 40)
  resource_group_name = var.resource_group
  location            = var.location
  cluster_name        = var.adx_name
  database_name       = azurerm_kusto_database.database.name

  eventhub_id    = azurerm_eventhub.eventhub_scenariorun.id
  consumer_group = azurerm_eventhub_consumer_group.eventhub_scenariorun_consumer_adx.name

  table_name        = "SimulationTotalFacts"
  mapping_rule_name = "SimulationTotalFactsMapping"
  data_format       = "JSON"
  compression       = "None"
}
