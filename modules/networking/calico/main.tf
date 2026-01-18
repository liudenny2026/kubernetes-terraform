# ============================================================================
# Calico Network Plugin Module - Main Configuration
# 三级架构: 资源�?- Network Deployment/Service
# 命名规范: ${var.environment}-${var.naming_prefix}-base-calico-{resource-type}
# ============================================================================

# Calico namespace
resource "kubernetes_namespace" "calico" {
  metadata {
    name = var.namespace
    labels = merge(var.tags, {
      app       = "calico"
      component = "base"
      tier      = "network"
    })
  }
}

# Deploy Calico using Helm Chart
resource "helm_release" "calico" {
  name       = "calico"
  repository = var.calico_repository
  chart      = var.calico_chart_name
  version    = var.calico_chart_version
  namespace  = kubernetes_namespace.calico.metadata[0].name
  timeout    = 600

  set {
    name  = "image.repository"
    value = "docker.io/calico/cni"
  }

  set {
    name  = "image.tag"
    value = var.calico_version
  }

  set {
    name  = "image.pullPolicy"
    value = "IfNotPresent"
  }

  set {
    name  = "operator.image.repository"
    value = "docker.io/calico/kube-controllers"
  }

  set {
    name  = "operator.image.tag"
    value = var.calico_version
  }

  set {
    name  = "typha.image.repository"
    value = "docker.io/calico/typha"
  }

  set {
    name  = "typha.image.tag"
    value = var.calico_version
  }

  set {
    name  = "node.image.repository"
    value = "docker.io/calico/node"
  }

  set {
    name  = "node.image.tag"
    value = var.calico_version
  }

  set {
    name  = "cni.image.repository"
    value = "docker.io/calico/cni"
  }

  set {
    name  = "cni.image.tag"
    value = var.calico_version
  }

  set {
    name  = "felix.image.repository"
    value = "docker.io/calico/felix"
  }

  set {
    name  = "felix.image.tag"
    value = var.calico_version
  }

  # Network configuration
  set {
    name  = "ipam.type"
    value = "calico-ipam"
  }

  set {
    name  = "calicoNetwork.ipPools[0].cidr"
    value = var.pod_cidr
  }

  set {
    name  = "calicoNetwork.ipPools[0].blockSize"
    value = 26
  }

  set {
    name  = "calicoNetwork.ipPools[0].natOutgoing"
    value = true
  }

  set {
    name  = "calicoNetwork.ipPools[0].nodeSelector"
    value = "all()"
  }

  depends_on = [kubernetes_namespace.calico]
}
