# 三级架构 - 模块�?# Harbor模块输出

# Harbor URL
output "url" {
  value = "http://${kubernetes_service.harbor_portal.default[0].metadata[0].name}.${var.namespace}.svc.cluster.local"
  description = "Harbor仓库URL"
}

# Harbor API端点
output "api_endpoint" {
  value = "http://${kubernetes_service.harbor_core.default[0].metadata[0].name}.${var.namespace}.svc.cluster.local/api/v2.0"
  description = "Harbor API端点"
}

# Harbor命名空间
output "namespace" {
  value = kubernetes_namespace.harbor.metadata[0].name
  description = "Harbor部署命名空间"
}

# Harbor版本
output "version" {
  value = var.version
  description = "部署的Harbor版本"
}

# Harbor管理员密�?output "admin_password" {
  value = random_password.harbor_admin_password.result
  description = "Harbor管理员密�?
  sensitive = true
}

# 获取Harbor Portal服务信息
resource "kubernetes_service" "harbor_portal" {
  depends_on = [helm_release.harbor]
  metadata {
    name      = "${var.environment}-${var.component}-harbor-portal"
    namespace = var.namespace
  }
}

# 获取Harbor Core服务信息
resource "kubernetes_service" "harbor_core" {
  depends_on = [helm_release.harbor]
  metadata {
    name      = "${var.environment}-${var.component}-harbor-core"
    namespace = var.namespace
  }
}
