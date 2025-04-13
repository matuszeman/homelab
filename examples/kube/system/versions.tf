terraform {
  required_providers {
    kubectl = {
      source = "gavinbunney/kubectl"
      version = ">= 1.19.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.36.0"
    }
    helm = {
      source = "hashicorp/helm"
      version = ">= 3.0.0-pre2"
    }
  }
}

