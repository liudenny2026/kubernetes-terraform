# ============================================================================
# Production Environment - Providers
# ============================================================================

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.24.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.12.0"
    }
  }

  backend "kubernetes" {
    secret_suffix = "prod"
    config_path   = "~/.kube/config"
    namespace     = "terraform-state"
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
  config_context = "kubernetes-admin@kubernetes"
}

provider "helm" {
  kubernetes {
    config_path   = "~/.kube/config"
    config_context = "kubernetes-admin@kubernetes"
  }
}
