output "jaeger_namespace" {
  description = "Jaeger namespace"
  value       = kubernetes_namespace.jaeger.metadata[0].name
}

output "jaeger_helm_release_name" {
  description = "Jaeger Helm release name"
  value       = helm_release.jaeger.name
}

output "jaeger_helm_release_status" {
  description = "Jaeger Helm release status"
  value       = helm_release.jaeger.status
}