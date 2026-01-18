# Linkerd Service Mesh Module - Main Configuration
# Naming convention: ${var.environment}-${var.naming_prefix}-net-linkerd-{resource-type}

# Create Linkerd namespace
resource "kubernetes_namespace" "linkerd" {
  metadata {
    name = var.namespace
    labels = merge(
      var.tags,
      {
        "name"                          = var.namespace
        "prod-cloud-native-component"  = "linkerd"
        "prod-cloud-native-resource"   = "namespace"
      }
    )
  }
}

# Deploy Linkerd using Helm Chart
resource "helm_release" "linkerd" {
  name       = "${var.environment}-${var.naming_prefix}-net-linkerd"
  repository = var.linkerd_repository
  chart      = var.linkerd_chart_name
  version    = var.linkerd_chart_version
  namespace  = kubernetes_namespace.linkerd.metadata[0].name
  timeout    = 600

  set {
    name  = "enableHACodecs"
    value = var.enable_ha ? "true" : "false"
  }

  set {
    name  = "controllerResources.cpu.request"
    value = var.control_plane_cpu_request
  }

  set {
    name  = "controllerResources.memory.request"
    value = var.control_plane_memory_request
  }

  set {
    name  = "controllerResources.cpu.limit"
    value = var.control_plane_cpu_limit
  }

  set {
    name  = "controllerResources.memory.limit"
    value = var.control_plane_memory_limit
  }

  set {
    name  = "proxy.resources.cpu.request"
    value = var.proxy_cpu_request
  }

  set {
    name  = "proxy.resources.memory.request"
    value = var.proxy_memory_request
  }

  set {
    name  = "proxy.resources.cpu.limit"
    value = var.proxy_cpu_limit
  }

  set {
    name  = "proxy.resources.memory.limit"
    value = var.proxy_memory_limit
  }

  set {
    name  = "proxyInjector.defaultProxyInject"
    value = var.enable_proxy_injection ? "enabled" : "disabled"
  }

  set {
    name  = "cliVersion"
    value = var.linkerd_version
  }

  depends_on = [kubernetes_namespace.linkerd]
}