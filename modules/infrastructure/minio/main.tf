# 三级架构 - 模块�?# MinIO对象存储模块

# 创建命名空间
resource "kubernetes_namespace" "minio" {
  metadata {
    name = var.namespace
    labels = merge(
      var.tags,
      {
        "name"                          = var.namespace
        "prod-cloud-native-component"  = "minio"
        "prod-cloud-native-resource"   = "namespace"
      }
    )
  }
}

# 安装MinIO
resource "helm_release" "minio" {
  name       = "${var.environment}-${var.component}-minio"
  namespace  = var.namespace
  repository = "https://charts.min.io/"
  chart      = "minio"
  version    = var.chart_version

  set {
    name  = "image.repository"
    value = var.image_repository
  }

  set {
    name  = "image.tag"
    value = var.image_tag
  }

  set {
    name  = "mode"
    value = "distributed"
  }

  set {
    name  = "numberOfNodes"
    value = 4
  }

  set {
    name  = "persistence.size"
    value = var.storage_size
  }

  set {
    name  = "persistence.storageClass"
    value = var.storage_class
  }

  set {
    name  = "resources.requests.memory"
    value = var.memory_request
  }

  set {
    name  = "resources.requests.cpu"
    value = var.cpu_request
  }

  set {
    name  = "resources.limits.memory"
    value = var.memory_limit
  }

  set {
    name  = "resources.limits.cpu"
    value = var.cpu_limit
  }

  set {
    name  = "console.enabled"
    value = "true"
  }

  set {
    name  = "ingress.enabled"
    value = "false"
  }

  set {
    name  = "service.type"
    value = var.service_type
  }

  set {
    name  = "livenessProbe.initialDelaySeconds"
    value = 30
  }

  set {
    name  = "livenessProbe.periodSeconds"
    value = 20
  }

  set {
    name  = "livenessProbe.timeoutSeconds"
    value = 5
  }

  set {
    name  = "readinessProbe.initialDelaySeconds"
    value = 10
  }

  set {
    name  = "readinessProbe.periodSeconds"
    value = 10
  }

  set {
    name  = "readinessProbe.timeoutSeconds"
    value = 5
  }

  set {
    name  = "startupProbe.initialDelaySeconds"
    value = 30
  }

  set {
    name  = "startupProbe.periodSeconds"
    value = 10
  }

  set {
    name  = "startupProbe.timeoutSeconds"
    value = 5
  }

  set {
    name  = "startupProbe.failureThreshold"
    value = 30
  }

  set {
    name  = "securityContext.runAsUser"
    value = var.minio_user_id
  }

  set {
    name  = "securityContext.runAsGroup"
    value = var.minio_group_id
  }

  set {
    name  = "securityContext.fsGroup"
    value = var.minio_group_id
  }

  set {
    name  = "securityContext.fsGroupChangePolicy"
    value = "OnRootMismatch"
  }

  set {
    name  = "containerSecurityContext.allowPrivilegeEscalation"
    value = false
  }

  set {
    name  = "containerSecurityContext.capabilities.drop[0]"
    value = "ALL"
  }

  set {
    name  = "containerSecurityContext.readOnlyRootFilesystem"
    value = false
  }

  set {
    name  = "containerSecurityContext.runAsNonRoot"
    value = true
  }

  set {
    name  = "containerSecurityContext.runAsUser"
    value = var.minio_user_id
  }

  set {
    name  = "containerSecurityContext.seccompProfile.type"
    value = "RuntimeDefault"
  }

  depends_on = [kubernetes_namespace.minio]

  labels = merge(
    var.tags,
    {
      "prod-cloud-native-component"  = "minio"
      "prod-cloud-native-resource"   = "helm-release"
    }
  )
}

# 创建MinIO S3访问密钥
resource "random_password" "minio_access_key" {
  length           = 20
  special          = false
  override_special = "_"
}

resource "random_password" "minio_secret_key" {
  length           = 40
  special          = false
  override_special = "_"
}

# 创建MinIO访问密钥Secret
resource "kubernetes_secret" "minio_creds" {
  metadata {
    name      = "${var.environment}-${var.component}-minio-creds"
    namespace = var.namespace
    labels = merge(
      var.tags,
      {
        "prod-cloud-native-component"  = "minio"
        "prod-cloud-native-resource"   = "secret"
      }
    )
  }

  data = {
    "accesskey" = random_password.minio_access_key.result
    "secretkey" = random_password.minio_secret_key.result
  }

  depends_on = [kubernetes_namespace.minio]
}
