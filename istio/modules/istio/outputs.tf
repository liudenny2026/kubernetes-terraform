output "istio_namespace" {
  description = "Istio安装的命名空间"
  value       = kubernetes_namespace_v1.istio_system.metadata[0].name
}

output "istiod_service_name" {
  description = "Istiod服务名称"
  value       = "istiod"
}

output "ingress_gateway_service" {
  description = "Ingress Gateway服务信息"
  value = try({
    name      = "istio-ingress"
    namespace = kubernetes_namespace_v1.istio_system.metadata[0].name
    type      = var.ingress_service_type
  }, null)
}

output "egress_gateway_service" {
  description = "Egress Gateway服务信息"
  value = try({
    name      = "istio-egress"
    namespace = kubernetes_namespace_v1.istio_system.metadata[0].name
    type      = "ClusterIP"
  }, null)
}
