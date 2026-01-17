# ============================================================================
# Helm Workflow Module - Outputs
# ============================================================================

output "helm_example_namespace" {
  description = "Namespace for Helm example resources"
  value       = kubernetes_namespace.helm_example.metadata[0].name
}

output "helm_repos_config_map" {
  description = "ConfigMap storing Helm repository configurations"
  value       = kubernetes_config_map.helm_repos.metadata[0].name
}

output "helm_example_app_release" {
  description = "Name of the Helm example application release"
  value       = helm_release.helm_example_app.name
}

output "helm_example_app_service" {
  description = "Name of the Helm example application service"
  value       = "${helm_release.helm_example_app.name}-nginx"
}
