# 三级架构 - 模块�?# ArgoCD持续部署模块

# 创建命名空间
resource "kubernetes_namespace" "argocd" {
  metadata {
    name = var.namespace
    labels = merge(
      var.tags,
      {
        "name"                          = var.namespace
        "prod-cloud-native-component"  = "argocd"
        "prod-cloud-native-resource"   = "namespace"
      }
    )
  }
}

# 安装ArgoCD
resource "helm_release" "argocd" {
  name       = "${var.environment}-${var.component}-argocd"
  namespace  = var.namespace
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = var.chart_version

  set {
    name  = "global.image.repository"
    value = var.image_repository
  }

  set {
    name  = "server.image.repository"
    value = "${var.image_repository}/argocd-server"
  }

  set {
    name  = "repoServer.image.repository"
    value = "${var.image_repository}/argocd-repo-server"
  }

  set {
    name  = "dex.image.repository"
    value = "${var.image_repository}/dex"
  }

  set {
    name  = "redis.image.repository"
    value = "${var.image_repository}/redis"
  }

  set {
    name  = "applicationSet.controller.image.repository"
    value = "${var.image_repository}/argocd-applicationset-controller"
  }

  set {
    name  = "notifications.controller.image.repository"
    value = "${var.image_repository}/argocd-notifications-controller"
  }

  set {
    name  = "server.service.type"
    value = var.server_service_type
  }

  set {
    name  = "server.insecure"
    value = "true"
  }

  set {
    name  = "server.extraArgs[0]"
    value = "--insecure"
  }

  set {
    name  = "server.ingress.enabled"
    value = "false"
  }

  set {
    name  = "redis-ha.enabled"
    value = "true"
  }

  set {
    name  = "dex.enabled"
    value = "true"
  }

  set {
    name  = "controller.replicas"
    value = 2
  }

  set {
    name  = "repoServer.replicas"
    value = 2
  }

  set {
    name  = "server.replicas"
    value = 2
  }

  set {
    name  = "applicationSet.enabled"
    value = "true"
  }

  set {
    name  = "notifications.enabled"
    value = "true"
  }

  set {
    name  = "metrics.enabled"
    value = "true"
  }

  set {
    name  = "applicationSet.controller.resources.limits.cpu"
    value = "400m"
  }

  set {
    name  = "applicationSet.controller.resources.limits.memory"
    value = "512Mi"
  }

  set {
    name  = "applicationSet.controller.resources.requests.cpu"
    value = "200m"
  }

  set {
    name  = "applicationSet.controller.resources.requests.memory"
    value = "256Mi"
  }

  set {
    name  = "dex.resources.limits.cpu"
    value = "400m"
  }

  set {
    name  = "dex.resources.limits.memory"
    value = "512Mi"
  }

  set {
    name  = "dex.resources.requests.cpu"
    value = "200m"
  }

  set {
    name  = "dex.resources.requests.memory"
    value = "256Mi"
  }

  set {
    name  = "notifications.controller.resources.limits.cpu"
    value = "400m"
  }

  set {
    name  = "notifications.controller.resources.limits.memory"
    value = "512Mi"
  }

  set {
    name  = "notifications.controller.resources.requests.cpu"
    value = "200m"
  }

  set {
    name  = "notifications.controller.resources.requests.memory"
    value = "256Mi"
  }

  set {
    name  = "redis.haproxy.resources.limits.cpu"
    value = "400m"
  }

  set {
    name  = "redis.haproxy.resources.limits.memory"
    value = "256Mi"
  }

  set {
    name  = "redis.haproxy.resources.requests.cpu"
    value = "200m"
  }

  set {
    name  = "redis.haproxy.resources.requests.memory"
    value = "128Mi"
  }

  set {
    name  = "redis.resources.limits.cpu"
    value = "400m"
  }

  set {
    name  = "redis.resources.limits.memory"
    value = "512Mi"
  }

  set {
    name  = "redis.resources.requests.cpu"
    value = "200m"
  }

  set {
    name  = "redis.resources.requests.memory"
    value = "256Mi"
  }

  set {
    name  = "repoServer.resources.limits.cpu"
    value = "1000m"
  }

  set {
    name  = "repoServer.resources.limits.memory"
    value = "2Gi"
  }

  set {
    name  = "repoServer.resources.requests.cpu"
    value = "500m"
  }

  set {
    name  = "repoServer.resources.requests.memory"
    value = "1Gi"
  }

  set {
    name  = "server.resources.limits.cpu"
    value = "1000m"
  }

  set {
    name  = "server.resources.limits.memory"
    value = "1Gi"
  }

  set {
    name  = "server.resources.requests.cpu"
    value = "500m"
  }

  set {
    name  = "server.resources.requests.memory"
    value = "512Mi"
  }

  depends_on = [kubernetes_namespace.argocd]

  labels = merge(
    var.tags,
    {
      "prod-cloud-native-component"  = "argocd"
      "prod-cloud-native-resource"   = "helm-release"
    }
  )
}

# 创建ArgoCD管理员密�?resource "random_password" "argocd_admin_password" {
  length           = 20
  special          = true
  override_special = "_@$%"
}

# 创建ArgoCD密码Secret
resource "kubernetes_secret" "argocd_admin_secret" {
  metadata {
    name      = "${var.environment}-${var.component}-argocd-secret"
    namespace = var.namespace
    labels = merge(
      var.tags,
      {
        "prod-cloud-native-component"  = "argocd"
        "prod-cloud-native-resource"   = "secret"
      }
    )
  }

  data = {
    "admin.password" = random_password.argocd_admin_password.result
  }

  depends_on = [kubernetes_namespace.argocd]
}
