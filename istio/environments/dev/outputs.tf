# ==============================================================================
# Dev环境输出
# ==============================================================================

output "istio_namespace" {
  description = "Istio安装的命名空间"
  value       = module.istio.istio_namespace
}

output "istiod_service_name" {
  description = "Istiod服务名称"
  value       = module.istio.istiod_service_name
}

output "ingress_gateway_service" {
  description = "Ingress Gateway服务信息"
  value       = module.istio.ingress_gateway_service
}

output "egress_gateway_service" {
  description = "Egress Gateway服务信息"
  value       = module.istio.egress_gateway_service
}

output "kubectl_commands" {
  description = "常用kubectl命令"
  value = {
    verify_installation = "kubectl get pods -n ${module.istio.istio_namespace}"
    check_services      = "kubectl get svc -n ${module.istio.istio_namespace}"
    check_status        = "istioctl version"
    check_logs_istiod   = "kubectl logs -n ${module.istio.istio_namespace} deployment/istiod"
    check_logs_ingress  = "kubectl logs -n ${module.istio.istio_namespace} deployment/istio-ingressgateway"
  }
}
