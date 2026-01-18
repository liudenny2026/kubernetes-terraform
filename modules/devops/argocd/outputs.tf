# 三级架构 - 模块�?# ArgoCD模块输出

# ArgoCD URL
output "url" {
  value = "http://${kubernetes_service.argocd_server.default[0].metadata[0].name}.${var.namespace}.svc.cluster.local:8080"
  description = "ArgoCD Dashboard URL"
}

# ArgoCD命名空间
output "namespace" {
  value = kubernetes_namespace.argocd.metadata[0].name
  description = "ArgoCD部署命名空间"
}

# ArgoCD版本
output "version" {
  value = var.version
  description = "部署的ArgoCD版本"
}

# ArgoCD管理员密�?output "admin_password" {
  value = random_password.argocd_admin_password.result
  description = "ArgoCD管理员密�?
  sensitive = true
}

# 获取ArgoCD Server服务信息
resource "kubernetes_service" "argocd_server" {
  depends_on = [helm_release.argocd]
  metadata {
    name      = "argocd-server"
    namespace = var.namespace
  }
}
