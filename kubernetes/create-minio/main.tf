locals {
  values_minio = {
    "MONITORING_NAMESPACE"        = var.monitoring_namespace
    "MINIO_RELEASE_NAME"          = var.minio_release_name
    "ARGO_BUCKET_NAME"            = var.argo_bucket_name
    "ARGO_MINIO_PERSISTENCE_SIZE" = var.argo_minio_persistence_size
    "ARGO_MINIO_REQUESTS_MEMORY"  = var.argo_minio_requests_memory
    "ARGO_MINIO_ACCESS_KEY"       = var.argo_minio_access_key
    "ARGO_MINIO_SECRET_KEY"       = var.argo_minio_secret_key
  }
}

resource "helm_release" "minio" {
  name       = var.minio_release_name
  repository = var.helm_repo_url
  chart      = var.helm_chart
  version    = var.minio_version
  namespace  = var.namespace

  reuse_values = true

  values = [
    templatefile("${path.module}/values.yaml", local.values_minio)
  ]
}
