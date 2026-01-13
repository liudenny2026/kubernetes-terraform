output "namespace" {
  description = "Monitoring namespace"
  value       = module.prometheus_monitoring.namespace
}

output "grafana_url" {
  description = "Grafana URL"
  value       = module.prometheus_monitoring.grafana_url
}

output "grafana_username" {
  description = "Grafana admin username"
  value       = module.prometheus_monitoring.grafana_username
}

output "grafana_password" {
  description = "Grafana admin password"
  sensitive   = true
  value       = module.prometheus_monitoring.grafana_password
}

output "prometheus_url" {
  description = "Prometheus URL"
  value       = module.prometheus_monitoring.prometheus_url
}

output "alertmanager_url" {
  description = "Alertmanager URL"
  value       = module.prometheus_monitoring.alertmanager_url
}
