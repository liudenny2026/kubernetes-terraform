# Longhorn Storage Module - Main Configuration
# Naming convention: ${var.environment}-${var.naming_prefix}-sto-longhorn-{resource-type}

# Create Longhorn namespace
resource "kubernetes_namespace" "longhorn" {
  metadata {
    name = var.namespace
    labels = merge(
      var.tags,
      {
        "name"                          = var.namespace
        "prod-cloud-native-component"  = "longhorn"
        "prod-cloud-native-resource"   = "namespace"
      }
    )
  }
}

# Deploy Longhorn using Helm Chart
resource "helm_release" "longhorn" {
  name       = "${var.environment}-${var.naming_prefix}-sto-longhorn"
  repository = var.longhorn_repository
  chart      = var.longhorn_chart_name
  version    = var.longhorn_chart_version
  namespace  = kubernetes_namespace.longhorn.metadata[0].name
  timeout    = 600

  set {
    name  = "defaultImagePullPolicy"
    value = "IfNotPresent"
  }

  set {
    name  = "defaultReplicaCount"
    value = var.default_replica_count
  }

  set {
    name  = "longhornManager.resources.requests.cpu"
    value = var.cpu_request
  }

  set {
    name  = "longhornManager.resources.requests.memory"
    value = var.memory_request
  }

  set {
    name  = "longhornManager.resources.limits.cpu"
    value = var.cpu_limit
  }

  set {
    name  = "longhornManager.resources.limits.memory"
    value = var.memory_limit
  }

  set {
    name  = "longhornDriver.resources.requests.cpu"
    value = var.cpu_request
  }

  set {
    name  = "longhornDriver.resources.requests.memory"
    value = var.memory_request
  }

  set {
    name  = "longhornDriver.resources.limits.cpu"
    value = var.cpu_limit
  }

  set {
    name  = "longhornDriver.resources.limits.memory"
    value = var.memory_limit
  }

  set {
    name  = "longhornUI.resources.requests.cpu"
    value = var.cpu_request
  }

  set {
    name  = "longhornUI.resources.requests.memory"
    value = var.memory_request
  }

  set {
    name  = "longhornUI.resources.limits.cpu"
    value = var.cpu_limit
  }

  set {
    name  = "longhornUI.resources.limits.memory"
    value = var.memory_limit
  }

  set {
    name  = "ui.enabled"
    value = "true"
  }

  set {
    name  = "ui.replicaCount"
    value = var.ui_replica_count
  }

  set {
    name  = "persistence.defaultClass"
    value = var.create_default_storage_class ? "true" : "false"
  }

  set {
    name  = "persistence.defaultClassReplicaCount"
    value = var.default_replica_count
  }

  depends_on = [kubernetes_namespace.longhorn]
}