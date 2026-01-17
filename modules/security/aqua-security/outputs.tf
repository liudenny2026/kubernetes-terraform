# ============================================================================
# Aqua Security Module - Outputs
# ============================================================================

output "aqua_security_namespace" {
  description = "Namespace where Aqua Security is deployed"
  value       = kubernetes_namespace.aqua_security.metadata[0].name
}

output "aqua_security_release_name" {
  description = "Name of the Aqua Security Helm release"
  value       = helm_release.aqua_security.name
}

output "aqua_security_service_name" {
  description = "Name of the Aqua Security server service"
  value       = "${helm_release.aqua_security.name}-aqua-server"
}

output "aqua_security_gateway_service_name" {
  description = "Name of the Aqua Security gateway service"
  value       = "${helm_release.aqua_security.name}-aqua-gateway"
}

output "aqua_security_pvc_name" {
  description = "Name of the Aqua Security database persistent volume claim"
  value       = kubernetes_persistent_volume_claim.aqua_data.metadata[0].name
}
