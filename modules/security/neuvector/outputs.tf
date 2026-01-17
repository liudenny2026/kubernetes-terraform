# 三级架构 - 模块�?# NeuVector模块输出

# NeuVector Dashboard URL
output "dashboard_url" {
  value = "https://${kubernetes_service.neuvector_dashboard.default[0].metadata[0].name}.${var.namespace}.svc.cluster.local:8443"
  description = "NeuVector Dashboard URL"
}

# NeuVector命名空间
output "namespace" {
  value = kubernetes_namespace.neuvector.metadata[0].name
  description = "NeuVector部署命名空间"
}

# NeuVector版本
output "version" {
  value = var.version
  description = "部署的NeuVector版本"
}

# NeuVector管理员密�?output "admin_password" {
  value = random_password.neuvector_admin_password.result
  description = "NeuVector管理员密�?
  sensitive = true
}

# 获取NeuVector Dashboard服务信息
resource "kubernetes_service" "neuvector_dashboard" {
  depends_on = [helm_release.neuvector]
  metadata {
    name      = "neuvector-service-webui"
    namespace = var.namespace
  }
}
