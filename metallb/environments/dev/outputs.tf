output "namespace" {
  description = "MetalLB命名空间"
  value       = module.metallb.namespace
}

output "webhook_secret_name" {
  description = "Webhook证书Secret名称"
  value       = module.metallb.webhook_secret_name
}

output "ip_address_pool_name" {
  description = "IPAddressPool名称"
  value       = module.metallb.ip_address_pool_name
}

output "ip_addresses" {
  description = "IP地址池"
  value       = module.metallb.ip_addresses
}

output "l2_advertisement_name" {
  description = "L2Advertisement名称"
  value       = module.metallb.l2_advertisement_name
}
