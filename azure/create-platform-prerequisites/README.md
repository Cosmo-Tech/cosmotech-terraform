# Cosmotech Platform Azure Prerequisite Terraform

This documentation describes the Azure prerequisite infrastructure needed to install the Cosmotech AI simulation platform using Terraform. The Terraform script creates several Azure resources, as well as application registrations and specific Cosmotech AI simulation platform roles. The following is a list of the resources that will be created:

It will create theses azures resources and Application registration and specific Cosmotech AI simulation platform roles. See full list aof theses elements bellow.

- Azure Active Directory Application for the Cosmotech Platform
- Azure Active Directory Application for Azure digital twin Network
- Azure Active Directory Application for Cosmotech API Swagger Web interface
- Azure Active Directory Application for Restish
- Azure Active Directory Application for Webapp Application
- Azure Virtual Network for AKS
- Azure DNS record
- Azure public IP for the Cosmotech Platform

> **_NOTE:_**  These resources and role assignments can be created either fully manually, partially manually and partially with Terraform.

By running this Terraform script, you can easily and efficiently create the required infrastructure for the Cosmotech AI simulation platform on Azure. The resources created by the script are essential components for running the platform and will ensure that the installation process is smooth and successful.

There is two option to run this Terraform script :

- Using terraform cli in your local machine
- Using terraform cloud

## Run in local

Before running the Terraform script, please ensure that you have an Azure account and have configured the necessary credentials. You will also need to install Terraform on your machine.

Once you have met these requirements, you can clone the Cosmotech AI simulation platform repository and navigate to the azure/create-platform-prerequisites. From there, you can run the Terraform script and wait for the resources to be created.

If you prefer, you can also create the resources manually, either in part or in full. However, using Terraform ensures that the process is streamlined and reproducible, which can save time and reduce the risk of errors.

You can use the connected Azure identity connected to your Azure CLI to run the script or an application registration.


It's important to note that you will need to have the necessary permissions to create Azure resources, application registrations, roles, and role assignments :

* [Azure Active Directory for the Terraform azuread provider.](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/guides/service_principal_client_secret) to create Azure application registration, roles and role assignments in Azure Active Directory

** `Application.ReadWriteAll`

** `Group.ReadWriteAll`

** `User.ReadAll`

* [Azure subscription for the Terraform azurerm provider.](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_client_secret) :  to create Azure resources :

** `Subscription Owner`

> **_NOTE:_**  Cloud Application Administrator or Application Administrator, for granting consent for apps requesting any permission for any API, except Azure AD Graph or Microsoft Graph app roles (application permissions) such as User.ReadAll. It means that you can't grand admin consent on Active Directory Application witch have Microsoft Graph app roles if your don't have the role Global Admin in the tenant.

### Variables

| Description                        | Description                                                                    | Type   | HCL   | Sensitive | Default | Comment |
| ---------------------------------- | ------------------------------------------------------------------------------ | ------ | ----- | --------- | ------- | ------- |
| **location**                       | The Azure resources location                                                   | String | false | false     |         |         |
| **tenant_id**                      | The customer tenant id                                                         | String | false | false     |         |         |
| **subscription_id**                | The customer tenant id                                                         | String | false | false     |         |         |
| **client_id**                      | The application registration created to run terraform object id                | String | false | false     |         |         |
| **client_secret**                  | The application registration secret value                                      | String | false | false     |         |         |
| **platform_url**                   | The tenant id                                                                  | String | false | false     |         |         |
| **project_stage**                  | The project stage (Dev, Prod, QA,...)                                          | String | false | false     |         |         |
| **customer_name**                  | The Customer name                                                              | String | false | false     |         |         |
| **project_name**                   | The Project name                                                               | String | false | false     |         |         |
| **owner_list**                     | The list of AAD user list witch will be owner of the deployment resource group | String | false | false     |         |         |
| **audience**                       | The App Registration audience type                                             | String | false | false     |         |         |
| **webapp_url**                     | The Web Application URL                                                        | String | false | false     |         |         |
| **create_restish**                 | Create the Azure Active Directory Application for Restish ?                    | String | false | false     |         |         |
| **create_powerbi**                 | Create the Azure Active Directory Application for Power BI ?                   | String | false | false     |         |         |
| **resource_group**                 | The resource group to use for the platform deployment                          | String | false | false     |         |         |
| **create_publicip**                | Create the public IP for the platform ?                                        | String | false | false     |         |         |
| **create_dnsrecord**               | Create the Azure DNS record ?                                                  | String | false | false     |         |         |
| **dns_zone_name**                  | The Azure DNS Zone name                                                        | String | false | false     |         |         |
| **dns_zone_rg**                    | The resource group witch contain the Azure DNS Zone                            | String | false | false     |         |         |
| **dns_record**                     | The DNS zone name to create platform subdomain. Example: myplatform            | String | false | false     |         |         |
| **create_vnet**                    | Create the Virtual Network for AKS                                             | String | false | false     |         |         |
| **create_secrets**                 | Create secrets for Azure Active Directory Applications ?                       | String | false | false     |         |         |
| **vnet_iprange**                   | The Virtual Network IP range. Minimum /26 NetMaskLength                        | String | false | false     |         |         |
| **api_version_path**               | The API version path                                                           | String | false | false     |         |         |
| **azuread_service_principal_tags** | The tenant id                                                                  | String | false | false     |         |         |
| **azuread_application_tags**       | The tenant id                                                                  | String | false | false     |         |         |
| **common_tags**                    | The tenant id                                                                  | String | false | false     |         |         |