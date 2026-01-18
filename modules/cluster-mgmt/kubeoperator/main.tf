# KubeOperator Platform Module - Main Configuration
# Naming convention: ${var.environment}-${var.naming_prefix}-plt-kubeoperator-{resource-type}

# Create KubeOperator namespace
resource "kubernetes_namespace" "kubeoperator" {
  metadata {
    name = var.namespace
    labels = merge(
      var.tags,
      {
        "name"                          = var.namespace
        "prod-cloud-native-component"  = "kubeoperator"
        "prod-cloud-native-resource"   = "namespace"
      }
    )
  }
}

# Deploy KubeOperator using Helm Chart
resource "helm_release" "kubeoperator" {
  name       = "${var.environment}-${var.naming_prefix}-plt-kubeoperator"
  repository = var.kubeoperator_repository
  chart      = var.kubeoperator_chart_name
  version    = var.kubeoperator_chart_version
  namespace  = kubernetes_namespace.kubeoperator.metadata[0].name
  timeout    = 1200

  set {
    name  = "image.repository"
    value = "kubeoperator/kubeoperator"
  }

  set {
    name  = "image.tag"
    value = var.kubeoperator_version
  }

  set {
    name  = "image.pullPolicy"
    value = "IfNotPresent"
  }

  set {
    name  = "resources.requests.cpu"
    value = var.cpu_request
  }

  set {
    name  = "resources.requests.memory"
    value = var.memory_request
  }

  set {
    name  = "resources.limits.cpu"
    value = var.cpu_limit
  }

  set {
    name  = "resources.limits.memory"
    value = var.memory_limit
  }

  set {
    name  = "persistence.enabled"
    value = "true"
  }

  set {
    name  = "persistence.size"
    value = var.storage_size
  }

  set {
    name  = "persistence.storageClassName"
    value = var.storage_class
  }

  set {
    name  = "backup.enabled"
    value = var.enable_backup ? "true" : "false"
  }

  set {
    name  = "backup.storageSize"
    value = var.backup_storage_size
  }

  set {
    name  = "service.type"
    value = "NodePort"
  }

  set {
    name  = "service.port"
    value = "80"
  }

  set {
    name  = "ingress.enabled"
    value = "false"
  }

  depends_on = [kubernetes_namespace.kubeoperator]
}