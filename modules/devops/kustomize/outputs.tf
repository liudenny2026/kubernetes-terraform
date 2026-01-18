# ============================================================================
# Kustomize Workflow Module - Outputs
# ============================================================================

output "kustomize_example_namespace" {
  description = "Namespace for Kustomize example resources"
  value       = kubernetes_namespace.kustomize_example.metadata[0].name
}

output "kustomize_base_config_map" {
  description = "ConfigMap storing Kustomize base configuration"
  value       = kubernetes_config_map.kustomize_base.metadata[0].name
}

output "kustomize_dev_overlay_config_map" {
  description = "ConfigMap storing Kustomize dev overlay configuration"
  value       = kubernetes_config_map.kustomize_dev_overlay.metadata[0].name
}

output "kustomize_prod_overlay_config_map" {
  description = "ConfigMap storing Kustomize prod overlay configuration"
  value       = kubernetes_config_map.kustomize_prod_overlay.metadata[0].name
}
