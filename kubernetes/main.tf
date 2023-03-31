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

resource "random_password" "prom_admin_password" {
  length           = 30
  special          = true
  override_special = "_%@"
}

resource "random_password" "redis_admin_password" {
  length           = 30
  special          = true
  override_special = "_%@"
}

resource "random_password" "argo_postgresql_password" {
  length           = 30
  special          = true
  override_special = "_%@"
}

resource "random_password" "argo_minio_secret_key" {
  length           = 30
  special          = true
  override_special = "_%@"
}

resource "random_password" "argo_minio_access_key" {
  length           = 30
  special          = true
  override_special = "_%@"
}
