# ============================================================================
# Tekton Workflow Module - Outputs
# ============================================================================

output "tekton_namespace" {
  description = "Namespace where Tekton is deployed"
  value       = kubernetes_namespace.tekton.metadata[0].name
}

output "tekton_pipelines_release_name" {
  description = "Name of the Tekton Pipelines Helm release"
  value       = helm_release.tekton_pipelines.name
}

output "tekton_dashboard_release_name" {
  description = "Name of the Tekton Dashboard Helm release"
  value       = helm_release.tekton_dashboard.name
}

output "tekton_triggers_release_name" {
  description = "Name of the Tekton Triggers Helm release"
  value       = helm_release.tekton_triggers.name
}

output "tekton_dashboard_service_name" {
  description = "Name of the Tekton Dashboard service"
  value       = "${helm_release.tekton_dashboard.name}-tekton-dashboard"
}

output "tekton_dashboard_url" {
  description = "URL for accessing Tekton Dashboard"
  value       = "http://${helm_release.tekton_dashboard.name}-tekton-dashboard.${kubernetes_namespace.tekton.metadata[0].name}.svc:${var.dashboard_service_port}"
}
