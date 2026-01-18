# ============================================================================
# Metrics Server Module - Outputs
# ============================================================================

output "metrics_server_namespace" {
  description = "Namespace where Metrics Server is deployed"
  value       = kubernetes_namespace.metrics_server.metadata[0].name
}

output "metrics_server_release_name" {
  description = "Name of the Metrics Server Helm release"
  value       = helm_release.metrics_server.name
}

output "metrics_server_chart_version" {
  description = "Helm chart version used for Metrics Server"
  value       = helm_release.metrics_server.chart_version
}
