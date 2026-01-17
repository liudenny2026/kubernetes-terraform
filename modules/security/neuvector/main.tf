# 三级架构 - 模块�?# NeuVector安全模块

# 创建命名空间
resource "kubernetes_namespace" "neuvector" {
  metadata {
    name = var.namespace
    labels = merge(
      var.tags,
      {
        "name"                          = var.namespace
        "prod-cloud-native-component"  = "neuvector"
        "prod-cloud-native-resource"   = "namespace"
      }
    )
  }
}

# 安装NeuVector
resource "helm_release" "neuvector" {
  name       = "${var.environment}-${var.component}-neuvector"
  namespace  = var.namespace
  repository = "https://neuvector.github.io/neuvector-helm/"
  chart      = "neuvector"
  version    = var.chart_version

  set {
    name  = "image.registry"
    value = var.image_registry
  }

  set {
    name  = "image.tag"
    value = var.image_tag
  }

  set {
    name  = "cve.updater.image.registry"
    value = var.image_registry
  }

  set {
    name  = "cve.updater.image.tag"
    value = var.image_tag
  }

  set {
    name  = "manager.image.registry"
    value = var.image_registry
  }

  set {
    name  = "manager.image.tag"
    value = var.image_tag
  }

  set {
    name  = "controller.image.registry"
    value = var.image_registry
  }

  set {
    name  = "controller.image.tag"
    value = var.image_tag
  }

  set {
    name  = "enforcer.image.registry"
    value = var.image_registry
  }

  set {
    name  = "enforcer.image.tag"
    value = var.image_tag
  }

  set {
    name  = "scanner.image.registry"
    value = var.image_registry
  }

  set {
    name  = "scanner.image.tag"
    value = var.image_tag
  }

  # All-in-One模式配置
  set {
    name  = "allinone.enabled"
    value = var.use_allinone
  }

  # Manager配置
  set {
    name  = "manager.replicas"
    value = var.manager_replicas
  }

  set {
    name  = "manager.service.type"
    value = var.service_type
  }

  set {
    name  = "manager.livenessProbe.initialDelaySeconds"
    value = 30
  }

  set {
    name  = "manager.livenessProbe.periodSeconds"
    value = 10
  }

  set {
    name  = "manager.readinessProbe.initialDelaySeconds"
    value = 5
  }

  set {
    name  = "manager.readinessProbe.periodSeconds"
    value = 5
  }

  set {
    name  = "manager.resources.requests.cpu"
    value = var.manager_cpu_request
  }

  set {
    name  = "manager.resources.requests.memory"
    value = var.manager_memory_request
  }

  set {
    name  = "manager.resources.limits.cpu"
    value = var.manager_cpu_limit
  }

  set {
    name  = "manager.resources.limits.memory"
    value = var.manager_memory_limit
  }

  # Controller配置
  set {
    name  = "controller.replicas"
    value = var.controller_replicas
  }

  set {
    name  = "controller.resources.requests.cpu"
    value = var.controller_cpu_request
  }

  set {
    name  = "controller.resources.requests.memory"
    value = var.controller_memory_request
  }

  set {
    name  = "controller.resources.limits.cpu"
    value = var.controller_cpu_limit
  }

  set {
    name  = "controller.resources.limits.memory"
    value = var.controller_memory_limit
  }

  # Enforcer配置
  set {
    name  = "enforcer.resources.requests.cpu"
    value = var.enforcer_cpu_request
  }

  set {
    name  = "enforcer.resources.requests.memory"
    value = var.enforcer_memory_request
  }

  set {
    name  = "enforcer.resources.limits.cpu"
    value = var.enforcer_cpu_limit
  }

  set {
    name  = "enforcer.resources.limits.memory"
    value = var.enforcer_memory_limit
  }

  # Dashboard配置
  set {
    name  = "dashboard.service.type"
    value = var.service_type
  }

  # 调试模式
  set {
    name  = "manager.env.NVDEBUG"
    value = var.debug_mode ? "true" : "false"
  }

  set {
    name  = "controller.env.NVDEBUG"
    value = var.debug_mode ? "true" : "false"
  }

  set {
    name  = "enforcer.env.NVDEBUG"
    value = var.debug_mode ? "true" : "false"
  }

  # TLS配置
  set {
    name  = "manager.env.TLS_CIPHERS"
    value = "TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384:TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384:TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256:TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256"
  }

  # Prometheus导出�?  set {
    name  = "monitorPrometheusExporter.enabled"
    value = "true"
  }

  # 服务暴露配置
  set {
    name  = "manager.service.loadBalancer.enabled"
    value = var.expose_manager_loadbalancer
  }

  # RBAC配置
  set {
    name  = "rbac.create"
    value = var.create_rbac
  }

  depends_on = [kubernetes_namespace.neuvector]

  labels = merge(
    var.tags,
    {
      "prod-cloud-native-component"  = "neuvector"
      "prod-cloud-native-resource"   = "helm-release"
    }
  )
}

# 创建NeuVector管理员密�?resource "random_password" "neuvector_admin_password" {
  length           = 20
  special          = true
  override_special = "_@$%"
}
