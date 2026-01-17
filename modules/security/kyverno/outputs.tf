# ============================================================================
# Kyverno Module - Outputs
# ============================================================================

output "kyverno_namespace" {
  description = "Kyverno namespace"
  value       = kubernetes_namespace.kyverno.metadata[0].name
}

output "kyverno_release_name" {
  description = "Kyverno Helm release name"
  value       = helm_release.kyverno.name
}

output "kyverno_version" {
  description = "Kyverno version"
  value       = var.kyverno_version
}

output "webhook_url" {
  description = "Kyverno webhook URL"
  value       = "${helm_release.kyverno.name}.${var.namespace}.svc:443"
}

output "background_scan_interval" {
  description = "Background scan interval"
  value       = var.background_scan_interval
}
