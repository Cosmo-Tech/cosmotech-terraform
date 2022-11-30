locals {
  pre_name = "Cosmo Tech "
  post_name = " ${var.stage} For ${var.customer} ${var.project}"
  subnet_name = "default"
}

data "azuread_users" "owners" {
  user_principal_names = var.owner_list
}


# Azure AD
resource "azuread_application" "platform" {
  display_name     = "${local.pre_name}Platform${local.post_name}"
  identifier_uris  = [var.identifier_uri]
  logo_image       = filebase64("cosmotech.png")
  owners           = data.azuread_users.owners.object_ids
  sign_in_audience = var.audience

  tags = [ "HideApp", "WindowsAzureActiveDirectoryIntegratedApp", var.stage, var.customer, var.project, "terraformed"]

  required_resource_access {
    resource_app_id = "00000003-0000-0000-c000-000000000000" # Microsoft Graph

    resource_access {
      id   = "e1fe6dd8-ba31-4d61-89e7-88639da4683d" # User.Read
      type = "Scope"
    }
  }

  web {
    homepage_url  = var.platform_url
    redirect_uris = ["${var.platform_url}/swagger-ui/oauth2-redirect.html"]

    implicit_grant {
      access_token_issuance_enabled = false
      id_token_issuance_enabled     = false
    }
  }

  api {
    requested_access_token_version = 2
    oauth2_permission_scope {
      admin_consent_description  = "Allow the application to use the Cosmo Tech Platform with user account"
      admin_consent_display_name = "Cosmo Tech Platform Impersonate"
      enabled                    = true
      id                         = "6332363e-bcba-4c4a-a605-c25f23117400"
      type                       = "User"
      user_consent_description   = "Allow the application to use the Cosmo Tech Platform with your account"
      user_consent_display_name  = "Cosmo Tech Platform Usage"
      value                      = "platform"
		}
  }

  app_role {
    allowed_member_types = [
      "User",
      "Application"
      ]
    description = "Workspace Writer"
    display_name = "Workspace Writer"
    id = "3f7ba86c-9940-43c8-a54d-0bfb706da136"
    enabled = true
    value = "Workspace.Writer"
  }

  app_role {
    allowed_member_types = [
      "User",
      "Application"
      ]
    description = "Workspace Reader"
    display_name = "Workspace Reader"
    id = "73ce2073-d918-4fe1-bc24-a4e69db07db8"
    enabled = true
    value = "Workspace.Reader"
  }

  app_role {
    allowed_member_types = [
      "User",
      "Application"
      ]
    description = "Solution Writer"
    display_name = "Solution Writer"
    id = "4f6e62a3-7f0a-4396-9620-ab465cd6577b"
    enabled = true
    value = "Solution.Writer"
  }

  app_role {
    allowed_member_types = [
      "User",
      "Application"
      ]
    description = "Solution Reader"
    display_name = "Solution Reader"
    id = "cf1a8625-38d9-417b-a5b9-a27c0014e740"
    enabled = true
    value = "Solution.Reader"
  }

  app_role {
    allowed_member_types = [
      "User",
      "Application"
      ]
    description = "ScenarioRun Writer"
    display_name = "ScenarioRun Writer"
    id = "ca8a2a19-3e09-48cc-976b-85ec9de4f68a"
    enabled = true
    value = "ScenarioRun.Writer"
  }

  app_role {
    allowed_member_types = [
      "User",
      "Application"
      ]
    description = "ScenarioRun Reader"
    display_name = "ScenarioRun Reader"
    id = "bdc8fe2a-73a8-477d-9efa-d8a37a4eb0f7"
    enabled = true
    value = "ScenarioRun.Reader"
  }

  app_role {
    allowed_member_types = [
      "User",
      "Application"
      ]
    description = "Scenario Writer"
    display_name = "Scenario Writer"
    id = "8fb9d03e-c46d-4003-a2a6-34d8b506e4e7"
    enabled = true
    value = "Scenario.Writer"
  }

  app_role {
    allowed_member_types = [
      "User",
      "Application"
      ]
    description = "Scenario Reader"
    display_name = "Scenario Reader"
    id = "e07dab65-4200-4502-8e36-79ca687320d9"
    enabled = true
    value = "Scenario.Reader"
  }

  app_role {
    allowed_member_types = [
      "User",
      "Application"
      ]
    description = "Organization Writer"
    display_name = "Organization Writer"
    id = "89d74995-095c-442f-bfda-06a77d3dbaa4"
    enabled = true
    value = "Organization.Writer"
  }

  app_role {
    allowed_member_types = [
      "User",
      "Application"
      ]
    description = "Organization Reader"
    display_name = "Organization Reader"
    id = "96213509-202a-497c-9f60-53c5f85268ec"
    enabled = true
    value = "Organization.Reader"
  }

  app_role {
    allowed_member_types = [
      "User",
      "Application"
      ]
    description = "Dataset Writer"
    display_name = "Dataset Writer"
    id = "c6e5d483-ec2c-4710-bf0c-78b0fda611dc"
    enabled = true
    value = "Dataset.Writer"
  }

  app_role {
    allowed_member_types = [
      "User",
      "Application"
      ]
    description = "Dataset Reader"
    display_name = "Dataset Reader"
    id = "454dc3f5-3012-45b3-bad6-975dae94338c"
    enabled = true
    value = "Dataset.Reader"
  }

  app_role {
    allowed_member_types = [
      "User",
      "Application"
      ]
    description = "Ability to write connectors"
    display_name = "Connector Writer"
    id = "e150953f-4835-4502-b95e-81d9ce97f591"
    enabled = true
    value = "Connector.Writer"
  }

  app_role {
    allowed_member_types = [
      "User",
      "Application"
      ]
    description = "Organization Viewer"
    display_name = "Organization Viewer"
    id = "ec5fdd3c-4df0-4c2f-bdad-0495a49f6e90"
    enabled = true
    value = "Organization.Viewer"
  }

  app_role {
    allowed_member_types = [
      "User",
      "Application"
      ]
    description = "Organization User"
    display_name = "Organization User"
    id = "bb9ffb73-997e-4320-8625-cfe45469aa3c"
    enabled = true
    value = "Organization.User"
  }

  app_role {
    allowed_member_types = [
      "User",
      "Application"
      ]
    description = "Organization Modeler"
    display_name = "Organization Modeler"
    id = "adcdb0a1-1588-4d2b-8657-364e544ac7e1"
    enabled = true
    value = "Organization.Modeler"
  }

  app_role {
    allowed_member_types = [
      "User",
      "Application"
      ]
    description = "Organization Administrator"
    display_name = "Organization Admin"
    id = "04b96a76-d77e-4a9d-967f-c55c857c478c"
    enabled = true
    value = "Organization.Admin"
  }

  app_role {
    allowed_member_types = [
      "User",
      "Application"
      ]
    description = "Organization Collaborator"
    display_name = "Organization Collaborator"
    id = "6f5ec4e3-1f2d-4502-837e-5d9754ea8acb"
    enabled = true
    value = "Organization.Collaborator"
  }

  app_role {
    allowed_member_types = [
      "User",
      "Application"
      ]
    description = "Ability to develop connectors"
    display_name = "Connector Developer"
    id = "428ab58e-ab61-4621-907c-d7908be72df7"
    enabled = true
    value = "Connector.Developer"
  }

  app_role {
    allowed_member_types = [
      "User",
      "Application"
      ]
    description = "Ability to read connectors"
    display_name = "Connector Reader"
    id = "2cd74037-3ccd-4ab7-929d-4afce87be2e4"
    enabled = true
    value = "Connector.Reader"
  }

  app_role {
    allowed_member_types = [
      "User",
      "Application"
      ]
    description = "Platform Administrator"
    display_name = "Platform Admin"
    id = "bb49d61f-8b6a-4a19-b5bd-06a29d6b8e60"
    enabled = true
    value = "Platform.Admin"
  }
} 

