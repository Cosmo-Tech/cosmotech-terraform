locals {
  values_redis = {
    "REDIS_PASSWORD"          = var.redis_admin_password
    "VERSION_REDIS_COSMOTECH" = var.version_redis_cosmotech
    "REDIS_MASTER_NAME_PVC"   = var.redis_pvc_name
    "REDIS_DISK_SIZE"         = var.redis_pv_capacity
  }
}


variable "provider_name" {
  type    = string
  default = "azure"
}

data "azurerm_managed_disk" "managed_disk" {
  name                = "cosmotech-database-disk"
  resource_group_name = var.resource_group
  count               = var.provider_name == "azure" ? 1 : 0
}

data "aws_ebs_volume" "managed_disk" {
  most_recent = true

  filter {
    name   = "volume_name"
    values = ["cosmotech-database-disk"]
  }
  count = var.provider_name == "aws" ? 1 : 0
}

resource "kubernetes_persistent_volume_v1" "redis-pv" {
  for_each = {
    "aws" = {
      metadata = {
        name = var.redis_pv_name
        labels = {
          "cosmotech.com/service" = "redis"
        }
      }
      spec = {
        storage_class_name = ""
        access_modes       = ["ReadWriteOnce"]
        claim_ref = {
          name      = var.redis_pvc_name
          namespace = var.namespace
        }
        capacity = {
          storage = var.redis_pv_capacity
        }
        persistent_volume_source = {
          aws_elastic_block_store = {
            volume_id = data.aws_ebs_volume.managed_disk[0].id
          }
        }
        persistent_volume_reclaim_policy = "Retain"
      }
    },
    "azure" = {
      metadata = {
        name = var.redis_pv_name
        labels = {
          "cosmotech.com/service" = "redis"
        }
      }
      spec = {
        storage_class_name = ""
        access_modes       = ["ReadWriteOnce"]
        claim_ref = {
          name      = var.redis_pvc_name
          namespace = var.namespace
        }
        capacity = {
          storage = var.redis_pv_capacity
        }
        persistent_volume_source = {

          azure_disk = {
            caching_mode  = "ReadWrite"
            data_disk_uri = data.azurerm_managed_disk.managed_disk[0].id
            disk_name     = "cosmotech-database-disk"
            kind          = "Managed"
          }
        }
        persistent_volume_reclaim_policy = "Retain"
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim_v1" "redis-pvc" {
  metadata {
    name      = var.redis_pvc_name
    namespace = var.namespace
  }
  spec {
    storage_class_name = ""
    access_modes       = ["ReadWriteOnce"]
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
  name      = "redisinsight"
  namespace = var.namespace
  chart     = "https://docs.redis.com/latest/pkgs/redisinsight-chart-0.1.0.tgz"

  values = [file("${path.module}/values-insight.yaml")]
}
