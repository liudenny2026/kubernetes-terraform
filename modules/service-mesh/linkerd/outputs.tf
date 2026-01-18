output "linkerd_namespace" {
  description = "Linkerd namespace"
  value       = kubernetes_namespace.linkerd.metadata[0].name
}

output "linkerd_helm_release_name" {
  description = "Linkerd Helm release name"
  value       = helm_release.linkerd.name
}

output "linkerd_helm_release_status" {
  description = "Linkerd Helm release status"
  value       = helm_release.linkerd.status
}