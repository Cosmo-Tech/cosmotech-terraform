data "azurerm_kubernetes_cluster" "example" {
  name                = var.cluster_name
  resource_group_name = var.resource_group
}

provider "kubernetes" {
  host                   = "${data.azurerm_kubernetes_cluster.example.kube_config.0.host}"
  client_certificate     = "${base64decode(data.azurerm_kubernetes_cluster.example.kube_config.0.client_certificate)}"
  client_key             = "${base64decode(data.azurerm_kubernetes_cluster.example.kube_config.0.client_key)}"
  cluster_ca_certificate = "${base64decode(data.azurerm_kubernetes_cluster.example.kube_config.0.cluster_ca_certificate)}"
}

provider "helm" {
  kubernetes {
  }
}

resource "kubernetes_namespace" "kube_namespace" {
  metadata {
    name = var.namespace
  }
}

module "ingress-nginx" {
  source = "./ingress-nginx"

  # vars
  namespace = var.namespace
  monitoring_namespace = var.monitoring_namespace
  ingress_nginx_version = var.ingress_nginx_version
  loadbalancer_ip = var.loadbalancer_ip
  tls_secret_name = var.tls_secret_name
}

# module "prometheus-stack" {
#   source = "./prometheus-stack"

#   # vars
# }