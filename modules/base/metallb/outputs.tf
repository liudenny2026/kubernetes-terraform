output "namespace" {
  description = "MetalLB命名空间"
  value       = kubernetes_namespace_v1.metallb.metadata[0].name
}

output "webhook_secret_name" {
  description = "Webhook证书Secret名称"
  value       = "metallb-webhook-cert"
}

output "ip_address_pool_name" {
  description = "IPAddressPool名称"
  value       = var.ip_address_pool_name
}

output "ip_addresses" {
  description = "IP地址�?
  value       = var.ip_addresses
}

output "l2_advertisement_name" {
  description = "L2Advertisement名称"
  value       = var.l2_advertisement_name
}
