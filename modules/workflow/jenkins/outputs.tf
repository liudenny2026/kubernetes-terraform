# ============================================================================
# Jenkins Workflow Module - Outputs
# ============================================================================

output "jenkins_namespace" {
  description = "Namespace where Jenkins is deployed"
  value       = kubernetes_namespace.jenkins.metadata[0].name
}

output "jenkins_release_name" {
  description = "Name of the Jenkins Helm release"
  value       = helm_release.jenkins.name
}

output "jenkins_service_name" {
  description = "Name of the Jenkins service"
  value       = "${helm_release.jenkins.name}-jenkins"
}

output "jenkins_pvc_name" {
  description = "Name of the Jenkins persistent volume claim"
  value       = kubernetes_persistent_volume_claim.jenkins_data.metadata[0].name
}

output "jenkins_url" {
  description = "URL for accessing Jenkins"
  value       = "http://${helm_release.jenkins.name}-jenkins.${kubernetes_namespace.jenkins.metadata[0].name}.svc:${var.service_port}"
}
