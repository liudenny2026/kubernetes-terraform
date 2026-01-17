# ============================================================================
# Fluentd Logging Module - Main Configuration
# 三级架构: 资源�?- Logging Deployment/Service
# 命名规范: ${var.environment}-${var.naming_prefix}-infra-fluentd-{resource-type}
# ============================================================================

# 创建命名空间
resource "kubernetes_namespace" "fluentd" {
  metadata {
    name = var.namespace
    labels = merge(
      var.tags,
      {
        "name"                          = var.namespace
        "prod-cloud-native-component"  = "fluentd"
        "prod-cloud-native-resource"   = "namespace"
      }
    )
  }
}

# 部署Fluentd
resource "helm_release" "fluentd" {
  name       = "${var.environment}-${var.naming_prefix}-infra-fluentd"
  namespace  = kubernetes_namespace.fluentd.metadata[0].name
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
    name  = "elasticsearch.host"
    value = var.elasticsearch_host
  }

  set {
    name  = "elasticsearch.port"
    value = var.elasticsearch_port
  }

  set {
    name  = "elasticsearch.scheme"
    value = var.elasticsearch_scheme
  }

  set {
    name  = "elasticsearch.sslVerify"
    value = var.elasticsearch_ssl_verify
  }

  set {
    name  = "buffer.type"
    value = "file"
  }

  set {
    name  = "buffer.path"
    value = "/var/log/fluentd/buffer"
  }

  set {
    name  = "buffer.chunk_limit_size"
    value = "256M"
  }

  set {
    name  = "buffer.queue_limit_length"
    value = 32
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

  set {
    name  = "nodeSelector.node-role.kubernetes.io/worker"
    value = "true"
  }

  set {
    name  = "tolerations[0].key"
    value = "node-role.kubernetes.io/control-plane"
  }

  set {
    name  = "tolerations[0].operator"
    value = "Exists"
  }

  set {
    name  = "tolerations[0].effect"
    value = "NoSchedule"
  }

  depends_on = [
    kubernetes_namespace.fluentd
  ]
}
