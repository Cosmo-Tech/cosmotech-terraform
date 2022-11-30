# New Tenant Azure terraform configuration for the Cosmo Tech Platform
You need to create the new tenant security pre-requisites with azure/create-platform-prerequisites with the parameter new_tenant=true

Create new Azure resources for a new tenant:
* Azure CosmosDB managed DB account
* Azure Storage
* Azure Event Hub namespace
* Azure Container Registry

Azure Data Explorer and AKS will be mutualized across tenants and isolated by:
* AKS: namespace
* ADX: database