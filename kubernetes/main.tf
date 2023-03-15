data "azurerm_kubernetes_cluster" "example" {
  name                = var.cluster_name
  resource_group_name = var.resource_group
}

locals {
  host                   = data.azurerm_kubernetes_cluster.example.kube_config.0.host
  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.example.kube_config.0.client_certificate)
  client_key             = base64decode(data.azurerm_kubernetes_cluster.example.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.example.kube_config.0.cluster_ca_certificate)
}
provider "kubernetes" {
  host                   = local.host
  client_certificate     = local.client_certificate
  client_key             = local.client_key
  cluster_ca_certificate = local.cluster_ca_certificate
}

provider "helm" {
  kubernetes {
    host                   = local.host
    client_certificate     = local.client_certificate
    client_key             = local.client_key
    cluster_ca_certificate = local.cluster_ca_certificate
  }
}

provider "kubectl" {
  host                   = local.host
  client_certificate     = local.client_certificate
  client_key             = local.client_key
  cluster_ca_certificate = local.cluster_ca_certificate

  load_config_file = false
}

resource "kubernetes_namespace" "main_namespace" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_namespace" "monitoring_namespace" {
  metadata {
    name = var.monitoring_namespace
  }
}

module "create-ingress-nginx" {
  source = "./create-ingress-nginx"

  namespace             = var.namespace
  monitoring_namespace  = var.monitoring_namespace
  ingress_nginx_version = var.ingress_nginx_version
  loadbalancer_ip       = var.loadbalancer_ip
  tls_secret_name       = var.tls_secret_name

  # depends_on = [
  #   module.create-prometheus-stack
  # ]
}

# TODO: Use dedicated terraform module ?
# module "create-prometheus-stack" {
#   source = "./create-prometheus-stack"

#   namespace            = var.namespace
#   monitoring_namespace = var.monitoring_namespace
#   api_dns_name         = var.api_dns_name
#   tls_secret_name      = var.tls_secret_name
#   redis_admin_password = var.redis_admin_password
#   prom_admin_password  = var.prom_admin_password

#   depends_on = [
#     module.cert-manager
#   ]
# }

# module "create-cert-manager" {
#   source = "./create-cert-manager"

#   namespace            = var.namespace
#   monitoring_namespace = var.monitoring_namespace
# }

module "cert-manager" {
  source  = "terraform-iaac/cert-manager/kubernetes"
  version = "2.5.0"

  cluster_issuer_email = var.cluster_issuer_email
  cluster_issuer_name  = var.cluster_issuer_name
}

module "create-redis-stack" {
  source = "./create-redis-stack"

  redis_admin_password = var.redis_admin_password
  namespace            = var.namespace
  resource_group = var.resource_group
  # redis_disk_resource  = var.redis_disk_resource
}