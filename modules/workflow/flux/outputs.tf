# ============================================================================
# Flux Workflow Module - Outputs
# ============================================================================

output "flux_namespace" {
  description = "Namespace where Flux CD is deployed"
  value       = kubernetes_namespace.flux.metadata[0].name
}

output "flux_release_name" {
  description = "Name of the Flux CD Helm release"
  value       = helm_release.flux.name
}

output "flux_source_controller_name" {
  description = "Name of the Flux Source Controller"
  value       = "flux-source-controller"
}

output "flux_kustomize_controller_name" {
  description = "Name of the Flux Kustomize Controller"
  value       = "flux-kustomize-controller"
}

output "flux_helm_controller_name" {
  description = "Name of the Flux Helm Controller"
  value       = "flux-helm-controller"
}

output "flux_notification_controller_name" {
  description = "Name of the Flux Notification Controller"
  value       = "flux-notification-controller"
}
