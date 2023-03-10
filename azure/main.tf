module "create-platform-prerequisite" {
  source = "./create-platform-prerequisites"

  tenant_id = var.tenant_id
  subscription_id = var.subscription_id
  client_id = var.client_id
  client_secret = var.client_secret
  platform_url = var.platform_url
  identifier_uri = var.identifier_uri
  stage = var.stage
  customer = var.customer
  project = var.project
  owner_list = var.owner_list
  audience = var.audience
  webapp_url = var.webapp_url
  create_restish = var.create_restish
  create_powerbi = var.create_powerbi
  location = var.location
  resource_group = var.resource_group
  create_publicip = var.create_publicip
  create_dnsrecord = var.create_dnsrecord
  dns_zone_name = var.dns_zone_name
  dns_zone_rg = var.dns_zone_rg
  dns_record = var.dns_record
  create_vnet = var.create_vnet
  vnet_iprange = var.vnet_iprange
  api_version_path = var.api_version_path
  image_path = var.image_path
}

module "create-cluster" {
  source = "./create-cluster"

  location = var.location
  resource_group = var.resource_group
  tenant_id = var.tenant_id
  subscription_id = var.subscription_id
  client_id = var.client_id
  client_secret = var.client_secret

  depends_on = [
    module.create-platform-prerequisite
  ]
}