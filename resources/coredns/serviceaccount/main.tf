# ============================================================================
# Resource Layer: CoreDNS ServiceAccount
# 三级架构: 资源层 - 单个Kubernetes资源定义
# ============================================================================

resource "kubernetes_service_account" "coredns" {
  metadata {
    name      = var.name
    namespace = var.namespace
    labels    = var.labels
  }
}
