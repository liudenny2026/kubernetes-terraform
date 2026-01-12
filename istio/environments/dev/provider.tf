# Kubernetes Provider - 使用本地kubeconfig文件连接集群
provider "kubernetes" {
  config_path = "~/.kube/config"

  # 可选：指定集群上下文
  # config_context = "your-cluster-context"
}

# Helm Provider - 用于通过Helm安装Istio
provider "helm" {
  kubernetes = {
    config_path = "~/.kube/config"
    # config_context = "your-cluster-context"
  }
}