resource "azuread_service_principal" "platform" {
  application_id               = azuread_application.platform.application_id
  # assignment required to secure Function Apps using thi App Registration as identity provider
  app_role_assignment_required = true

  tags = ["cosmotech", var.stage, var.customer, var.project, "HideApp", "WindowsAzureActiveDirectoryIntegratedApp", "terraformed"]
}

resource "azuread_application_password" "platform_password" {
  application_object_id = azuread_application.platform.object_id
  end_date_relative = "4464h"
}


resource "azuread_application" "network_adt" {
  display_name     = "${local.pre_name}Network and ADT${local.post_name}"
  logo_image       = filebase64("cosmotech.png")
  owners           = data.azuread_users.owners.object_ids
  sign_in_audience = "AzureADMyOrg"

  tags = [ "HideApp", "WindowsAzureActiveDirectoryIntegratedApp", var.stage, var.customer, var.project, "terraformed"]
}

resource "azuread_service_principal" "network_adt" {
  depends_on                   = [azuread_service_principal.platform]
  application_id               = azuread_application.network_adt.application_id
  app_role_assignment_required = false

  tags = ["cosmotech", var.stage, var.customer, var.project, "HideApp", "WindowsAzureActiveDirectoryIntegratedApp", "terraformed"]
}

resource "azuread_application_password" "network_adt_password" {
  application_object_id = azuread_application.network_adt.object_id
  end_date_relative = "4464h"
}

