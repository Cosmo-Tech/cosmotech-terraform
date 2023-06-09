locals {
  values_loki = {
    "RETENTION_PERIOD" = var.retention_period
  }
}

resource "helm_release" "loki" {
  name       = var.loki_release_name
  repository = var.helm_repo_url
  chart      = var.helm_chart
  namespace  = var.namespace

  reuse_values = true

  values = [
    templatefile("${path.module}/values.yaml", local.values_loki)
  ]
}