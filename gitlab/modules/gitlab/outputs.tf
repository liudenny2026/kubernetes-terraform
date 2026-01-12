output "gitlab_namespace" {
  description = "Namespace where GitLab is deployed"
  value       = var.namespace
}

output "gitlab_service_name" {
  description = "Name of the GitLab service"
  value       = kubernetes_service_v1.gitlab.metadata[0].name
}

output "gitlab_service_type" {
  description = "Type of the GitLab service"
  value       = var.service_type
}

output "gitlab_external_ip" {
  description = "External IP of the GitLab service (if LoadBalancer)"
  value       = var.service_type == "LoadBalancer" ? (length(kubernetes_service_v1.gitlab.status) > 0 ? join(",", flatten([for ingress in kubernetes_service_v1.gitlab.status[0].load_balancer.0.ingress[*] : [ingress.ip, ingress.hostname]])) : null) : null
  depends_on  = [kubernetes_service_v1.gitlab]
}

output "gitlab_pvc_name" {
  description = "Name of the GitLab persistent volume claim"
  value       = kubernetes_persistent_volume_claim_v1.gitlab.metadata[0].name
}

output "gitlab_storage_class" {
  description = "Storage class used for GitLab PVC"
  value       = var.storage_class
}

output "gitlab_version_deployed" {
  description = "Version of GitLab deployed"
  value       = var.gitlab_version
}