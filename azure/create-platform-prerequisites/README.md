This terraform configuration required an account with permissions on:

* [Azure Active Directory for the Terraform azuread provider.](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/guides/service_principal_client_secret)
** Application.ReadWriteAll
** Group.ReadWriteAll
** User.ReadAll
* [Azure subscription for the Terraform azurerm provider.](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_client_secret)
** Subscription Owner


## Terraform variables

| Description                        | Description   | Type   | HCL   | Sensitive | Default | Comment |
| ---------------------------------- | ------------- | ------ | ----- | --------- | ------- | ------- |
| **tenant_id**                      | The tenant id | String | false | false     |         |         |
| **subscription_id**                | The tenant id | String | false | false     |         |         |
| **client_id**                      | The tenant id | String | false | false     |         |         |
| **client_secret**                  | The tenant id | String | false | false     |         |         |
| **platform_url**                   | The tenant id | String | false | false     |         |         |
| **identifier_uri**                 | The tenant id | String | false | false     |         |         |
| **project_stage**                  | The tenant id | String | false | false     |         |         |
| **customer_name**                  | The tenant id | String | false | false     |         |         |
| **project_name**                   | The tenant id | String | false | false     |         |         |
| **owner_list**                     | The tenant id | String | false | false     |         |         |
| **audience**                       | The tenant id | String | false | false     |         |         |
| **webapp_url**                     | The tenant id | String | false | false     |         |         |
| **create_restish**                 | The tenant id | String | false | false     |         |         |
| **create_powerbi**                 | The tenant id | String | false | false     |         |         |
| **resource_group**                 | The tenant id | String | false | false     |         |         |
| **create_publicip**                | The tenant id | String | false | false     |         |         |
| **create_dnsrecord**               | The tenant id | String | false | false     |         |         |
| **dns_zone_name**                  | The tenant id | String | false | false     |         |         |
| **dns_zone_rg**                    | The tenant id | String | false | false     |         |         |
| **dns_record**                     | The tenant id | String | false | false     |         |         |
| **create_vnet**                    | The tenant id | String | false | false     |         |         |
| **create_secrets**                 | The tenant id | String | false | false     |         |         |
| **vnet_iprange**                   | The tenant id | String | false | false     |         |         |
| **api_version_path**               | The tenant id | String | false | false     |         |         |
| **user_app_role**                  | The tenant id | String | false | false     |         |         |
| **azuread_service_principal_tags** | The tenant id | String | false | false     |         |         |
| **azuread_application_tags**       | The tenant id | String | false | false     |         |         |
| **common_tags**                    | The tenant id | String | false | false     |         |         |