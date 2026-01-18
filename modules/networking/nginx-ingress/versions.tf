terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.12.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.23.0"
    }
    time = {
      source  = "hashicorp/time"
      version = ">= 0.10.0"
    }
  }

  required_version = ">= 1.0"
}
