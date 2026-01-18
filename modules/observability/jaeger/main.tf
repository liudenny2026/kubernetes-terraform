# Jaeger Distributed Tracing Module - Main Configuration
# Naming convention: ${var.environment}-${var.naming_prefix}-obs-jaeger-{resource-type}

# Create Jaeger namespace
resource "kubernetes_namespace" "jaeger" {
  metadata {
    name = var.namespace
    labels = merge(
      var.tags,
      {
        "name"                          = var.namespace
        "prod-cloud-native-component"  = "jaeger"
        "prod-cloud-native-resource"   = "namespace"
      }
    )
  }
}

# Deploy Jaeger using Helm Chart
resource "helm_release" "jaeger" {
  name       = "${var.environment}-${var.naming_prefix}-obs-jaeger"
  repository = var.jaeger_repository
  chart      = var.jaeger_chart_name
  version    = var.jaeger_chart_version
  namespace  = kubernetes_namespace.jaeger.metadata[0].name
  timeout    = 600

  set {
    name  = "provisionDataStore.elasticsearch"
    value = var.storage_type == "elasticsearch" ? "true" : "false"
  }

  set {
    name  = "storage.type"
    value = var.storage_type
  }

  set {
    name  = "agent.resources.requests.cpu"
    value = var.cpu_request
  }

  set {
    name  = "agent.resources.requests.memory"
    value = var.memory_request
  }

  set {
    name  = "agent.resources.limits.cpu"
    value = var.cpu_limit
  }

  set {
    name  = "agent.resources.limits.memory"
    value = var.memory_limit
  }

  set {
    name  = "collector.resources.requests.cpu"
    value = var.cpu_request
  }

  set {
    name  = "collector.resources.requests.memory"
    value = var.memory_request
  }

  set {
    name  = "collector.resources.limits.cpu"
    value = var.cpu_limit
  }

  set {
    name  = "collector.resources.limits.memory"
    value = var.memory_limit
  }

  set {
    name  = "query.resources.requests.cpu"
    value = var.cpu_request
  }

  set {
    name  = "query.resources.requests.memory"
    value = var.memory_request
  }

  set {
    name  = "query.resources.limits.cpu"
    value = var.cpu_limit
  }

  set {
    name  = "query.resources.limits.memory"
    value = var.memory_limit
  }

  set {
    name  = "allInOne.resources.requests.cpu"
    value = var.storage_type == "memory" ? var.cpu_request : ""
  }

  set {
    name  = "allInOne.resources.requests.memory"
    value = var.storage_type == "memory" ? var.memory_request : ""
  }

  set {
    name  = "allInOne.resources.limits.cpu"
    value = var.storage_type == "memory" ? var.cpu_limit : ""
  }

  set {
    name  = "allInOne.resources.limits.memory"
    value = var.storage_type == "memory" ? var.memory_limit : ""
  }

  depends_on = [kubernetes_namespace.jaeger]
}