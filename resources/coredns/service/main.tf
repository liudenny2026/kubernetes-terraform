# ============================================================================
# Resource Layer: CoreDNS Service
# 三级架构: 资源层 - 单个Kubernetes资源定义
# ============================================================================

resource "kubernetes_service" "coredns" {
  metadata {
    name      = var.name
    namespace = var.namespace
    labels    = var.labels
    annotations = var.enable_metrics ? {
      "prometheus.io/scrape" = "true"
      "prometheus.io/port"   = "9153"
    } : {}
  }

  spec {
    type = "ClusterIP"

    selector = {
      app       = var.selector_labels.app
      component = var.selector_labels.component
    }

    port {
      name       = "dns"
      port       = 53
      target_port = 53
      protocol   = "UDP"
    }

    port {
      name       = "dns-tcp"
      port       = 53
      target_port = 53
      protocol   = "TCP"
    }

    port {
      name       = "metrics"
      port       = 9153
      target_port = 9153
      protocol   = "TCP"
    }
  }
}
