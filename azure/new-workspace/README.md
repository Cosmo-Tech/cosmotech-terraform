Create Azure resources for a new workspace

Configure the Azure providers with your credential: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_client_secret
The App Registration used must be:
* Subscription owner
* Have Application API Permission on ReadWriteAllGroup on Ms Graph service

