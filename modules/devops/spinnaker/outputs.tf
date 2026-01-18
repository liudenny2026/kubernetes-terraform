# ============================================================================
# Spinnaker Workflow Module - Outputs
# ============================================================================

output "spinnaker_namespace" {
  description = "Namespace where Spinnaker is deployed"
  value       = kubernetes_namespace.spinnaker.metadata[0].name
}

output "spinnaker_release_name" {
  description = "Name of the Spinnaker Helm release"
  value       = helm_release.spinnaker.name
}

output "spinnaker_deck_service_name" {
  description = "Name of the Spinnaker Deck (UI) service"
  value       = "${helm_release.spinnaker.name}-spinnaker-deck"
}

output "spinnaker_gate_service_name" {
  description = "Name of the Spinnaker Gate (API) service"
  value       = "${helm_release.spinnaker.name}-spinnaker-gate"
}

output "spinnaker_ui_url" {
  description = "URL for accessing Spinnaker UI"
  value       = "http://${helm_release.spinnaker.name}-spinnaker-deck.${kubernetes_namespace.spinnaker.metadata[0].name}.svc:${var.deck_service_port}"
}

output "spinnaker_api_url" {
  description = "URL for accessing Spinnaker API"
  value       = "http://${helm_release.spinnaker.name}-spinnaker-gate.${kubernetes_namespace.spinnaker.metadata[0].name}.svc:${var.gate_service_port}"
}
