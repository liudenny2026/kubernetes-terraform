# ============================================================================
# Kubeflow Module - Outputs
# ============================================================================

output "kubeflow_namespace" {
  description = "Kubeflow namespace"
  value       = kubernetes_namespace.kubeflow.metadata[0].name
}

output "kubeflow_pipelines_deployment_name" {
  description = "Kubeflow pipelines deployment name"
  value       = contains(var.custom_components, "pipelines") ? kubernetes_deployment.kubeflow_pipelines[0].metadata[0].name : ""
}

output "jupyter_notebook_deployment_name" {
  description = "Jupyter notebook deployment name"
  value       = contains(var.custom_components, "notebooks") ? kubernetes_deployment.jupyter_notebook[0].metadata[0].name : ""
}

output "kubeflow_pipelines_service_name" {
  description = "Kubeflow pipelines service name"
  value       = kubernetes_service.kubeflow_pipelines.metadata[0].name
}

output "jupyter_notebook_service_name" {
  description = "Jupyter notebook service name"
  value       = kubernetes_service.jupyter_notebook.metadata[0].name
}

output "kubeflow_url" {
  description = "Kubeflow URL"
  value       = "http://${var.domain_name}"
}

output "kubeflow_pvc_name" {
  description = "Kubeflow PVC name"
  value       = kubernetes_persistent_volume_claim.kubeflow.metadata[0].name
}
