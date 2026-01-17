# ============================================================================
# Trivy Security Module - Main Configuration
# 三级架构: 资源�?- Security Deployment/Service
# 命名规范: ${var.environment}-${var.naming_prefix}-security-trivy-{resource-type}
# ============================================================================

# 创建命名空间
resource "kubernetes_namespace" "trivy" {
  metadata {
    name = var.namespace
    labels = merge(
      var.tags,
      {
        "name"                          = var.namespace
        "prod-cloud-native-component"  = "trivy"
        "prod-cloud-native-resource"   = "namespace"
      }
    )
  }
}

# 部署Trivy操作�?resource "helm_release" "trivy_operator" {
  name       = "${var.environment}-${var.naming_prefix}-security-trivy-operator"
  namespace  = kubernetes_namespace.trivy.metadata[0].name
  repository = var.trivy_repository
  chart      = var.trivy_chart_name
  version    = var.trivy_chart_version
  timeout    = 300

  set {
    name  = "image.repository"
    value = var.trivy_image_repository
  }

  set {
    name  = "image.tag"
    value = var.trivy_image_tag
  }

  set {
    name  = "image.pullPolicy"
    value = var.image_pull_policy
  }

  set {
    name  = "installCRDs"
    value = "true"
  }

  set {
    name  = "scanJob.ttlSecondsAfterFinished"
    value = 3600
  }

  set {
    name  = "scanJob.resources.requests.cpu"
    value = var.resources_requests_cpu
  }

  set {
    name  = "scanJob.resources.requests.memory"
    value = var.resources_requests_memory
  }

  set {
    name  = "scanJob.resources.limits.cpu"
    value = var.resources_limits_cpu
  }

  set {
    name  = "scanJob.resources.limits.memory"
    value = var.resources_limits_memory
  }

  set {
    name  = "trivy.mode"
    value = var.trivy_mode
  }

  set {
    name  = "trivy.vulnType"
    value = var.trivy_vuln_type
  }

  set {
    name  = "trivy.severity"
    value = var.trivy_severity
  }

  depends_on = [
    kubernetes_namespace.trivy
  ]
}