resource "azuread_application" "swagger" {
  display_name     = "${local.pre_name}Swagger${local.post_name}"
  logo_image       = filebase64("cosmotech.png")
  owners           = data.azuread_users.owners.object_ids
  sign_in_audience = var.audience

  tags = [ "HideApp", "WindowsAzureActiveDirectoryIntegratedApp", var.stage, var.customer, var.project, "terraformed"]

  required_resource_access {
    resource_app_id = "00000003-0000-0000-c000-000000000000" # Microsoft Graph

    resource_access {
      id   = "e1fe6dd8-ba31-4d61-89e7-88639da4683d" # User.Read
      type = "Scope"
    }
  }

  required_resource_access {
    resource_app_id = azuread_application.platform.application_id # Cosmo Tech Platform

    resource_access {
      id   = "6332363e-bcba-4c4a-a605-c25f23117400" # platform
      type = "Scope"
    }
  }

  web {
    homepage_url  = var.platform_url
    redirect_uris = ["${var.platform_url}/swagger-ui/oauth2-redirect.html"]

    implicit_grant {
      access_token_issuance_enabled = true
      id_token_issuance_enabled     = false
    }
  }
}

resource "azuread_service_principal" "swagger" {
  depends_on                   = [azuread_service_principal.network_adt]
  application_id               = azuread_application.swagger.application_id
  app_role_assignment_required = false

  tags = ["cosmotech", var.stage, var.customer, var.project, "HideApp", "WindowsAzureActiveDirectoryIntegratedApp", "terraformed"]
}


resource "azuread_application" "restish" {
  count            = var.create_restish ? 1 : 0
  display_name     = "${local.pre_name}Restish${local.post_name}"
  logo_image       = filebase64("cosmotech.png")
  owners           = data.azuread_users.owners.object_ids
  sign_in_audience = var.audience

  tags = [ "HideApp", "WindowsAzureActiveDirectoryIntegratedApp", var.stage, var.customer, var.project, "terraformed"]

  required_resource_access {
    resource_app_id = "00000003-0000-0000-c000-000000000000" # Microsoft Graph

    resource_access {
      id   = "e1fe6dd8-ba31-4d61-89e7-88639da4683d" # User.Read
      type = "Scope"
    }
  }

  required_resource_access {
    resource_app_id = azuread_application.platform.application_id # Cosmo Tech Platform

    resource_access {
      id   = "6332363e-bcba-4c4a-a605-c25f23117400" # platform
      type = "Scope"
    }
  }

  web {
    homepage_url  = var.platform_url
    redirect_uris = ["http://localhost:8484/"]

    implicit_grant {
      access_token_issuance_enabled = true
      id_token_issuance_enabled     = true
    }
  }
}

