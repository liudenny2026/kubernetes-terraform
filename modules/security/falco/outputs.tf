# ============================================================================
# Falco Module - Outputs
# ============================================================================

output "falco_namespace" {
  description = "Falco namespace"
  value       = kubernetes_namespace.falco.metadata[0].name
}

output "falco_daemonset_name" {
  description = "Falco daemonset name"
  value       = kubernetes_daemonset.falco.metadata[0].name
}

output "falco_service_account_name" {
  description = "Falco service account name"
  value       = kubernetes_service_account.falco.metadata[0].name
}

output "falco_cluster_role_name" {
  description = "Falco cluster role name"
  value       = kubernetes_cluster_role.falco.metadata[0].name
}

output "falco_version" {
  description = "Falco version"
  value       = var.falco_version
}
