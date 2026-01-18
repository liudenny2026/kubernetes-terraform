output "longhorn_namespace" {
  description = "Longhorn namespace"
  value       = kubernetes_namespace.longhorn.metadata[0].name
}

output "longhorn_helm_release_name" {
  description = "Longhorn Helm release name"
  value       = helm_release.longhorn.name
}

output "longhorn_helm_release_status" {
  description = "Longhorn Helm release status"
  value       = helm_release.longhorn.status
}

output "longhorn_storage_class" {
  description = "Longhorn default storage class"
  value       = var.storage_class
}