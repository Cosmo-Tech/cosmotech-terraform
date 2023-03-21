data "kind_cluster" "cluster" {
  name = var.cluster_name
}
locals {
  host                   = "locahost"
  client_certificate     = base64decode(data.client_certificate_data)
  client_key             = base64decode(data.client_key_data)
  cluster_ca_certificate = base64decode(data.ca_certificate_data)
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
