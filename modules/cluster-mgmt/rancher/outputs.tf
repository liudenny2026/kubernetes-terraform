output "rancher_namespace" {
  description = "Rancher namespace"
  value       = kubernetes_namespace.rancher.metadata[0].name
}

output "rancher_helm_release_name" {
  description = "Rancher Helm release name"
  value       = helm_release.rancher.name
}

output "rancher_helm_release_status" {
  description = "Rancher Helm release status"
  value       = helm_release.rancher.status
}

output "rancher_hostname" {
  description = "Rancher server hostname"
  value       = var.hostname
  sensitive   = true
}