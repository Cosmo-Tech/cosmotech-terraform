locals {
  values_redis = {
    "REDIS_PASSWORD"          = var.redis_admin_password
    "VERSION_REDIS_COSMOTECH" = var.version_redis_cosmotech
    "REDIS_MASTER_NAME_PVC"   = var.redis_pvc_name
    "REDIS_DISK_SIZE"         = var.redis_pv_capacity
  }
}

data "azurerm_managed_disk" "managed_disk" {
  name                = "cosmotech-database-disk"
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
        caching_mode  = "Read Write"
        data_disk_uri = data.azurerm_managed_disk.managed_disk.id
        disk_name     = "cosmotech-database-disk"
        kind          = "Managed"
        fs_type = "ext4"
      }
      
      # csi {
      #   driver        = var.redis_pv_driver
      #   volume_handle = local.redis_disk_resource
      #   volume_attributes = {
      #     "fsType" = "ext4"
      #   }
      # }
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

# From Terraform helm provider example
# resource "helm_release" "redis" {
#   name       = "cosmotechredis"
#   repository = "https://charts.bitnami.com/bitnami"
#   chart      = "redis"
#   version    = var.redis_version

#   values = [
#     templatefile("${path.module}/values.yaml", local.value)
#   ]

#   set {
#     name  = "cluster.enabled"
#     value = "true"
#   }

#   set {
#     name  = "metrics.enabled"
#     value = "true"
#   }

#   set {
#     name  = "service.annotations.prometheus\\.io/port"
#     value = "9127"
#     type  = "string"
#   }
# }


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
    kubernetes_persistent_volume.redis-pv, kubernetes_persistent_volume_claim.redis-pvc
  ]
}

# resource "helm_release" "redisinsight" {
#   name = "redisinsight"
#   namespace = var.namespace
#   repository = ""
#   chart = ""
#   version = ""

#   values = "${path.module}/values-insight.yaml"
# }
