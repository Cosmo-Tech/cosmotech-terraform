Create Azure resources for a new workspace

Configure the Azure providers with your credential: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_client_secret
The App Registration for terraform must have the following permissions:
* Subscription owner
* Have Application API Permission to ReadAllUsers on Ms Graph service
* Have Application API Permission to ReadWriteAllGroup on Ms Graph service
* Have Application API Permission to ReadAllApplications on Ms Graph service

You must create a container named "terraform" in the platform storage account.
