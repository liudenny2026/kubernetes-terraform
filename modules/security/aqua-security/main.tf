# ============================================================================
# Aqua Security Module - Main Configuration
# 三级架构: 资源�?- Security Deployment/Service
# 命名规范: ${var.environment}-${var.naming_prefix}-security-aqua-{resource-type}
# ============================================================================

# 创建命名空间
resource "kubernetes_namespace" "aqua_security" {
  metadata {
    name = var.namespace
    labels = merge(
      var.tags,
      {
        "name"                          = var.namespace
        "prod-cloud-native-component"  = "aqua-security"
        "prod-cloud-native-resource"   = "namespace"
      }
    )
  }
}

# 创建持久卷声�?resource "kubernetes_persistent_volume_claim" "aqua_data" {
  metadata {
    name      = "${var.environment}-${var.naming_prefix}-security-aqua-data"
    namespace = kubernetes_namespace.aqua_security.metadata[0].name
    labels = merge(
      var.tags,
      {
        "prod-cloud-native-component"  = "aqua-security"
        "prod-cloud-native-resource"   = "pvc"
      }
    )
  }

  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = var.storage_size
      }
    }
    storage_class_name = var.storage_class
  }
}

# 部署Aqua Security
resource "helm_release" "aqua_security" {
  name       = "${var.environment}-${var.naming_prefix}-security-aqua"
  namespace  = kubernetes_namespace.aqua_security.metadata[0].name
  repository = var.aqua_repository
  chart      = var.aqua_chart_name
  version    = var.aqua_chart_version
  timeout    = 600

  set {
    name  = "image.repository"
    value = var.aqua_image_repository
  }

  set {
    name  = "image.tag"
    value = var.aqua_image_tag
  }

  set {
    name  = "image.pullPolicy"
    value = var.image_pull_policy
  }

  set {
    name  = "server.image.repository"
    value = var.aqua_server_image_repository
  }

  set {
    name  = "server.image.tag"
    value = var.aqua_image_tag
  }

  set {
    name  = "gateway.image.repository"
    value = var.aqua_gateway_image_repository
  }

  set {
    name  = "gateway.image.tag"
    value = var.aqua_image_tag
  }

  set {
    name  = "database.image.repository"
    value = var.aqua_database_image_repository
  }

  set {
    name  = "database.image.tag"
    value = var.aqua_database_image_tag
  }

  set {
    name  = "database.persistence.enabled"
    value = "true"
  }

  set {
    name  = "database.persistence.existingClaim"
    value = kubernetes_persistent_volume_claim.aqua_data.metadata[0].name
  }

  set {
    name  = "server.service.type"
    value = var.service_type
  }

  set {
    name  = "server.service.port"
    value = var.service_port
  }

  set {
    name  = "gateway.service.type"
    value = var.gateway_service_type
  }

  set {
    name  = "gateway.service.port"
    value = var.gateway_service_port
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
    kubernetes_namespace.aqua_security,
    kubernetes_persistent_volume_claim.aqua_data
  ]
}
