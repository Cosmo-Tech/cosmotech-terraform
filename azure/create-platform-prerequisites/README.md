# Cosmo Tech Platform Azure Prerequisite Terraform

This documentation describes the Azure prerequisite infrastructure needed to install the Cosmo Tech AI Simulation Platform using Terraform. The Terraform script creates several Azure resources, as well as app registrations and specific Cosmo Tech AI Simulation Platform roles. The following is a list of the resources that will be created:

- Azure Active Directory Application for the Cosmo Tech Platform
- Azure Active Directory Application for Network and Azure Digital Twins
- Azure Active Directory Application for Cosmo Tech API Swagger UI
- Azure Active Directory Application for Restish
- Azure Active Directory Application for WebApp
- Azure Virtual Network for AKS
- Azure DNS record
- Azure public IP for the Cosmo Tech Platform
- Role assignments for the Cosmo Tech Platform


There are two options to run this Terraform script :

- Using terraform cli in your local machine
- Using terraform cloud

## Run in local

There are two authentication modes for runnning the Terraform script in local:

### Option 1: Azure user identity

- Connect to Azure CLI with `az login`
- Install [Terraform Cli](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) on your machine
- Have the following Assigned roles on Active Directory:
  - Application Administrator
  - Groups Administrator
- Subscription Owner

Once you have met these requirements, you can clone the github.com/Cosmo-Tech/cosmotech-terraform repository and navigate to the azure/create-platform-prerequisites. From there, you can run the Terraform script and wait for the resources to be created.

### Option 2: Azure App registration

Create an app registration for Terraform with the following API permissions:

* [Azure Active Directory for the Terraform azuread provider.](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/guides/service_principal_client_secret) to create Azure application registration, roles and role assignments in Azure Active Directory

** `Application.ReadWriteAll`

** `Group.ReadWriteAll`

** `User.ReadAll`

To give these API permissions to the app registration, go to `API Permission` >> `Add a permission` >> `Azure Active Directory Graph` >> `Application.ReadWrite.All` >> `Delegated Permissions` >> `Add permissions` repeat the same for `Group.ReadWrite.All`

Then you have to grant admin consent for the app registration, go to `API Permission` >> `Grant admin consent for <your tenant name>` >> `Yes`

* [Azure subscription for the Terraform azurerm provider.](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_client_secret) :  to create Azure resources :

** `Subscription Owner`

To grant this iam permission to the app registration, go `subscription` >> `access control (IAM)` >> `Add` >> `Add role assignment` >> `Owner` >> Choose your app registration name >> `Select` >> `Save`

> **_NOTE:_**  Cloud Application Administrator or Application Administrator, for granting consent for apps requesting any permission for any API, except Azure AD Graph or Microsoft Graph app roles (application permissions) such as User.ReadAll. It means that you can't grand admin consent on Active Directory Application witch have Microsoft Graph app roles if your don't have the role Global Admin in the tenant.

### Azure Prerequisite Terraform Variables

