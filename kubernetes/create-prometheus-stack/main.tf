locals {
  values_prometheus_stack = {
    "MONITORING_NAMESPACE"          = var.monitoring_namespace
    "COSMOTECH_API_DNS_NAME"        = var.api_dns_name
    "TLS_SECRET_NAME"               = var.tls_secret_name
    "REDIS_HOST"                    = "cosmotechredis-master.${var.namespace}.svc.cluster.local"
    "REDIS_PORT"                    = var.redis_port
    "REDIS_ADMIN_PASSWORD"          = var.redis_admin_password
    "PROM_ADMIN_PASSWORD"           = var.prom_admin_password
    "PROM_REPLICAS_NUMBER"          = var.prom_replicas_number
    "PROM_STORAGE_RESOURCE_REQUEST" = var.prom_storage_resource_request
    "PROM_STORAGE_CLASS_NAME"       = var.prom_storage_class_name
    "PROM_CPU_MEM_LIMITS"           = var.prom_cpu_mem_limits
    "PROM_CPU_MEM_REQUESTS"         = var.prom_cpu_mem_request
  }
}

resource "helm_release" "prometheus-stack" {
  name = var.helm_release_name
  repository = var.helm_repo_url
  chart = var.helm_chart
  version = var.prometheus_stack_version
  namespace  = var.monitoring_namespace
  create_namespace = false

  reuse_values = true

  values = [
    templatefile("${path.module}/values.yaml", local.values_prometheus_stack)
  ]
}
