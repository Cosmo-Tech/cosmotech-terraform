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

