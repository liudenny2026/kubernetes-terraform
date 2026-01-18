output "loki_namespace" {
  description = "Loki namespace"
  value       = kubernetes_namespace.loki.metadata[0].name
}

output "loki_helm_release_name" {
  description = "Loki Helm release name"
  value       = helm_release.loki.name
}

output "loki_helm_release_status" {
  description = "Loki Helm release status"
  value       = helm_release.loki.status
}