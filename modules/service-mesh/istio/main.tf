# 三级架构 - 模块�?# Istio服务网格模块

# 创建命名空间
resource "kubernetes_namespace" "istio_system" {
  metadata {
    name = var.namespace
    labels = merge(
      var.tags,
      {
        "name"                          = var.namespace
        "istio-injection"              = "disabled"
        "prod-cloud-native-component"  = "istio"
        "prod-cloud-native-resource"   = "namespace"
      }
    )
  }
}

# 安装Istio基础组件
resource "helm_release" "istio_base" {
  name       = "${var.environment}-${var.component}-istio-base"
  namespace  = var.namespace
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "base"
  version    = var.chart_version

  depends_on = [kubernetes_namespace.istio_system]

  labels = merge(
    var.tags,
    {
      "prod-cloud-native-component"  = "istio"
      "prod-cloud-native-resource"   = "helm-release"
      "prod-cloud-native-subcomponent" = "base"
    }
  )
}

# 安装Istio控制平面
resource "helm_release" "istiod" {
  name       = "${var.environment}-${var.component}-istiod"
  namespace  = var.namespace
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "istiod"
  version    = var.chart_version

  set {
    name  = "global.hub"
    value = var.registry_mirror != "" ? var.registry_mirror : "docker.io/istio"
  }

  set {
    name  = "global.tag"
    value = var.chart_version
  }

  set {
    name  = "global.proxy.image"
    value = "proxyv2"
  }

  set {
    name  = "replicaCount"
    value = var.istiod_replicas
  }

  set {
    name  = "autoscaling.enabled"
    value = "false"
  }

  set {
    name  = "resources.requests.cpu"
    value = var.resources.istiod.cpu_request
  }

  set {
    name  = "resources.requests.memory"
    value = var.resources.istiod.memory_request
  }

  set {
    name  = "resources.limits.cpu"
    value = var.resources.istiod.cpu_limit
  }

  set {
    name  = "resources.limits.memory"
    value = var.resources.istiod.memory_limit
  }

  depends_on = [helm_release.istio_base]

  labels = merge(
    var.tags,
    {
      "prod-cloud-native-component"  = "istio"
      "prod-cloud-native-resource"   = "helm-release"
      "prod-cloud-native-subcomponent" = "istiod"
    }
  )
}

# 安装Istio Gateway
resource "helm_release" "istio_gateway" {
  name       = "${var.environment}-${var.component}-istio-gateway"
  namespace  = var.namespace
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "gateway"
  version    = var.chart_version

  set {
    name  = "global.hub"
    value = var.registry_mirror != "" ? var.registry_mirror : "docker.io/istio"
  }

  set {
    name  = "global.tag"
    value = var.chart_version
  }

  set {
    name  = "service.type"
    value = var.ingress_service_type
  }

  set {
    name  = "replicaCount"
    value = var.ingress_replicas
  }

  set {
    name  = "autoscaling.enabled"
    value = var.enable_autoscaling
  }

  set {
    name  = "autoscaling.minReplicas"
    value = "1"
  }

  set {
    name  = "autoscaling.maxReplicas"
    value = "5"
  }

  set {
    name  = "resources.requests.cpu"
    value = var.resources.gateway.cpu_request
  }

  set {
    name  = "resources.requests.memory"
    value = var.resources.gateway.memory_request
  }

  set {
    name  = "resources.limits.cpu"
    value = var.resources.gateway.cpu_limit
  }

  set {
    name  = "resources.limits.memory"
    value = var.resources.gateway.memory_limit
  }

  depends_on = [helm_release.istiod]

  labels = merge(
    var.tags,
    {
      "prod-cloud-native-component"  = "istio"
      "prod-cloud-native-resource"   = "helm-release"
      "prod-cloud-native-subcomponent" = "gateway"
    }
  )
}

# 安装Istio Egress Gateway (如果启用)
resource "helm_release" "istio_egressgateway" {
  count      = var.enable_egress ? 1 : 0
  name       = "${var.environment}-${var.component}-istio-egress"
  namespace  = var.namespace
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "gateway"
  version    = var.chart_version

  set {
    name  = "global.hub"
    value = var.registry_mirror != "" ? var.registry_mirror : "docker.io/istio"
  }

  set {
    name  = "global.tag"
    value = var.chart_version
  }

  set {
    name  = "service.type"
    value = "ClusterIP"
  }

  set {
    name  = "replicaCount"
    value = "1"
  }

  depends_on = [helm_release.istiod]

  labels = merge(
    var.tags,
    {
      "prod-cloud-native-component"  = "istio"
      "prod-cloud-native-resource"   = "helm-release"
      "prod-cloud-native-subcomponent" = "egressgateway"
    }
  )
}
