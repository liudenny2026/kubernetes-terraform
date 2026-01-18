# Traefik Ingress Controller Module - Main Configuration
# Naming convention: ${var.environment}-${var.naming_prefix}-net-traefik-{resource-type}

# Create Traefik namespace
resource "kubernetes_namespace" "traefik" {
  metadata {
    name = var.namespace
    labels = merge(
      var.tags,
      {
        "name"                          = var.namespace
        "prod-cloud-native-component"  = "traefik"
        "prod-cloud-native-resource"   = "namespace"
      }
    )
  }
}

# Deploy Traefik using Helm Chart
resource "helm_release" "traefik" {
  name       = "${var.environment}-${var.naming_prefix}-net-traefik"
  repository = var.traefik_repository
  chart      = var.traefik_chart_name
  version    = var.traefik_chart_version
  namespace  = kubernetes_namespace.traefik.metadata[0].name
  timeout    = 600

  set {
    name  = "deployment.replicas"
    value = var.replica_count
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
    name  = "service.type"
    value = var.service_type
  }

  set {
    name  = "logs.access.enabled"
    value = "true"
  }

  set {
    name  = "logs.access.format"
    value = "json"
  }

  set {
    name  = "logs.general.level"
    value = "INFO"
  }

  set {
    name  = "providers.kubernetesIngress.enabled"
    value = "true"
  }

  set {
    name  = "providers.kubernetesCRD.enabled"
    value = "true"
  }

  set {
    name  = "ingressClass.enabled"
    value = "true"
  }

  set {
    name  = "ingressClass.isDefaultClass"
    value = "true"
  }

  set {
    name  = "dashboard.enabled"
    value = var.enable_dashboard ? "true" : "false"
  }

  set {
    name  = "dashboard.ingressRoute"
    value = var.dashboard_ingress_enabled ? "true" : "false"
  }

  set {
    name  = "acme.enabled"
    value = var.acme_enabled ? "true" : "false"
  }

  set {
    name  = "acme.email"
    value = var.acme_email
  }

  set {
    name  = "acme.staging"
    value = "false"
  }

  set {
    name  = "acme.httpChallenge.entryPoint"
    value = "web"
  }

  depends_on = [kubernetes_namespace.traefik]
}