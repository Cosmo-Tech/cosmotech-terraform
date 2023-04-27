variable "redis_admin_password" {
  type = string
}

variable "namespace" {
  type = string
}

variable "resource_group" {
  type = string
}

variable "disk_name" {
  type = string
  default = "cosmotech-database-disk"
}

variable "helm_repo_url" {
  type    = string
  default = "https://charts.bitnami.com/bitnami"
}

variable "helm_release_name" {
  type    = string
  default = "cosmotechredis"
}

variable "helm_chart_name" {
  type    = string
  default = "redis"
}

variable "helm_chart_name_insights" {
  type = string
  default = "redisinsight"
}

variable "helm_chart_insights" {
  type = string
  default = "https://docs.redis.com/latest/pkgs/redisinsight-chart-0.1.0.tgz"
}

variable "redis_version" {
  type    = string
  default = "17.8.0"
}

variable "redis_pvc_name" {
  type    = string
  default = "cosmotech-database-master-pvc"
}

variable "redis_pv_name" {
  type    = string
  default = "cosmotech-database-master-pv"
}

variable "redis_pv_capacity" {
  type    = string
  default = "64Gi"
}

variable "redis_pv_driver" {
  type    = string
  default = "disk.csi.azure.com"
}

variable "version_redis_cosmotech" {
  type    = string
  default = "1.0.2"
}
