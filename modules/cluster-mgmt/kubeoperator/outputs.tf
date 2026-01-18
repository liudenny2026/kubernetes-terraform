output "kubeoperator_namespace" {
  description = "KubeOperator namespace"
  value       = kubernetes_namespace.kubeoperator.metadata[0].name
}

output "kubeoperator_helm_release_name" {
  description = "KubeOperator Helm release name"
  value       = helm_release.kubeoperator.name
}

output "kubeoperator_helm_release_status" {
  description = "KubeOperator Helm release status"
  value       = helm_release.kubeoperator.status
}