# 三级架构 - 模块�?# Harbor镜像仓库模块

# 创建命名空间
resource "kubernetes_namespace" "harbor" {
  metadata {
    name = var.namespace
    labels = merge(
      var.tags,
      {
        "name"                          = var.namespace
        "prod-cloud-native-component"  = "harbor"
        "prod-cloud-native-resource"   = "namespace"
      }
    )
  }
}

# 安装Harbor
resource "helm_release" "harbor" {
  name       = "${var.environment}-${var.component}-harbor"
  namespace  = var.namespace
  repository = "https://helm.goharbor.io"
  chart      = "harbor"
  version    = var.chart_version

  set {
    name  = "expose.type"
    value = var.expose_type
  }

  set {
    name  = "expose.tls.enabled"
    value = var.tls_enabled
  }

  set {
    name  = "expose.tls.certSource"
    value = "auto"
  }

  set {
    name  = "expose.tls.auto.commonName"
    value = var.domain
  }

  set {
    name  = "externalURL"
    value = "http://${var.domain}"
  }

  set {
    name  = "persistence.enabled"
    value = "true"
  }

  set {
    name  = "persistence.resourcePolicy"
    value = "keep"
  }

  set {
    name  = "persistence.storageClass"
    value = var.storage_class
  }

  set {
    name  = "persistence.persistentVolumeClaim.registry.size"
    value = var.registry_pvc_size
  }

  set {
    name  = "persistence.persistentVolumeClaim.jobservice.size"
    value = var.jobservice_pvc_size
  }

  set {
    name  = "persistence.persistentVolumeClaim.database.size"
    value = var.database_pvc_size
  }

  set {
    name  = "persistence.persistentVolumeClaim.redis.size"
    value = var.redis_pvc_size
  }

  set {
    name  = "persistence.persistentVolumeClaim.trivy.size"
    value = var.trivy_pvc_size
  }

  set {
    name  = "harborAdminPassword"
    value = random_password.harbor_admin_password.result
  }

  set {
    name  = "internalTLS.enabled"
    value = "false"
  }

  set {
    name  = "database.type"
    value = "postgresql"
  }

  set {
    name  = "redis.type"
    value = "internal"
  }

  set {
    name  = "chartmuseum.enabled"
    value = "true"
  }

  set {
    name  = "notary.enabled"
    value = "true"
  }

  set {
    name  = "trivy.enabled"
    value = "true"
  }

  set {
    name  = "registry.replicas"
    value = var.registry_replicas
  }

  set {
    name  = "core.replicas"
    value = var.core_replicas
  }

  set {
    name  = "portal.replicas"
    value = var.portal_replicas
  }

  set {
    name  = "jobservice.replicas"
    value = var.jobservice_replicas
  }

  depends_on = [kubernetes_namespace.harbor]

  labels = merge(
    var.tags,
    {
      "prod-cloud-native-component"  = "harbor"
      "prod-cloud-native-resource"   = "helm-release"
    }
  )
}

# 创建Harbor管理员密�?resource "random_password" "harbor_admin_password" {
  length           = 20
  special          = true
  override_special = "_@$%"
}
