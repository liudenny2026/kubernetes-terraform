# ============================================================================
# Metrics Server Module - Main Configuration
# 三级架构: 资源�?- Metrics Deployment/Service
# 命名规范: ${var.environment}-${var.naming_prefix}-infra-metrics-{resource-type}
# ============================================================================

# 创建命名空间
resource "kubernetes_namespace" "metrics_server" {
  metadata {
    name = var.namespace
    labels = merge(
      var.tags,
      {
        "name"                          = var.namespace
        "prod-cloud-native-component"  = "metrics-server"
        "prod-cloud-native-resource"   = "namespace"
      }
    )
  }
}

# 部署Metrics Server
resource "helm_release" "metrics_server" {
  name       = "${var.environment}-${var.naming_prefix}-infra-metrics-server"
  namespace  = kubernetes_namespace.metrics_server.metadata[0].name
  repository = var.repository
  chart      = var.chart
  version    = var.chart_version
  timeout    = 300

  set {
    name  = "image.repository"
    value = var.image_repository
  }

  set {
    name  = "image.tag"
    value = var.image_tag
  }

  set {
    name  = "image.pullPolicy"
    value = var.image_pull_policy
  }

  set {
    name  = "args[0]"
    value = "--cert-dir=/tmp"
  }

  set {
    name  = "args[1]"
    value = "--secure-port=4443"
  }

  set {
    name  = "args[2]"
    value = "--kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname"
  }

  set {
    name  = "args[3]"
    value = "--kubelet-use-node-status-port"
  }

  set {
    name  = "args[4]"
    value = "--metric-resolution=15s"
  }

  set {
    name  = "args[5]"
    value = "--kubelet-insecure-tls"
  }

  set {
    name  = "resources.requests.cpu"
    value = var.resources_requests_cpu
  }

  set {
    name  = "resources.requests.memory"
    value = var.resources_requests_memory
  }

  set {
    name  = "resources.limits.cpu"
    value = var.resources_limits_cpu
  }

  set {
    name  = "resources.limits.memory"
    value = var.resources_limits_memory
  }

  depends_on = [
    kubernetes_namespace.metrics_server
  ]
}
