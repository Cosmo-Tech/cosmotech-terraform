This terraform configuration required an account with permissions on:
* [Azure Active Directory for the Terraform azuread provider.](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/guides/service_principal_client_secret)
** Application.ReadWriteAll
** Group.ReadWriteAll
** User.ReadAll
* [Azure subscription for the Terraform azurerm provider.](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_client_secret)
** Subscription Owner
