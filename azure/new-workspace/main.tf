terraform {
  cloud {
    organization = "cosmotech"

    workspaces {
      name = "azure-new-workspace"
    }
  }
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

