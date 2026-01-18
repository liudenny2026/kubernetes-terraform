output "jenkins_x_namespace" {
  description = "Jenkins X namespace"
  value       = kubernetes_namespace.jenkins_x.metadata[0].name
}

output "jenkins_x_helm_release_name" {
  description = "Jenkins X Helm release name"
  value       = helm_release.jenkins_x.name
}

output "jenkins_x_helm_release_status" {
  description = "Jenkins X Helm release status"
  value       = helm_release.jenkins_x.status
}

output "jenkins_x_domain" {
  description = "Jenkins X domain"
  value       = var.domain
}