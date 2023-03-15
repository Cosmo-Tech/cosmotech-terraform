locals {
  values_cert_manager = {
    "MONITORING_NAMESPACE" = var.monitoring_namespace
  }
}

resource "helm_release" "cert-manager" {
  name       = var.helm_release_name
  repository = var.helm_repo_url
  chart      = var.helm_release_name
  # version    = var.cert_manager_version
  namespace = var.namespace

  reuse_values = true
  timeout = 180

  values = [
    templatefile("${path.module}/values.yaml", local.values_cert_manager)
  ]

  set {
    name = "installCRDs"
    value = true
  }
}
