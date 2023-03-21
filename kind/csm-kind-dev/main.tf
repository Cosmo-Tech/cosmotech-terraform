module "csm-kind-cluster" {
  source = "../modules/csm-kind-cluster"

  cluster_name = var.cluster_name
  cluster_version = var.cluster_version
}
