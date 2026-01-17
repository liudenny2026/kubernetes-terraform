# ============================================================================
# Gatekeeper Security Module - Outputs
# ============================================================================

output "gatekeeper_namespace" {
  description = "Namespace where Gatekeeper is deployed"
  value       = kubernetes_namespace.gatekeeper.metadata[0].name
}

output "gatekeeper_release_name" {
  description = "Name of the Gatekeeper Helm release"
  value       = helm_release.gatekeeper.name
}

output "gatekeeper_chart_version" {
  description = "Helm chart version used for Gatekeeper"
  value       = helm_release.gatekeeper.chart_version
}
