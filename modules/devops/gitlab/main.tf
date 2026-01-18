# 三级架构 - 模块�?# GitLab CI/CD模块

# 创建命名空间
resource "kubernetes_namespace" "gitlab" {
  metadata {
    name = var.namespace
    labels = merge(
      var.tags,
      {
        "name"                          = var.namespace
        "prod-cloud-native-component"  = "gitlab"
        "prod-cloud-native-resource"   = "namespace"
      }
    )
  }
}

# 安装GitLab
resource "helm_release" "gitlab" {
  name       = "${var.environment}-${var.component}-gitlab"
  namespace  = var.namespace
  repository = "https://charts.gitlab.io/"
  chart      = "gitlab"
  version    = var.chart_version

  set {
    name  = "global.hosts.domain"
    value = "${var.domain}"
  }

  set {
    name  = "global.hosts.externalIP"
    value = ""
  }

  set {
    name  = "global.hosts.https"
    value = "false"
  }

  set {
    name  = "global.hosts.gitlab.name"
    value = "${var.domain}"
  }

  set {
    name  = "global.edition"
    value = "ce"
  }

  set {
    name  = "global.initialRootPassword.secret"
    value = "${var.environment}-${var.component}-gitlab-root-password"
  }

  set {
    name  = "global.persistence.storageClass"
    value = var.storage_class
  }

  set {
    name  = "global.persistence.size"
    value = var.pvc_size
  }

  set {
    name  = "gitlab.webservice.resources.requests.cpu"
    value = var.gitlab_resources.requests.cpu
  }

  set {
    name  = "gitlab.webservice.resources.requests.memory"
    value = var.gitlab_resources.requests.memory
  }

  set {
    name  = "gitlab.webservice.resources.limits.cpu"
    value = var.gitlab_resources.limits.cpu
  }

  set {
    name  = "gitlab.webservice.resources.limits.memory"
    value = var.gitlab_resources.limits.memory
  }

  set {
    name  = "gitlab.gitaly.resources.requests.cpu"
    value = var.gitlab_resources.requests.cpu
  }

  set {
    name  = "gitlab.gitaly.resources.requests.memory"
    value = var.gitlab_resources.requests.memory
  }

  set {
    name  = "gitlab.gitaly.resources.limits.cpu"
    value = var.gitlab_resources.limits.cpu
  }

  set {
    name  = "gitlab.gitaly.resources.limits.memory"
    value = var.gitlab_resources.limits.memory
  }

  set {
    name  = "gitlab.sidekiq.resources.requests.cpu"
    value = var.gitlab_resources.requests.cpu
  }

  set {
    name  = "gitlab.sidekiq.resources.requests.memory"
    value = var.gitlab_resources.requests.memory
  }

  set {
    name  = "gitlab.sidekiq.resources.limits.cpu"
    value = var.gitlab_resources.limits.cpu
  }

  set {
    name  = "gitlab.sidekiq.resources.limits.memory"
    value = var.gitlab_resources.limits.memory
  }

  set {
    name  = "nginx-ingress.enabled"
    value = "false"
  }

  set {
    name  = "certmanager.install"
    value = "false"
  }

  set {
    name  = "prometheus.install"
    value = "false"
  }

  set {
    name  = "gitlab-runner.install"
    value = "true"
  }

  set {
    name  = "gitlab-runner.runners.privileged"
    value = "true"
  }

  set {
    name  = "gitlab-runner.runners.image"
    value = "ubuntu:22.04"
  }

  # 使用私有仓库配置
  set {
    name  = "global.image.repository"
    value = var.use_private_registry ? var.private_registry_url : "registry.gitlab.com/gitlab-org/build/cng"
  }

  depends_on = [kubernetes_namespace.gitlab, kubernetes_secret.gitlab_root_password]

  labels = merge(
    var.tags,
    {
      "prod-cloud-native-component"  = "gitlab"
      "prod-cloud-native-resource"   = "helm-release"
    }
  )
}

# 创建GitLab根密�?resource "random_password" "gitlab_root_password" {
  length           = 20
  special          = true
  override_special = "_@$%"
}

# 创建GitLab根密码Secret
resource "kubernetes_secret" "gitlab_root_password" {
  metadata {
    name      = "${var.environment}-${var.component}-gitlab-root-password"
    namespace = var.namespace
    labels = merge(
      var.tags,
      {
        "prod-cloud-native-component"  = "gitlab"
        "prod-cloud-native-resource"   = "secret"
      }
    )
  }

  data = {
    "password" = random_password.gitlab_root_password.result
  }

  depends_on = [kubernetes_namespace.gitlab]
}
