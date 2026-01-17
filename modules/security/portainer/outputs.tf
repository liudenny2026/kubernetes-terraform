# ============================================================================
# Portainer Security Module - Outputs
# ============================================================================

output "portainer_namespace" {
  description = "Namespace where Portainer is deployed"
  value       = kubernetes_namespace.portainer.metadata[0].name
}

output "portainer_release_name" {
  description = "Name of the Portainer Helm release"
  value       = helm_release.portainer.name
}

output "portainer_service_name" {
  description = "Name of the Portainer service"
  value       = "${helm_release.portainer.name}-portainer"
}

output "portainer_pvc_name" {
  description = "Name of the Portainer persistent volume claim"
  value       = kubernetes_persistent_volume_claim.portainer_data.metadata[0].name
}
