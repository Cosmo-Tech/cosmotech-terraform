local {
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

# Event Hub
resource "azurerm_eventhub" "eventhub" {
  name                = local.resource_name
  namespace_name      = azurerm_eventhub_namespace.example.name
  resource_group_name = azurerm_resource_group.example.name
  partition_count     = 1
  message_retention   = 1
}

resource "azurerm_eventhub_consumer_group" "eventhub_consumer_adx" {
  name                = local.eventhub_consumer_adx
  namespace_name      = var.eventhub_namespace_name
  eventhub_name       = local.resource_name
  resource_group_name = var.resource_group
}

resource "azurerm_role_assignment" "eventhub_owner" {
  scope                = azurerm_eventhub.evenhub.id
  role_definition_name = "Owner"
  principal_id         = azuread_group.workspace_group.object_id
}

