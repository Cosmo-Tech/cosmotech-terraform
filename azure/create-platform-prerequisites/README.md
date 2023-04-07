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
- Role assignments for the Cosmotech Platform

> **_NOTE:_**  These resources and role assignments can be created either fully manually, partially manually and partially with Terraform.

By running this Terraform script, you can easily and efficiently create the required infrastructure for the Cosmotech AI simulation platform on Azure. The resources created by the script are essential components for running the platform and will ensure that the installation process is smooth and successful.

There is two option to run this Terraform script :

- Using terraform cli in your local machine
- Using terraform cloud

## Run in local

Before running the Terraform script, please ensure that you have an Azure account and have configured the necessary credentials. You will also need to install Terraform on your machine.

Once you have met these requirements, you can clone the Cosmotech AI simulation platform repository and navigate to the azure/create-platform-prerequisites. From there, you can run the Terraform script and wait for the resources to be created.

If you prefer, you can also create the resources manually, either in part or in full. However, using Terraform ensures that the process is streamlined and reproducible, which can save time and reduce the risk of errors.

You can use the connected Azure identity connected to your Azure CLI to run the script or an Azure Application registration.


It's important to note that you will need to have the necessary permissions to create Azure resources, application registrations, roles, and role assignments :

* [Azure Active Directory for the Terraform azuread provider.](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/guides/service_principal_client_secret) to create Azure application registration, roles and role assignments in Azure Active Directory

** `Application.ReadWriteAll`

** `Group.ReadWriteAll`

** `User.ReadAll`

* [Azure subscription for the Terraform azurerm provider.](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_client_secret) :  to create Azure resources :

** `Subscription Owner`

> **_NOTE:_**  Cloud Application Administrator or Application Administrator, for granting consent for apps requesting any permission for any API, except Azure AD Graph or Microsoft Graph app roles (application permissions) such as User.ReadAll. It means that you can't grand admin consent on Active Directory Application witch have Microsoft Graph app roles if your don't have the role Global Admin in the tenant.

### Azure Prerequisite Terraform Variables

| Description                        | Description                                                                          | Type         | HCL   | Default             |
| ---------------------------------- | ------------------------------------------------------------------------------------ | ------------ | ----- | ------------------- |
| **location**                       | The Azure resources location                                                         | String       | false | West Europe"        |
| **tenant_id**                      | ***The customer tenant id**                                                          | String       | false |                     |
| **subscription_id**                | ***The customer tenant id**                                                          | String       | false |                     |
| **client_id**                      | ***The application registration created to run terraform object id**                 | String       | false |                     |
| **client_secret**                  | **The application registration secret value**                                        | String       | false |                     |
| **platform_url**                   | **The Cosmotech Platform API Url****                                                 | String       | false |                     |
| **project_stage**                  | **The project stage (Dev, Prod, QA,...)****                                          | String       | false |                     |
| **customer_name**                  | **The Customer name****                                                              | String       | false |                     |
| **project_name**                   | **The Project name****                                                               | String       | false |                     |
| **owner_list**                     | **The list of AAD user list witch will be owner of the deployment resource group**** | list[String] | true  |                     |
| **audience**                       | The App Registration audience type                                                   | String       | false | AzureADMultipleOrgs |
| **webapp_url**                     | The Web Application URL                                                              | String       | false |                     |
| **create_restish**                 | Create the Azure Active Directory Application for Restish ?                          | bool         | false | true                |
| **create_powerbi**                 | Create the Azure Active Directory Application for Power BI ?                         | bool         | false | true                |
| **resource_group**                 | **The resource group to use for the platform deployment****                          | String       | false |                     |
| **create_publicip**                | Create the public IP for the platform ?                                              | bool         | false | true                |
| **create_dnsrecord**               | Create the Azure DNS record ?                                                        | bool         | false | true                |
| **dns_zone_name**                  | **The Azure DNS Zone name****                                                        | String       | false |                     |
| **dns_zone_rg**                    | The resource group witch contain the Azure DNS Zone                                  | String       | false |                     |
| **dns_record**                     | **The DNS zone name to create platform subdomain. Example: myplatform****            | String       | false |                     |
| **create_vnet**                    | Create the Virtual Network for AKS ?                                                 | bool         | false | true                |
| **create_secrets**                 | Create secrets for Azure Active Directory Applications ?                             | bool         | false | true                |
| **vnet_iprange**                   | **The Virtual Network IP range. Minimum /26 NetMaskLength****                        | String       | false |                     |
| **api_version_path**               | The API version path (Ex: /v2/)                                                      | String       | false | "/"                 |
| **azuread_service_principal_tags** | Tags for AZ AD service principal                                                     | list[String] | true  |                     |
| **azuread_application_tags**       | Common tags for AZ AD application                                                    | list[String] | true  |                     |
| **common_tags**                    | Common tags for AZ AD service principal                                              | list[String] | true  | Yes                 |


Legend:

`*____` : required values to run the scrip with a service principals (Azure Application registration )

`___**` : mandatory value any how you are running the terraform script

### Prerequisite to run in local

- [ ] Clone `Cosmotech-terraform` Github repository `git clone https://github.com/Cosmo-Tech/cosmotech-terraform.git`
- [ ] Create your own brach of the Github repository `git checkout -b my-own-branch`
- [ ] Go to `azure/create-platform-prerequisites` repertory `cd azure/create-platform-prerequisites`
- [ ] Ensure you have the right Azure AAD roles; we advise to have `Application Administrator`
- [ ] Login throw Azure Cli `az login`
- [ ] Edit file `terraform.tfvars` with required `___**` values

> **_NOTE:_**  If your run the script with your connected Azure identity connected to your Azure CLI, don't add your id (email) in owner_list values

- [ ] Init the terraform by running `terraform init`
- [ ] Validate the terraform by running `terraform validate`
- [ ] Plan the terraform by running `terraform plan`
- [ ] End with applying the terraform by running `terraform apply`, reply `yes` for the terraform prompt to confirm Resources creation.


## Run with terraform cloud



