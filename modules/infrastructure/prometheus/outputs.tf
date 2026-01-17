# ============================================================================
# Prometheus & Grafana Module - Outputs
# ============================================================================

output "prometheus_namespace" {
  description = "Namespace where Prometheus is deployed"
  value       = kubernetes_namespace.monitoring.metadata[0].name
}

output "prometheus_release_name" {
  description = "Name of the Prometheus Helm release"
  value       = helm_release.prometheus.name
}

output "prometheus_chart_version" {
  description = "Helm chart version used for Prometheus"
  value       = helm_release.prometheus.chart_version
}

output "grafana_namespace" {
  description = "Namespace where Grafana is deployed"
  value       = kubernetes_namespace.monitoring.metadata[0].name
}
