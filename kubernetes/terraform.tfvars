location = ""
resource_group_name = ""

cosmotech_api = {
    "API_VERSION"="",
    "COSMOTECH_API_RELEASE_NAME"="",
    "COSMOTECH_API_DNS_NAME" = ""
}

nginx_resource = {
    "NGINX_INGRESS_CONTROLLER_LOADBALANCER_IP" = "",
    "NGINX_INGRESS_CONTROLLER_HELM_ADDITIONAL_OPTIONS" = ""
}

argo_resources = {
  # Both values below can be automatically generated
  "ARGO_MINIO_ACCESS_KEY" = "",
  "ARGO_MINIO_SECRET_KEY" = "",
}

# prometheus_stack_vars = {
#   "PROM_ADMIN_PASSWORD_VAR" = "${PROM_ADMIN_PASSWORD}"
# }

redis_resource_vars = {
  "REDIS_ADMIN_PASSWORD" = ""
}
