# ============================================================================# Development Environment - Provider Configuration# 配置Kubernetes provider连接到集群# ============================================================================

terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.23.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.0.0"
    }
  }
}

# Kubernetes Provider Configuration# 使用默认kubeconfig文件连接到集群
provider "kubernetes" {
  # 使用默认kubeconfig路径
  config_path = "~/.kube/config"
  # 如果需要使用特定上下文，可以取消注释以下行
  # config_context = "your-context-name"
}
