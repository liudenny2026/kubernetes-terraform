# ============================================================================
# Jenkins Workflow Module - Main Configuration
# 三级架构: 资源�?- Workflow Deployment/Service
# 命名规范: ${var.environment}-${var.naming_prefix}-workflow-jenkins-{resource-type}
# ============================================================================

# 创建命名空间
resource "kubernetes_namespace" "jenkins" {
  metadata {
    name = var.namespace
    labels = merge(
      var.tags,
      {
        "name"                          = var.namespace
        "prod-cloud-native-component"  = "jenkins"
        "prod-cloud-native-resource"   = "namespace"
      }
    )
  }
}

# 创建持久卷声�?resource "kubernetes_persistent_volume_claim" "jenkins_data" {
  metadata {
    name      = "${var.environment}-${var.naming_prefix}-workflow-jenkins-data"
    namespace = kubernetes_namespace.jenkins.metadata[0].name
    labels = merge(
      var.tags,
      {
        "prod-cloud-native-component"  = "jenkins"
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

# 部署Jenkins
resource "helm_release" "jenkins" {
  name       = "${var.environment}-${var.naming_prefix}-workflow-jenkins"
  namespace  = kubernetes_namespace.jenkins.metadata[0].name
  repository = var.jenkins_repository
  chart      = var.jenkins_chart_name
  version    = var.jenkins_chart_version
  timeout    = 600

  set {
    name  = "image.repository"
    value = var.jenkins_image_repository
  }

  set {
    name  = "image.tag"
    value = var.jenkins_image_tag
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
    value = kubernetes_persistent_volume_claim.jenkins_data.metadata[0].name
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
    name  = "service.jnlpPort"
    value = var.jnlp_port
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
    name  = "plugins"
    value = var.jenkins_plugins
  }

  set {
    name  = "adminUser"
    value = var.admin_user
  }

  set {
    name  = "adminPassword"
    value = var.admin_password
  }

  depends_on = [
    kubernetes_namespace.jenkins,
    kubernetes_persistent_volume_claim.jenkins_data
  ]
}
