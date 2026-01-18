terraform {
  required_version = ">= 1.0.0"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.23.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.12.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.5.0"
    }
    time = {
      source  = "hashicorp/time"
      version = ">= 0.9.1"
    }
    keycloak = {
      source  = "mrparkers/keycloak"
      version = ">= 4.3.0"
    }
  }
}

provider "kubernetes" {
  config_path = var.kubeconfig_path
}

provider "helm" {
  kubernetes {
    config_path = var.kubeconfig_path
  }
}

provider "random" {}

provider "time" {}

provider "keycloak" {
  client_id     = "admin-cli"
  client_secret = var.admin_password
  url           = "http://${var.release_name}.${var.namespace}.svc.cluster.local:${var.http_port}"
  initial_login {
    username = var.admin_user
    password = var.admin_password
  }
}
