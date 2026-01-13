output "namespace" {
  description = "ArgoCD namespace"
  value       = kubernetes_namespace_v1.argocd.metadata[0].name
}

output "server_url" {
  description = "ArgoCD server URL"
  value       = "https://argocd-server.${kubernetes_namespace_v1.argocd.metadata[0].name}.svc.cluster.local"
}

output "helm_release_name" {
  description = "Helm release name"
  value       = "argocd"
}

output "helm_chart_version" {
  description = "Helm chart version"
  value       = var.chart_version
}