resource "azuread_service_principal" "restish" {
  depends_on                   = [azuread_service_principal.swagger]
  count            = var.create_restish ? 1 : 0
  application_id               = azuread_application.restish[0].application_id
  app_role_assignment_required = false

  tags = ["cosmotech", var.stage, var.customer, var.project, "HideApp", "WindowsAzureActiveDirectoryIntegratedApp", "terraformed"]
}

resource "azuread_application_password" "restish_password" {
  count            = var.create_restish ? 1 : 0
  application_object_id = azuread_application.restish[0].object_id
  end_date_relative = "4464h"
}

resource "azuread_application" "powerbi" {
  count            = var.create_powerbi ? 1 : 0
  display_name     = "${local.pre_name}PowerBI${local.post_name}"
  logo_image       = filebase64("cosmotech.png")
  owners           = data.azuread_users.owners.object_ids
  sign_in_audience = "AzureADMyOrg"

  tags = [ "HideApp", "WindowsAzureActiveDirectoryIntegratedApp", var.stage, var.customer, var.project, "terraformed"]
}

resource "azuread_service_principal" "powerbi" {
  depends_on                   = [azuread_service_principal.swagger]
  count            = var.create_powerbi ? 1 : 0
  application_id               = azuread_application.powerbi[0].application_id
  app_role_assignment_required = false

  tags = ["cosmotech", var.stage, var.customer, var.project, "HideApp", "WindowsAzureActiveDirectoryIntegratedApp", "terraformed"]
}


resource "azuread_application" "webapp" {
  display_name     = "${local.pre_name}Web App${local.post_name}"
  logo_image       = filebase64("cosmotech.png")
  owners           = data.azuread_users.owners.object_ids
  sign_in_audience = var.audience

  tags = [ "HideApp", "WindowsAzureActiveDirectoryIntegratedApp", var.stage, var.customer, var.project, "terraformed"]

  required_resource_access {
    resource_app_id = "00000003-0000-0000-c000-000000000000" # Microsoft Graph

    resource_access {
      id   = "e1fe6dd8-ba31-4d61-89e7-88639da4683d" # User.Read
      type = "Scope"
    }
  }

  required_resource_access {
    resource_app_id = azuread_application.platform.application_id # Cosmo Tech Platform

    resource_access {
      id   = "6332363e-bcba-4c4a-a605-c25f23117400" # platform
      type = "Scope"
    }
  }

  single_page_application {
    redirect_uris = ["http://localhost:3000/scenario", "${var.webapp_url}/platform"]
  }
}

resource "azuread_service_principal" "webapp" {
  depends_on                   = [azuread_service_principal.swagger]
  application_id               = azuread_application.webapp.application_id
  app_role_assignment_required = false

  tags = ["cosmotech", var.stage, var.customer, var.project, "HideApp", "WindowsAzureActiveDirectoryIntegratedApp", "terraformed"]
}

# create the Azure AD resource group
resource "azuread_group" "platform_group" {
  display_name     = "Cosmotech-Platform-${var.customer}-${var.project}-${var.stage}"
  owners           = data.azuread_users.owners.object_ids
  security_enabled = true
  members          = data.azuread_users.owners.object_ids
}

# Resource group
resource "azurerm_resource_group" "platform_rg" {
  name     = var.resource_group
  location = var.location
  tags = {
    vendor   = "cosmotech"
    stage    = var.stage
    customer = var.customer
    project  = var.project
  }
}

resource "azurerm_role_assignment" "rg_owner" {
  scope                = azurerm_resource_group.platform_rg.id
  role_definition_name = "Owner"
  principal_id         = azuread_group.platform_group.object_id
}

