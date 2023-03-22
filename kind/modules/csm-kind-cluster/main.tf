locals {
  kind_config = {
    "host_path_to_mount": "~/kind_mount",
    "container_path": "/data",
    "registry_port": "5000",
    "registry_name": "kind-registry"
  }
}

resource "kind_cluster" "new" {
  name          = var.cluster_name
  image         = "kindest/node:${var.cluster_version}"
  config        = templatefile("${path.module}/config.yaml", local.kind_config)
}