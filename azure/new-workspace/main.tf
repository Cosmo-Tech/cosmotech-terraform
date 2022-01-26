# create the Azure AD resource group
data "azuread_user" "owner" {
  user_principal_name = "${var.owner_sp_name}"
}

resource "azuread_group" "workspace_group" {
  display_name     = "Workspace-${var.workspace_key}"
  owners           = [data.azuread_user.owner.object_id]
  security_enabled = true
}

resource "azurerm_digital_twins_instance" "adt" {
  name                = "${var.organization_id}-${var.workspace_key}"
  resource_group_name = "${var.resource_group}"
  location            = "${var.location}"

  tags = {
    creator = "terraform"
    organization = "${var.organization_id}"
    workspace = "${var.workspace_key}"
  }
}

resource "azurerm_role_assignment" "adt_data_owner" {
  scope                = azurerm_digital_twins_instance.adt.id
  role_definition_name = "Azure Digital Twins Data Owner"
  principal_id         = azuread_group.workspace_group.object_id
}
