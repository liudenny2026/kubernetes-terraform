output "namespace" {
  description = "MetalLB命名空间"
  value       = kubernetes_namespace_v1.metallb.metadata[0].name
}

output "webhook_secret_name" {
  description = "Webhook证书Secret名称"
  value       = "metallb-webhook-cert"
}

# 新增：多IP地址池输出
output "ip_address_pools" {
  description = "MetalLB IP地址池配置列表"
  value       = var.ip_address_pools
}

# 新增：L2广告配置输出
output "l2_advertisements" {
  description = "MetalLB L2广告配置列表"
  value       = var.l2_advertisements
}

# 新增：BGP对等体配置输出
output "bgp_peers" {
  description = "MetalLB BGP对等体配置列表"
  value       = var.bgp_peers
}

# 新增：BGP广告配置输出
output "bgp_advertisements" {
  description = "MetalLB BGP广告配置列表"
  value       = var.bgp_advertisements
}

# 模块和应用版本输出
output "module_version" {
  description = "MetalLB模块版本"
  value       = "0.2.0"
}

output "metallb_version" {
  description = "MetalLB应用版本"
  value       = var.metallb_version
}

# 控制器和Speaker资源输出
output "controller_deployment" {
  description = "MetalLB控制器Deployment名称"
  value       = "controller"
}

output "speaker_daemonset" {
  description = "MetalLB Speaker DaemonSet名称"
  value       = "speaker"
}
