locals {
  values_ingress_nginx = {
    "MONITORING_NAMESPACE"                     = var.monitoring_namespace
    "NGINX_INGRESS_CONTROLLER_REPLICA_COUNT"   = 1
    "NGINX_INGRESS_CONTROLLER_LOADBALANCER_IP" = var.loadbalancer_ip
    "NAMESPACE"                                = var.namespace
    "TLS_SECRET_NAME"                          = var.tls_secret_name
  }
}

resource "helm_release" "ingress-nginx" {
  name       = var.helm_release_name
  repository = var.helm_repo_url
  chart      = var.helm_release_name
  # version    = var.ingress_nginx_version
  namespace  = var.namespace

  reuse_values = true

  values = [
    templatefile("${path.module}/values.yaml", local.values_ingress_nginx)
  ]
}

