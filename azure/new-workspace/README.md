# Create and configure Azure resources for a new workspace

## Scope
* Create ADT instance
* Create Event Hub Namespace (if dedicated Event Hub configured)
* Create Event Hubs and consumer groups
* Create ADX database
* Create ADX generic tables and data mappings (optional, but recommended)
* Create ADX / Event Hub data connections
* Create a Workspace security group with role assignments on workspace resources (optional, not recommended due to lack of maturity)

## Prerequisites
* Create an App registration *Terraform-<project_name>* 
  * Create a secret for this app registration
  * Assign the role Contributor to the App registration over the managed resource group
* Create a container named `terraform` in the platform storage account

## Run Terraform script
### Option 1: run with Terraform cloud (a Terraform Cloud account is needed)
* Fork the `cosmotech-terraform` repository (Cosmo Tech internal repository in `cosmotech-terraform-internal`)
* Create a new branch dedicated to the workspace you want to create
* In [Terraform cloud](https://app.terraform.io):
  * Create a new workspace
  * Choose `Version control workflow` and select `Github`
  * Select your Github account and the repository you forked
  * Select your branch dedicated to the workspace
  * Select `Terraform v1.3.9` as Terraform version
  * Set the Terraform variables (Terraform variables specified in the table below)
  * Start a new run of the Terraform workspace
* Check ADX / Event Hub Data connections health:
  * In Azure Portal, open Azure Data Explorer Resource
  * `Databases` > click on your database > `Data connections`
  * Check that all 4 data conections are green, otherwise:
    * Click on `...` > `Edit` > `Save`

### Option 2: Run in local using App registration identity
* Fork the `cosmotech-terraform` repository (Cosmo Tech internal repository in `cosmotech-terraform-internal`)
* Create a new branch dedicated to the workspace you want to create
* Set all the Terraform variables in the file `terraform.tfvars` (Terraform variables specified in the table below)
* Init the terraform by running `terraform init`
* Validate the terraform by running `terraform validate`
* Plan the terraform by running `terraform plan`
* End with applying the terraform by running `terraform apply`
* Check ADX / Event Hub Data connections health:
  * In Azure Portal, open Azure Data Explorer Resource
  * `Databases` > click on your database > `Data connections`
  * Check that all 4 data conections are green, otherwise:
    * Click on `...` > `Edit` > `Save`

## Terraform variables specification

| Description                      | Description                                                        | Mandatory             | Type         | Default             | Example                               |
| -------------------------------- | ------------------------------------------------------------------ | --------------------- | ------------ | ------------------- | ------------------------------------- |
| **location**                     | Location of the Cosmo Tech Platform Azure resources                | No                    | String       | West Europe         | West Europe                           |
| **tenant_id**                    | ID of the tenant of the Terraform App Registration                 | Yes                   | String       |                     | e413b834-8be8-4822-a370-be619545cb49  |
| **client_id**                    | Client ID of the Terraform App Registration                        | Yes                   | String       |                     | abcdefgh-1234-5678-abcd-123456789ABC  |
| **client_secret**                | Secret of the Terraform App Registration                           | Yes                   | String       |                     | XXXXXXXxxxxxYYYYYYyyyyyyyZZZZZZzzzzz  |
| **app_platform_name**            | Name of the Platform App Registration                              | Yes                   | String       |                     | Cosmo Tech Platform for Project       |
| **app_adt_name**                 | Name of the Network ADT App Registration                           | Yes                   | String       |                     | Cosmo Tech Network ADT for Project    |
| **dedicated_eventhub_namespace** | Create a dedicated eventhub namespace (true if multiple workspaces on the Platform)| Yes   | String       | true                | false                                 |
| **eventhub_namespace_name**      | Name of the Event Hub Namespace deployed by default on the platform| Yes if dedicated_eventhub_namespace=false | String       | | evnamespacexxxxx                      |
| **adx_name**                     | Name of the Azure Data Explorer resource deployed by the Platform  | Yes                   | String       |                     | kustoxxxxxxx                          |
| **storage_account_name**         | Name of the Azure Storage Account resource deployed by the Platform| Yes                   | String       |                     | storagexxxxxxx                        |
| **subscription_id**              | ID of the subscription where the Cosmo Tech Platform is deployed   | Yes                   | String       |                     | abcdefgh-1234-5678-abcd-123456789ABC  |
| **resource_group**               | Name of the managed resource group of the Cosmo Tech Platform      | Yes                   | String       |                     | mrg-cosmotechsdtplatform-20230101     |
| **organization_id**              | ID of the Organization previously created in the API               | Yes                   | String       |                     | o-xxxxxxxxxx                          |
| **workspace_key**                | Key of the workspace previouly created in the API                  | Yes                   | String       |                     | supplychainworkspace                  |
| **eventhub_namespace_capacity**  | Event Hub Namespace capacity in terms of throughput units          | No                    | Integer      | 2                   | 2                                     |
| **kusto_script**                 | Run the database script (recommended value is `true`)              | No                    | String       | true                | true                                  |
| **aad_groups_and_assignements**  | Run the database script (recommended value is `false`)             | No                    | String       | false                | false                                 |
| **adx_identity_uid**             | The kusto cluster managed identity ui (recommended value is `""`)  | No                    | String       |                     |                                       |
| **aad_group_members**            | List of members of workspace security group (recommended to keep empty) | No               | list(String) | []                  |                                       |
| **owner_sp_name**                | Owner of the workspace security group (keep empty)                 | No                    | String       |                     |                                       |

