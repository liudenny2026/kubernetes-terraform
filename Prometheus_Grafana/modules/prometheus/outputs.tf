output "namespace" {
  description = "Monitoring namespace"
  value       = kubernetes_namespace_v1.monitoring.metadata[0].name
}

output "grafana_url" {
  description = "Grafana URL"
  value       = "http://${helm_release.prometheus.status}.grafana_ip"
}

output "grafana_username" {
  description = "Grafana admin username"
  value       = "admin"
}

output "grafana_password" {
  description = "Grafana admin password"
  sensitive   = true
  value       = "prom-operator"
}

output "prometheus_url" {
  description = "Prometheus URL"
  value       = "http://${helm_release.prometheus.status}.prometheus"
}

output "alertmanager_url" {
  description = "Alertmanager URL"
  value       = "http://${helm_release.prometheus.status}.alertmanager"
}

output "kube_prometheus_stack_status" {
  description = "Status of kube-prometheus-stack release"
  value       = helm_release.prometheus.status
}