# Public IP
resource "azurerm_public_ip" "publicip" {
  count               = var.create_publicip && !var.new_tenant ? 1 : 0
  name                = "CosmoTech${var.customer}${var.project}${var.stage}PublicIP"
  resource_group_name = azurerm_resource_group.platform_rg.name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    vendor   = "cosmotech"
    stage    = var.stage
    customer = var.customer
    project  = var.project
  }
}

resource "azurerm_role_assignment" "publicip_contributor" {
  count                = var.create_publicip && !var.new_tenant  ? 1 : 0
  scope                = azurerm_resource_group.platform_rg.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.network_adt.id
}

resource "azurerm_dns_a_record" "platform_fqdn" {
  depends_on          = [azurerm_public_ip.publicip]
  count               = var.create_publicip && var.create_dnsrecord && !var.new_tenant  ? 1 : 0
  name                = var.dns_record
  zone_name           = var.dns_zone_name
  resource_group_name = var.dns_zone_rg
  ttl                 = 300
  target_resource_id  = azurerm_public_ip.publicip[0].id
}

# Virtual Network
resource "azurerm_virtual_network" "platform_vnet" {
  count               = var.create_vnet && !var.new_tenant  ? 1 : 0
  name                = "CosmoTech${var.customer}${var.project}${var.stage}VNet"
  location            = var.location
  resource_group_name = azurerm_resource_group.platform_rg.name
  address_space       = [var.vnet_iprange]

  subnet {
    name           = local.subnet_name
    address_prefix = var.vnet_iprange
  }

  tags = {
    vendor   = "cosmotech"
    stage    = var.stage
    customer = var.customer
    project  = var.project
  }
}

resource "azurerm_role_assignment" "vnet_network_contributor" {
  count                = var.create_vnet && !var.new_tenant  ? 1 : 0
  scope                = azurerm_virtual_network.platform_vnet[0].id
  role_definition_name = "Network Contributor"
  principal_id         = azuread_service_principal.network_adt.id
}

output "out_platform_name" {
  value = azuread_application.platform.display_name
}

output "out_tenant_id" {
  value = var.tenant_id
}

output "out_platform_clientid" {
  value = azuread_application.platform.application_id
}

output "out_platform_password" {
  value = azuread_application_password.platform_password.value
  sensitive = true
}

output "out_nerworkadt_name" {
  value = azuread_application.network_adt.display_name
}

output "out_networkadt_clientid" {
  value = azuread_application.network_adt.application_id
}

output "out_network_adt_password" {
  value = azuread_application_password.network_adt_password.value
  sensitive = true
}

output "out_platform_url" {
  value = var.platform_url
}

output "out_identifier_uri" {
  value = var.identifier_uri
}

output "out_swagger_name" {
  value = azuread_application.swagger.display_name
}

output "out_swagger_clientid" {
  value = azuread_application.swagger.application_id
}

output "out_restish_password" {
  value = azuread_application_password.restish_password[0].value
  sensitive = true
}

output "out_restish_name" {
  value = azuread_application.restish[0].display_name
}

output "out_restish_clientid" {
  value = azuread_application.restish[0].application_id
}

output "out_powerbi_name" {
  value = azuread_application.powerbi[0].display_name
}

output "out_powerbi_clientid" {
  value = azuread_application.powerbi[0].application_id
}

output "out_webapp_name" {
  value = azuread_application.webapp.display_name
}

output "out_webapp_clientid" {
  value = azuread_application.webapp.application_id
}

output "out_public_ip" {
  value = azurerm_public_ip.publicip[0].ip_address
}

output "out_public_ip_name" {
  value = azurerm_public_ip.publicip[0].name
}

output "out_fqdn" {
  value = "${azurerm_dns_a_record.platform_fqdn[0].name}.${var.dns_zone_name}"
}

output "out_vnet" {
  value = azurerm_virtual_network.platform_vnet[0].name
}

output "out_subnet" {
  value = local.subnet_name
}
