# ============================================================================
# Production Environment - Provider Configuration
# 配置Kubernetes provider连接到生产集群
# ============================================================================

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

# 生产集群Provider配置
provider "kubernetes" {
  # 使用生产环境特定的kubeconfig路径
  config_path = var.kubeconfig_path
  # 指定生产集群上下文
  config_context = var.config_context
}

# 生产集群别名Provider（如果需要跨集群操作）
provider "kubernetes" {
  alias      = "production"
  config_path = var.kubeconfig_path
  config_context = var.config_context
}
