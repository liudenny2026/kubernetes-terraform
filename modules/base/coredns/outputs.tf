# ============================================================================
# CoreDNS Module - Outputs
# ============================================================================

output "coredns_deployment_name" {
  description = "Name of the CoreDNS Deployment"
  value       = module.coredns_deployment.name
}

output "coredns_service_name" {
  description = "Name of the CoreDNS Service"
  value       = module.coredns_service.name
}

output "coredns_service_account_name" {
  description = "Name of the CoreDNS ServiceAccount"
  value       = module.coredns_service_account.name
}

output "coredns_cluster_role_name" {
  description = "Name of the CoreDNS ClusterRole"
  value       = module.coredns_clusterrole.name
}

output "coredns_namespace" {
  description = "Namespace where CoreDNS is deployed"
  value       = var.namespace
}
