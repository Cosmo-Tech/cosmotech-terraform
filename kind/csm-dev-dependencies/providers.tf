terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.18.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.9.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.14.0"
    }
    kind = {
      source = "justenwalker/kind"
      version = "0.17.0"
    }
  }
}

provider "kind" {
  provider   = "docker"
  kubeconfig = pathexpand("~/.kube/config")
}
