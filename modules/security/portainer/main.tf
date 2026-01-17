# ============================================================================
# Portainer Security Module - Main Configuration
# 三级架构: 资源�?- Security Deployment/Service
# 命名规范: ${var.environment}-${var.naming_prefix}-security-portainer-{resource-type}
# ============================================================================

# 创建命名空间
resource "kubernetes_namespace" "portainer" {
  metadata {
    name = var.namespace
    labels = merge(
      var.tags,
      {
        "name"                          = var.namespace
        "prod-cloud-native-component"  = "portainer"
        "prod-cloud-native-resource"   = "namespace"
      }
    )
  }
}

# 创建持久卷声�?resource "kubernetes_persistent_volume_claim" "portainer_data" {
  metadata {
    name      = "${var.environment}-${var.naming_prefix}-security-portainer-data"
    namespace = kubernetes_namespace.portainer.metadata[0].name
    labels = merge(
      var.tags,
      {
        "prod-cloud-native-component"  = "portainer"
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

# 部署Portainer
resource "helm_release" "portainer" {
  name       = "${var.environment}-${var.naming_prefix}-security-portainer"
  namespace  = kubernetes_namespace.portainer.metadata[0].name
  repository = var.portainer_repository
  chart      = var.portainer_chart_name
  version    = var.portainer_chart_version
  timeout    = 300

  set {
    name  = "image.repository"
    value = var.portainer_image_repository
  }

  set {
    name  = "image.tag"
    value = var.portainer_image_tag
  }

  set {
    name  = "image.pullPolicy"
    value = var.image_pull_policy
  }

  set {
    name  = "persistence.enabled"
    value = "true"
  }

  set {
    name  = "persistence.existingClaim"
    value = kubernetes_persistent_volume_claim.portainer_data.metadata[0].name
  }

  set {
    name  = "service.type"
    value = var.service_type
  }

  set {
    name  = "service.port"
    value = var.service_port
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
    kubernetes_namespace.portainer,
    kubernetes_persistent_volume_claim.portainer_data
  ]
}
