# ============================================================================
# Tekton Workflow Module - Main Configuration
# 三级架构: 资源�?- Workflow Deployment/Service
# 命名规范: ${var.environment}-${var.naming_prefix}-workflow-tekton-{resource-type}
# ============================================================================

# 创建命名空间
resource "kubernetes_namespace" "tekton" {
  metadata {
    name = var.namespace
    labels = merge(
      var.tags,
      {
        "name"                          = var.namespace
        "prod-cloud-native-component"  = "tekton"
        "prod-cloud-native-resource"   = "namespace"
      }
    )
  }
}

# 部署Tekton Pipelines
resource "helm_release" "tekton_pipelines" {
  name       = "${var.environment}-${var.naming_prefix}-workflow-tekton-pipelines"
  namespace  = kubernetes_namespace.tekton.metadata[0].name
  repository = var.tekton_repository
  chart      = "tekton-pipeline"
  version    = var.tekton_pipelines_version
  timeout    = 300

  set {
    name  = "image.repository"
    value = var.tekton_image_repository
  }

  set {
    name  = "image.tag"
    value = var.tekton_image_tag
  }

  set {
    name  = "image.pullPolicy"
    value = var.image_pull_policy
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
    kubernetes_namespace.tekton
  ]
}

# 部署Tekton Dashboard
resource "helm_release" "tekton_dashboard" {
  name       = "${var.environment}-${var.naming_prefix}-workflow-tekton-dashboard"
  namespace  = kubernetes_namespace.tekton.metadata[0].name
  repository = var.tekton_repository
  chart      = "tekton-dashboard"
  version    = var.tekton_dashboard_version
  timeout    = 300

  set {
    name  = "image.repository"
    value = var.tekton_dashboard_image_repository
  }

  set {
    name  = "image.tag"
    value = var.tekton_dashboard_image_tag
  }

  set {
    name  = "service.type"
    value = var.dashboard_service_type
  }

  set {
    name  = "service.port"
    value = var.dashboard_service_port
  }

  depends_on = [
    helm_release.tekton_pipelines
  ]
}

# 部署Tekton Triggers
resource "helm_release" "tekton_triggers" {
  name       = "${var.environment}-${var.naming_prefix}-workflow-tekton-triggers"
  namespace  = kubernetes_namespace.tekton.metadata[0].name
  repository = var.tekton_repository
  chart      = "tekton-triggers"
  version    = var.tekton_triggers_version
  timeout    = 300

  set {
    name  = "image.repository"
    value = var.tekton_image_repository
  }

  set {
    name  = "image.tag"
    value = var.tekton_image_tag
  }

  depends_on = [
    helm_release.tekton_pipelines
  ]
}
