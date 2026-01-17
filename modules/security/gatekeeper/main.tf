# ============================================================================
# Gatekeeper Security Module - Main Configuration
# 三级架构: 资源�?- Security Deployment/Service
# 命名规范: ${var.environment}-${var.naming_prefix}-security-gatekeeper-{resource-type}
# ============================================================================

# 创建命名空间
resource "kubernetes_namespace" "gatekeeper" {
  metadata {
    name = var.namespace
    labels = merge(
      var.tags,
      {
        "name"                          = var.namespace
        "prod-cloud-native-component"  = "gatekeeper"
        "prod-cloud-native-resource"   = "namespace"
      }
    )
  }
}

# 部署Gatekeeper
resource "helm_release" "gatekeeper" {
  name       = "${var.environment}-${var.naming_prefix}-security-gatekeeper"
  namespace  = kubernetes_namespace.gatekeeper.metadata[0].name
  repository = var.gatekeeper_repository
  chart      = var.gatekeeper_chart_name
  version    = var.gatekeeper_chart_version
  timeout    = 300

  set {
    name  = "image.repository"
    value = var.gatekeeper_image_repository
  }

  set {
    name  = "image.tag"
    value = var.gatekeeper_image_tag
  }

  set {
    name  = "image.pullPolicy"
    value = var.image_pull_policy
  }

  set {
    name  = "controller.replicas"
    value = var.controller_replicas
  }

  set {
    name  = "audit.replicas"
    value = var.audit_replicas
  }

  set {
    name  = "enableExternalData"
    value = var.enable_external_data
  }

  set {
    name  = "audit.enableMutation"
    value = var.enable_mutation
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
    kubernetes_namespace.gatekeeper
  ]
}
