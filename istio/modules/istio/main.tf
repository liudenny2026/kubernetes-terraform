# ==============================================================================
# Istio Module
# 功能: 部署Istio服务网格到指定命名空间
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. 创建istio-system命名空间
# ------------------------------------------------------------------------------
resource "kubernetes_namespace_v1" "istio_system" {
  metadata {
    name = var.istio_namespace

    labels = {
      name                                    = var.istio_namespace
      istio-injection                         = "disabled"
      "pod-security.kubernetes.io/enforce"    = "privileged"
    }

    annotations = {
      description = "Istio系统组件命名空间"
    }
  }
}

# ------------------------------------------------------------------------------
# 2. 安装Istio Base CRDs (必需)
# ------------------------------------------------------------------------------
resource "helm_release" "istio_base" {
  name       = "istio-base"
  chart      = var.use_local_charts ? "${path.module}/../../charts/istio-${var.istio_version}/manifests/charts/base" : "base"
  repository = var.use_local_charts ? null : "https://charts.istio.io"
  namespace  = kubernetes_namespace_v1.istio_system.metadata[0].name
  version    = var.istio_version

  timeout       = 600
  wait          = true
  wait_for_jobs = true

  set = [{
    name  = "defaultRevision"
    value = "default"
  }]
}

# ------------------------------------------------------------------------------
# 3. 安装Istiod (控制平面)
# ------------------------------------------------------------------------------
resource "helm_release" "istiod" {
  count      = var.enable_istiod ? 1 : 0
  name       = "istiod"
  chart      = var.use_local_charts ? "${path.module}/../../charts/istio-${var.istio_version}/manifests/charts/istio-control/istio-discovery" : "istiod"
  repository = var.use_local_charts ? null : "https://charts.istio.io"
  namespace  = kubernetes_namespace_v1.istio_system.metadata[0].name
  version    = var.istio_version

  timeout       = 600
  wait          = true
  wait_for_jobs = true

  depends_on = [helm_release.istio_base]

  set = concat(
    var.registry_mirror != "" ? [{
      name  = "global.hub"
      value = var.registry_mirror
    }] : [],
    [
      {
        name  = "global.tag"
        value = var.istio_version
      },
      {
        name  = "replicaCount"
        value = tostring(var.istiod_replicas)
      },
      {
        name  = "autoscaling.enabled"
        value = "false"
      },
      {
        name  = "resources.requests.cpu"
        value = var.resources.istiod.cpu_request
      },
      {
        name  = "resources.requests.memory"
        value = var.resources.istiod.memory_request
      },
      {
        name  = "resources.limits.cpu"
        value = var.resources.istiod.cpu_limit
      },
      {
        name  = "resources.limits.memory"
        value = var.resources.istiod.memory_limit
      }
    ]
  )
}

# ------------------------------------------------------------------------------
# Istiod Service - 由Helm Chart自动创建
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# 4. 安装Ingress Gateway (如果启用)
# ------------------------------------------------------------------------------
resource "helm_release" "istio_ingressgateway" {
  count      = var.enable_ingress ? 1 : 0
  name       = "istio-ingress"
  chart      = var.use_local_charts ? "${path.module}/../../charts/istio-${var.istio_version}/manifests/charts/gateway" : "gateway"
  repository = var.use_local_charts ? null : "https://charts.istio.io"
  namespace  = kubernetes_namespace_v1.istio_system.metadata[0].name
  version    = var.istio_version

  timeout       = 600
  wait          = true
  wait_for_jobs = true

  depends_on = [helm_release.istio_base]

  set = concat(
    var.registry_mirror != "" ? [{
      name  = "global.hub"
      value = var.registry_mirror
    }] : [],
    [
      {
        name  = "global.tag"
        value = var.istio_version
      },
      {
        name  = "service.type"
        value = var.ingress_service_type
      },
      {
        name  = "replicaCount"
        value = tostring(var.ingress_replicas)
      },
      {
        name  = "autoscaling.enabled"
        value = tostring(var.enable_autoscaling)
      },
      {
        name  = "autoscaling.minReplicas"
        value = "1"
      },
      {
        name  = "autoscaling.maxReplicas"
        value = "5"
      },
      {
        name  = "resources.requests.cpu"
        value = var.resources.gateway.cpu_request
      },
      {
        name  = "resources.requests.memory"
        value = var.resources.gateway.memory_request
      },
      {
        name  = "resources.limits.cpu"
        value = var.resources.gateway.cpu_limit
      },
      {
        name  = "resources.limits.memory"
        value = var.resources.gateway.memory_limit
      }
    ]
  )
}

# ------------------------------------------------------------------------------
# Ingress Gateway Service - 由Helm Chart自动创建
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# 5. 安装Egress Gateway (如果启用)
# ------------------------------------------------------------------------------
resource "helm_release" "istio_egressgateway" {
  count      = var.enable_egress ? 1 : 0
  name       = "istio-egress"
  chart      = var.use_local_charts ? "${path.module}/../../charts/istio-${var.istio_version}/manifests/charts/gateway" : "gateway"
  repository = var.use_local_charts ? null : "https://charts.istio.io"
  namespace  = kubernetes_namespace_v1.istio_system.metadata[0].name
  version    = var.istio_version

  timeout       = 600
  wait          = true
  wait_for_jobs = true

  depends_on = [helm_release.istio_base]

  set = concat(
    var.registry_mirror != "" ? [{
      name  = "global.hub"
      value = var.registry_mirror
    }] : [],
    [
      {
        name  = "global.tag"
        value = var.istio_version
      },
      {
        name  = "service.type"
        value = "ClusterIP"
      },
      {
        name  = "replicaCount"
        value = "1"
      }
    ]
  )
}

# ------------------------------------------------------------------------------
# Egress Gateway Service - 由Helm Chart自动创建
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# 6. 创建默认Gateway示例 (如果启用Ingress)
# 注意: 已禁用此资源，因为 CRD 验证问题
# ------------------------------------------------------------------------------
# resource "kubernetes_manifest" "example_gateway" {
#   count = var.enable_ingress ? 1 : 0
#
#   manifest = {
#     apiVersion = "networking.istio.io/v1beta1"
#     kind       = "Gateway"
#     metadata = {
#       name      = "example-gateway"
#       namespace = var.istio_namespace
#     }
#     spec = {
#       selector = {
#         istio = "ingressgateway"
#       }
#       servers = [{
#         port = {
#           number   = 80
#           name     = "http"
#           protocol = "HTTP"
#         }
#         hosts = ["*"]
#       }]
#     }
#   }
#
#   depends_on = [helm_release.istio_ingressgateway]
# }
