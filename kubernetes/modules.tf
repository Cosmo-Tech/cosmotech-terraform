module "create-ingress-nginx" {
  source = "./create-ingress-nginx"

  namespace             = var.namespace
  monitoring_namespace  = var.monitoring_namespace
  ingress_nginx_version = var.ingress_nginx_version
  loadbalancer_ip       = var.loadbalancer_ip
  tls_secret_name       = var.tls_secret_name

  # depends_on = [
  #   module.create-prometheus-stack
  # ]
}

# TODO: Use dedicated terraform module ?
module "create-prometheus-stack" {
  source = "./create-prometheus-stack"

  namespace            = var.namespace
  monitoring_namespace = var.monitoring_namespace
  api_dns_name         = var.api_dns_name
  tls_secret_name      = var.tls_secret_name
  redis_admin_password = var.redis_admin_password
  prom_admin_password  = var.prom_admin_password

  depends_on = [
    module.cert-manager
  ]
}

# module "create-cert-manager" {
#   source = "./create-cert-manager"

#   namespace            = var.namespace
#   monitoring_namespace = var.monitoring_namespace
# }

module "cert-manager" {
  source  = "terraform-iaac/cert-manager/kubernetes"
  version = "2.5.0"

  cluster_issuer_email = var.cluster_issuer_email
  cluster_issuer_name  = var.cluster_issuer_name
}

module "create-redis-stack" {
  source = "./create-redis-stack"

  redis_admin_password = var.redis_admin_password
  namespace            = var.namespace
  resource_group       = var.resource_group
  # redis_disk_resource  = var.redis_disk_resource
}

module "create-minio" {
  source = "./create-minio"

  namespace             = var.namespace
  monitoring_namespace  = var.monitoring_namespace
  argo_minio_access_key = var.argo_minio_access_key
  argo_minio_secret_key = var.argo_minio_secret_key
}

module "create-postgresql-db" {
  source = "./create-postgresql-db"

  namespace                = var.namespace
  monitoring_namespace     = var.monitoring_namespace
  argo_postgresql_password = var.argo_postgresql_password
}

module "create-argo" {
  source = "./create-argo"

  namespace            = var.namespace
  monitoring_namespace = var.monitoring_namespace
}

# module "create-cosmotech-api" {
#   source = "./create-cosmotech-api"

#   api_dns_name = var.api_dns_name
# }
