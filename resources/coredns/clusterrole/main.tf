# ============================================================================
# Resource Layer: CoreDNS ClusterRole
# 三级架构: 资源层 - 单个Kubernetes资源定义
# ============================================================================

resource "kubernetes_cluster_role" "coredns" {
  metadata {
    name   = var.name
    labels = var.labels
  }

  rule {
    api_groups = [""]
    resources  = ["endpoints", "services", "pods", "namespaces"]
    verbs      = ["list", "watch"]
  }
}
