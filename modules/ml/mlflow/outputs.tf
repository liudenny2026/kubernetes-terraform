# ============================================================================
# MLflow Module - Outputs
# ============================================================================

output "mlflow_namespace" {
  description = "MLflow namespace"
  value       = kubernetes_namespace.mlflow.metadata[0].name
}

output "mlflow_deployment_name" {
  description = "MLflow deployment name"
  value       = kubernetes_deployment.mlflow.metadata[0].name
}

output "mlflow_service_name" {
  description = "MLflow service name"
  value       = kubernetes_service.mlflow.metadata[0].name
}

output "mlflow_url" {
  description = "MLflow URL"
  value       = "http://${var.domain_name}"
}

output "mlflow_tracking_uri" {
  description = "MLflow tracking URI"
  value       = "${kubernetes_service.mlflow.metadata[0].name}.${var.namespace}.svc"
}

output "mlflow_pvc_name" {
  description = "MLflow PVC name"
  value       = kubernetes_persistent_volume_claim.mlflow.metadata[0].name
}

output "mlflow_version" {
  description = "MLflow version"
  value       = var.mlflow_version
}
