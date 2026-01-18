# ============================================================================
# Spinnaker Workflow Module - Main Configuration
# 三级架构: 资源�?- Workflow Deployment/Service
# 命名规范: ${var.environment}-${var.naming_prefix}-workflow-spinnaker-{resource-type}
# ============================================================================

# 创建命名空间
resource "kubernetes_namespace" "spinnaker" {
  metadata {
    name = var.namespace
    labels = merge(
      var.tags,
      {
        "name"                          = var.namespace
        "prod-cloud-native-component"  = "spinnaker"
        "prod-cloud-native-resource"   = "namespace"
      }
    )
  }
}

# 部署Spinnaker
resource "helm_release" "spinnaker" {
  name       = "${var.environment}-${var.naming_prefix}-workflow-spinnaker"
  namespace  = kubernetes_namespace.spinnaker.metadata[0].name
  repository = var.spinnaker_repository
  chart      = var.spinnaker_chart_name
  version    = var.spinnaker_chart_version
  timeout    = 1200

  set {
    name  = "halyard.image.repository"
    value = var.halyard_image_repository
  }

  set {
    name  = "halyard.image.tag"
    value = var.halyard_image_tag
  }

  set {
    name  = "halyard.image.pullPolicy"
    value = var.image_pull_policy
  }

  set {
    name  = "deck.service.type"
    value = var.deck_service_type
  }

  set {
    name  = "deck.service.port"
    value = var.deck_service_port
  }

  set {
    name  = "gate.service.type"
    value = var.gate_service_type
  }

  set {
    name  = "gate.service.port"
    value = var.gate_service_port
  }

  set {
    name  = "persistence.enabled"
    value = "true"
  }

  set {
    name  = "persistence.pvc.storageClassName"
    value = var.storage_class
  }

  set {
    name  = "persistence.pvc.accessModes[0]"
    value = "ReadWriteOnce"
  }

  set {
    name  = "persistence.pvc.size"
    value = var.storage_size
  }

  set {
    name  = "redis.persistence.enabled"
    value = "true"
  }

  set {
    name  = "redis.persistence.storageClass"
    value = var.storage_class
  }

  set {
    name  = "redis.persistence.size"
    value = "20Gi"
  }

  set {
    name  = "clouddriver.resources.requests.cpu"
    value = var.resources_requests_cpu
  }

  set {
    name  = "clouddriver.resources.requests.memory"
    value = var.resources_requests_memory
  }

  set {
    name  = "clouddriver.resources.limits.cpu"
    value = var.resources_limits_cpu
  }

  set {
    name  = "clouddriver.resources.limits.memory"
    value = var.resources_limits_memory
  }

  set {
    name  = "kubernetes.enabled"
    value = "true"
  }

  depends_on = [
    kubernetes_namespace.spinnaker
  ]
}
