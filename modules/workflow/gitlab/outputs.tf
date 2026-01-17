# 三级架构 - 模块�?# GitLab模块输出

# GitLab URL
output "url" {
  value = "http://${var.domain}"
  description = "GitLab访问URL"
}

# GitLab命名空间
output "namespace" {
  value = kubernetes_namespace.gitlab.metadata[0].name
  description = "GitLab部署命名空间"
}

# GitLab版本
output "version" {
  value = var.version
  description = "部署的GitLab版本"
}

# GitLab根密�?output "root_password" {
  value = random_password.gitlab_root_password.result
  description = "GitLab根用户密�?
  sensitive = true
}

# GitLab API端点
output "api_endpoint" {
  value = "http://${var.domain}/api/v4"
  description = "GitLab API端点"
}

# 获取GitLab服务信息
resource "kubernetes_service" "gitlab_webservice" {
  depends_on = [helm_release.gitlab]
  metadata {
    name      = "${var.environment}-${var.component}-gitlab-webservice-default"
    namespace = var.namespace
  }
}
