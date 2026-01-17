# 三级架构 - 模块�?# Istio模块输出

# Istio Gateway外部IP
output "gateway_ip" {
  value = kubernetes_service.istio_gateway.spec[0].cluster_ip
  description = "Istio Gateway外部IP地址"
}

# Istio命名空间
output "namespace" {
  value = kubernetes_namespace.istio_system.metadata[0].name
  description = "Istio部署命名空间"
}

# Istio版本
output "version" {
  value = var.version
  description = "部署的Istio版本"
}

# 获取Istio Gateway服务信息
resource "kubernetes_service" "istio_gateway" {
  depends_on = [helm_release.istio_gateway]
  metadata {
    name      = "${var.environment}-${var.component}-istio-gateway"
    namespace = var.namespace
  }
}
