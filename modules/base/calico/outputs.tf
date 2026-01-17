# ============================================================================
# Calico Network Plugin Module - Outputs
# ============================================================================

output "calico_release_name" {
  description = "Name of the Calico Helm release"
  value       = helm_release.calico.name
}

output "calico_namespace" {
  description = "Namespace where Calico is deployed"
  value       = kubernetes_namespace.calico.metadata[0].name
}

output "calico_version" {
  description = "Calico version deployed"
  value       = var.calico_version
}

output "calico_chart_version" {
  description = "Calico Helm chart version"
  value       = var.calico_chart_version
}
