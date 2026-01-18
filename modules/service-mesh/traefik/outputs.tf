output "traefik_namespace" {
  description = "Traefik namespace"
  value       = kubernetes_namespace.traefik.metadata[0].name
}

output "traefik_helm_release_name" {
  description = "Traefik Helm release name"
  value       = helm_release.traefik.name
}

output "traefik_helm_release_status" {
  description = "Traefik Helm release status"
  value       = helm_release.traefik.status
}

output "traefik_service_type" {
  description = "Traefik service type"
  value       = var.service_type
}