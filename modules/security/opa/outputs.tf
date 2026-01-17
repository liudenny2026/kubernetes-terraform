# ============================================================================
# OPA Gatekeeper Module - Outputs
# ============================================================================

output "gatekeeper_namespace" {
  description = "OPA Gatekeeper namespace"
  value       = kubernetes_namespace.gatekeeper.metadata[0].name
}

output "gatekeeper_release_name" {
  description = "OPA Gatekeeper Helm release name"
  value       = helm_release.gatekeeper.name
}

output "gatekeeper_version" {
  description = "OPA Gatekeeper version"
  value       = var.gatekeeper_version
}

output "webhook_url" {
  description = "OPA Gatekeeper webhook URL"
  value       = "${helm_release.gatekeeper.name}-controller.${var.namespace}.svc:443"
}

output "audit_interval" {
  description = "Audit interval"
  value       = var.audit_interval
}
