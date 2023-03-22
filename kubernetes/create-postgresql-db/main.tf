locals {
  values_postgresql = {
    "ARGO_POSTGRESQL_USER"     = var.argo_postgresql_user
    "ARGO_POSTGRESQL_PASSWORD" = var.argo_postgresql_password
    "ARGO_DATABASE"            = var.argo_database
    "MONITORING_NAMESPACE"     = var.monitoring_namespace
  }
}

resource "helm_release" "postgresql" {
  name       = var.helm_release_name
  repository = var.helm_repo_url
  chart      = var.helm_chart
  version    = var.postgresql_version
  namespace = var.namespace

  reuse_values = true

  values = [
    templatefile("${path.module}/values.yaml", local.values_postgresql)
  ]
}

resource "kubernetes_secret" "argo-postgres-config" {
  metadata {
    name = var.argo_postgresql_secret_name
    namespace = var.namespace
    labels = {
      "app" = "postgres"
    }
  }

  data = {
    username = var.argo_postgresql_user
    password = var.argo_postgresql_password
  }

  type = "Opaque"
}
