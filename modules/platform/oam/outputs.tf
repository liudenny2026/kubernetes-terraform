output "oam_namespace" {
  description = "OAM namespace"
  value       = kubernetes_namespace.oam.metadata[0].name
}

output "oam_runtime_helm_release_name" {
  description = "OAM runtime Helm release name"
  value       = helm_release.oam_runtime.name
}

output "oam_runtime_helm_release_status" {
  description = "OAM runtime Helm release status"
  value       = helm_release.oam_runtime.status
}