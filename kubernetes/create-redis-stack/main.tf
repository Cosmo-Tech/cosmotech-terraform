locals {
  values_redis = {
    "REDIS_PASSWORD"          = var.redis_admin_password
    "VERSION_REDIS_COSMOTECH" = var.version_redis_cosmotech
    "REDIS_MASTER_NAME_PVC"   = var.redis_pvc_name
    "REDIS_DISK_SIZE"         = var.redis_pv_capacity
  }
}

data "azurerm_managed_disk" "managed_disk" {
  name                = var.disk_name
  resource_group_name = var.resource_group
}

locals {
  redis_disk_resource = data.azurerm_managed_disk.managed_disk.id
}

resource "kubernetes_persistent_volume_v1" "redis-pv" {
  metadata {
    name = var.redis_pv_name
    labels = {
      "cosmotech.com/service" = "redis"
    }
  }
  spec {
    storage_class_name = ""
    access_modes = ["ReadWriteOnce"]
    claim_ref {
      name      = var.redis_pvc_name
      namespace = var.namespace
    }
    capacity = {
      storage = var.redis_pv_capacity
    }
    persistent_volume_source {

      azure_disk {
        caching_mode  = "ReadWrite"
        data_disk_uri = local.redis_disk_resource
        disk_name     = var.disk_name
        kind          = "Managed"
      }
    }
    persistent_volume_reclaim_policy = "Retain"
  }
}

resource "kubernetes_persistent_volume_claim_v1" "redis-pvc" {
  metadata {
    name      = var.redis_pvc_name
    namespace = var.namespace
  }
  spec {
    storage_class_name = ""
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = var.redis_pv_capacity
      }
    }
    volume_name = var.redis_pv_name
  }
}

resource "helm_release" "cosmotechredis" {
  name       = var.helm_release_name
  repository = var.helm_repo_url
  chart      = var.helm_chart_name
  version    = var.redis_version
  namespace  = var.namespace

  reuse_values = true
  wait         = true

  values = [
    templatefile("${path.module}/values.yaml", local.values_redis)
  ]

  depends_on = [
    kubernetes_persistent_volume_v1.redis-pv, kubernetes_persistent_volume_claim_v1.redis-pvc
  ]
}

resource "helm_release" "redisinsight" {
  name = var.helm_chart_name_insights
  namespace = var.namespace
  chart = var.helm_chart_insights

  values = [file("${path.module}/values-insight.yaml")]
}
