# ============================================================================
# Resource Layer: CoreDNS ClusterRoleBinding
# 三级架构: 资源层 - 单个Kubernetes资源定义
# ============================================================================

resource "kubernetes_cluster_role_binding" "coredns" {
  metadata {
    name   = var.name
    labels = var.labels
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = var.clusterrole_name
  }

  subject {
    kind      = "ServiceAccount"
    name      = var.serviceaccount_name
    namespace = var.namespace
  }
}
