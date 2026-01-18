# ============================================================================
# Fluentd Logging Module - Outputs
# ============================================================================

output "fluentd_namespace" {
  description = "Namespace where Fluentd is deployed"
  value       = kubernetes_namespace.fluentd.metadata[0].name
}

output "fluentd_release_name" {
  description = "Name of the Fluentd Helm release"
  value       = helm_release.fluentd.name
}

output "fluentd_chart_version" {
  description = "Helm chart version used for Fluentd"
  value       = helm_release.fluentd.chart_version
}
