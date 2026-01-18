# Loki Log Aggregation Module - Main Configuration
# Naming convention: ${var.environment}-${var.naming_prefix}-obs-loki-{resource-type}

# Create Loki namespace
resource "kubernetes_namespace" "loki" {
  metadata {
    name = var.namespace
    labels = merge(
      var.tags,
      {
        "name"                          = var.namespace
        "prod-cloud-native-component"  = "loki"
        "prod-cloud-native-resource"   = "namespace"
      }
    )
  }
}

# Deploy Loki using Helm Chart
resource "helm_release" "loki" {
  name       = "${var.environment}-${var.naming_prefix}-obs-loki"
  repository = var.loki_repository
  chart      = var.loki_chart_name
  version    = var.loki_chart_version
  namespace  = kubernetes_namespace.loki.metadata[0].name
  timeout    = 600

  set {
    name  = "loki.resources.requests.cpu"
    value = var.cpu_request
  }

  set {
    name  = "loki.resources.requests.memory"
    value = var.memory_request
  }

  set {
    name  = "loki.resources.limits.cpu"
    value = var.cpu_limit
  }

  set {
    name  = "loki.resources.limits.memory"
    value = var.memory_limit
  }

  set {
    name  = "loki.persistence.enabled"
    value = "true"
  }

  set {
    name  = "loki.persistence.size"
    value = var.storage_size
  }

  set {
    name  = "loki.persistence.storageClassName"
    value = var.storage_class
  }

  set {
    name  = "promtail.enabled"
    value = var.enable_promtail ? "true" : "false"
  }

  set {
    name  = "promtail.resources.requests.cpu"
    value = var.cpu_request
  }

  set {
    name  = "promtail.resources.requests.memory"
    value = var.memory_request
  }

  set {
    name  = "promtail.resources.limits.cpu"
    value = var.cpu_limit
  }

  set {
    name  = "promtail.resources.limits.memory"
    value = var.memory_limit
  }

  set {
    name  = "grafana.enabled"
    value = var.enable_grafana ? "true" : "false"
  }

  set {
    name  = "filebeat.enabled"
    value = "false"
  }

  set {
    name  = "logstash.enabled"
    value = "false"
  }

  depends_on = [kubernetes_namespace.loki]
}