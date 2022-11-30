# CosmosDB account and database creation for the tenant
module "cosmosdb" {
  source = "../modules/terraform-azure-cosmosdb"
  location = var.location
  resource_group_name = var.resource_group_name
  tenant_name = var.tenant_name
  private_endpoint_enabled = var.private_endpoint_enabled
  private_endpoint_vnet_name = var.private_endpoint_vnet_name
  private_endpoint_subnet_name = var.private_endpoint_vnet_name
}