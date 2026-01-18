# Rancher Kubernetes Management Platform Module - Main Configuration
# Naming convention: ${var.environment}-${var.naming_prefix}-plt-rancher-{resource-type}

# Create Rancher namespace
resource "kubernetes_namespace" "rancher" {
  metadata {
    name = var.namespace
    labels = merge(
      var.tags,
      {
        "name"                          = var.namespace
        "prod-cloud-native-component"  = "rancher"
        "prod-cloud-native-resource"   = "namespace"
      }
    )
  }
}

# Deploy Rancher using Helm Chart
resource "helm_release" "rancher" {
  name       = "${var.environment}-${var.naming_prefix}-plt-rancher"
  repository = var.rancher_repository
  chart      = var.rancher_chart_name
  version    = var.rancher_chart_version
  namespace  = kubernetes_namespace.rancher.metadata[0].name
  timeout    = 1200

  set {
    name  = "hostname"
    value = var.hostname
  }

  set {
    name  = "replicas"
    value = var.replica_count
  }

  set {
    name  = "bootstrapPassword"
    value = var.bootstrap_password
  }

  set {
    name  = "ingress.enabled"
    value = "true"
  }

  set {
    name  = "ingress.tls.source"
    value = var.ingress_tls_source
  }

  set {
    name  = "letsEncrypt.environment"
    value = var.lets_encrypt_environment
  }

  set {
    name  = "letsEncrypt.email"
    value = var.lets_encrypt_email
  }

  set {
    name  = "privateCA"
    value = var.private_ca ? "true" : "false"
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
    name  = "antiAffinity"
    value = "preferred"
  }

  set {
    name  = "auditLog.level"
    value = "1"
  }

  set {
    name  = "auditLog.destination"
    value = "stderr"
  }

  depends_on = [kubernetes_namespace.rancher]
}