output "namespace" {
  description = "Namespace where Keycloak is installed"
  value       = var.namespace
}

output "release_name" {
  description = "Helm release name"
  value       = helm_release.keycloak.name
}

output "service_name" {
  description = "Keycloak service name"
  value       = "${var.release_name}"
}

output "admin_user" {
  description = "Keycloak admin username"
  value       = var.admin_user
  sensitive   = true
}

output "admin_password" {
  description = "Keycloak admin password"
  value       = var.admin_password
  sensitive   = true
}

output "http_url" {
  description = "Keycloak HTTP URL"
  value       = "http://${var.release_name}.${var.namespace}.svc.cluster.local:${var.http_port}"
}

output "https_url" {
  description = "Keycloak HTTPS URL"
  value       = "https://${var.release_name}.${var.namespace}.svc.cluster.local:${var.https_port}"
}

output "external_url" {
  description = "Keycloak external URL"
  value       = var.ingress_enabled ? (var.ingress_tls ? "https://${var.ingress_hostname}" : "http://${var.ingress_hostname}") : null
}
