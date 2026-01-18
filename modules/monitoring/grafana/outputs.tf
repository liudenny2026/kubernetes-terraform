output "grafana_url" {
  description = "Grafana service URL"
  value       = "http://${helm_release.this.name}.${var.namespace}:${var.service_port}"
}

output "grafana_admin_username" {
  description = "Grafana admin username"
  value       = var.admin_user
  sensitive   = true
}

output "grafana_admin_password" {
  description = "Grafana admin password"
  value       = var.admin_password != "" ? var.admin_password : random_password.grafana_admin_password.result
  sensitive   = true
}

output "grafana_secret_name" {
  description = "Grafana admin credentials secret name"
  value       = kubernetes_secret.grafana_admin_secret.metadata[0].name
}

output "grafana_service_name" {
  description = "Grafana service name"
  value       = helm_release.this.name
}

output "grafana_namespace" {
  description = "Grafana namespace"
  value       = var.namespace
}

output "grafana_version" {
  description = "Grafana chart version"
  value       = helm_release.this.metadata[0].app_version
}