| Description                        | Description                                                                          | Type         | HCL   | Default             | Example                                       |
| ---------------------------------- | ------------------------------------------------------------------------------------ | ------------ | ----- | ------------------- | --------------------------------------------- |
| **location**                       | The Azure resources location                                                         | String       | false | West Europe         | West Europe                                   |
| **tenant_id**                      | ***The customer tenant id**                                                          | String       | false |                     |                                               |
| **subscription_id**                | ***The customer tenant id**                                                          | String       | false |                     |                                               |
| **client_id**                      | ***The application registration created to run terraform object id**                 | String       | false |                     |                                               |
| **client_secret**                  | **The application registration secret value**                                        | String       | false |                     |                                               |
| **platform_url**                   | **The Cosmotech Platform API Url****                                                 | String       | false |                     | https://lab.api.cosmo-platform.com            |
| **project_stage**                  | **The project stage (Dev, Prod, QA,...)****                                          | String       | false |                     |                                               |
| **customer_name**                  | **The Customer name****                                                              | String       | false |                     |                                               |
| **project_name**                   | **The Project name****                                                               | String       | false |                     |                                               |
| **owner_list**                     | **The list of AAD user list witch will be owner of the deployment resource group**** | list[String] | true  |                     | ["user.foo@mail.com"]                         |
| **audience**                       | The App Registration audience type                                                   | String       | false | AzureADMultipleOrgs |                                               |
| **webapp_url**                     | **The Web Application URL****                                                        | String       | false |                     | https://project.cosmo-platform.com            |
| **create_restish**                 | Create the Azure Active Directory Application for Restish ?                          | bool         | false | true                |                                               |
| **create_webapp**                  | Create the Azure Active Directory Application for Webapp ?                           | bool         | false | true                |                                               |
| **create_powerbi**                 | Create the Azure Active Directory Application for Power BI ?                         | bool         | false | true                |                                               |
| **resource_group**                 | **The resource group to use for the platform deployment****                          | String       | false |                     | rg-myrg (Should be a new resource group name) |
| **create_publicip**                | Create the public IP for the platform ?                                              | bool         | false | true                |                                               |
| **create_dnsrecord**               | Create the Azure DNS record ?                                                        | bool         | false | true                |                                               |
| **dns_zone_name**                  | **The Azure DNS Zone name****                                                        | String       | false |                     | dns-corpo                                     |
| **dns_zone_rg**                    | The resource group witch contain the Azure DNS Zone                                  | String       | false |                     |                                               |
| **dns_record**                     | **The DNS zone name to create platform subdomain. Example: myplatform****            | String       | false |                     | projectname                                   |
| **create_vnet**                    | Create the Virtual Network for AKS ?                                                 | bool         | false | true                |                                               |
| **create_secrets**                 | Create secrets for Azure Active Directory Applications ?                             | bool         | false | true                |                                               |
| **vnet_iprange**                   | **The Virtual Network IP range. Minimum /26 NetMaskLength****                        | String       | false |                     |                                               |
| **api_version_path**               | The API version path (Ex: /v2/)                                                      | String       | false | "/"                 | /v2/                                          |
| **azuread_service_principal_tags** | Tags for AZ AD service principal                                                     | list[String] | true  |                     | ["AI","Simulation"]                           |
| **azuread_application_tags**       | Common tags for AZ AD application                                                    | list[String] | true  |                     | ["AI","Simulation"]                           |
| **common_tags**                    | Common tags for AZ AD service principal                                              | list[String] | true  | Yes                 | ["AI","Simulation"]                           |


Legend:

`*____` : required values to run the scrip with a service principals (Azure Application registration )

`___**` : mandatory value any how you are running the terraform script

The variables witch are listed in thic doc and have default values are optionals and their values can be override in the `terraform.tfvars` file. Example to set create_powerbi to false, add the following line in the `terraform.tfvars` file:

```hcl
create_powerbi = false
```

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


Terraform cloud run require using of a service principals (Azure Application registration ) configured as seen for the local run. You have to set up the same variables.
The new requirement is an terraform cloud Account.

- [ ] Create a terraform cloud account
- [ ] Clone `Cosmotech-terraform` Github repository `git clone https://github.com/Cosmo-Tech/cosmotech-terraform.git`
- [ ] Create your own brach of the Github repository `git checkout -b my-own-branch`
- [ ] Create a new workspace in terraform cloud
- [ ] Choose `Version control workflow` and select `Github`
- [ ] Select your Github account and the repository `Cosmotech-terraform`
- [ ] Select the branch `my-own-branch`
- [ ] Select the repertory `azure/create-platform-prerequisites`
- [ ] Select `Terraform v1.3.9` as terraform version
- [ ] Set the `terraform.tfvars` file as `Terraform Variables`
- [ ] Fill the `Terraform Variables` with required `___**` values
- [ ] Start a new run on the workspace


See more about Terraform Cloud : [What is Terraform Cloud](https://developer.hashicorp.com/terraform/cloud-docs)

## Post deployment manual actions

### Azure Active Directory Application

After the deployment, you have to grant admin consent for the Azure Active Directory Application created by the terraform script.

Go to Azure Portal and select the Azure Active Directory Application created by the terraform script, then select `API Permissions` and `Grant admin consent for <your tenant name>`.

You also need to add required identifier URI for the Azure Active Directory Application created by the terraform script. Go to Azure Portal and select the Azure Active Directory Application created by the terraform script, then in overview tab, select `Add a Redirect URI` and add the following URI: `api://<the created app id>`.

