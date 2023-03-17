locals {
  values_argo = {
    "ARGO_SERVICE_ACCOUNT"        = var.argo_service_account
    "ARGO_BUCKET_NAME"            = var.argo_bucket_name
    "MONITORING_NAMESPACE"        = var.monitoring_namespace
    "MINIO_RELEASE_NAME"          = var.minio_release_name
    "NAMESPACE"                   = var.namespace
    "POSTGRES_RELEASE_NAME"       = var.postgres_release_name
    "ARGO_DATABASE"               = var.argo_database
    "ARGO_POSTGRESQL_SECRET_NAME" = var.argo_postgresql_secret_name
    "REQUEUE_TIME"                = var.requeue_time
  }
}

resource "helm_release" "argo" {
  name       = var.argo_release_name
  repository = var.helm_repo_url
  chart      = var.helm_chart
  version    = var.argo_version
  namespace  = var.namespace

  reuse_values = true

  values = [
    templatefile("${path.module}/values.yaml", local.values_argo)
  ]
}