# ============================================================================
# Flux Workflow Module - Main Configuration
# 三级架构: 资源�?- Workflow Deployment/Service
# 命名规范: ${var.environment}-${var.naming_prefix}-workflow-flux-{resource-type}
# ============================================================================

# 创建命名空间
resource "kubernetes_namespace" "flux" {
  metadata {
    name = var.namespace
    labels = merge(
      var.tags,
      {
        "name"                          = var.namespace
        "prod-cloud-native-component"  = "flux"
        "prod-cloud-native-resource"   = "namespace"
      }
    )
  }
}

# 部署Flux CD
resource "helm_release" "flux" {
  name       = "${var.environment}-${var.naming_prefix}-workflow-flux"
  namespace  = kubernetes_namespace.flux.metadata[0].name
  repository = var.flux_repository
  chart      = var.flux_chart_name
  version    = var.flux_chart_version
  timeout    = 600

  set {
    name  = "image.repository"
    value = var.flux_image_repository
  }

  set {
    name  = "image.tag"
    value = var.flux_image_tag
  }

  set {
    name  = "image.pullPolicy"
    value = var.image_pull_policy
  }

  set {
    name  = "sourceController.enabled"
    value = "true"
  }

  set {
    name  = "sourceController.image.repository"
    value = var.source_controller_image_repository
  }

  set {
    name  = "sourceController.image.tag"
    value = var.flux_image_tag
  }

  set {
    name  = "kustomizeController.enabled"
    value = "true"
  }

  set {
    name  = "kustomizeController.image.repository"
    value = var.kustomize_controller_image_repository
  }

  set {
    name  = "kustomizeController.image.tag"
    value = var.flux_image_tag
  }

  set {
    name  = "helmController.enabled"
    value = "true"
  }

  set {
    name  = "helmController.image.repository"
    value = var.helm_controller_image_repository
  }

  set {
    name  = "helmController.image.tag"
    value = var.flux_image_tag
  }

  set {
    name  = "notificationController.enabled"
    value = "true"
  }

  set {
    name  = "notificationController.image.repository"
    value = var.notification_controller_image_repository
  }

  set {
    name  = "notificationController.image.tag"
    value = var.flux_image_tag
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
    kubernetes_namespace.flux
  ]
}
