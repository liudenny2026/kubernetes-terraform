# ============================================================================
# Trivy Security Module - Outputs
# ============================================================================

output "trivy_namespace" {
  description = "Namespace where Trivy is deployed"
  value       = kubernetes_namespace.trivy.metadata[0].name
}

output "trivy_operator_release_name" {
  description = "Name of the Trivy Operator Helm release"
  value       = helm_release.trivy_operator.name
}

output "trivy_chart_version" {
  description = "Helm chart version used for Trivy"
  value       = helm_release.trivy_operator.chart_version
}
