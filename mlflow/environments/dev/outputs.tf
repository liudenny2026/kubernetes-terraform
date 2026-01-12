output "mlflow_service_url" {
  description = "MLflow service URL"
  value       = var.mlflow_enabled ? module.mlflow[0].service_url : "MLflow not enabled"
  depends_on  = [module.mlflow]
}

output "mlflow_namespace" {
  description = "MLflow namespace"
  value       = var.mlflow_enabled ? module.mlflow[0].namespace : "MLflow not enabled"
  depends_on  = [module.mlflow]
}

output "postgres_service" {
  description = "PostgreSQL service address"
  value       = var.mlflow_enabled ? module.mlflow[0].postgres_service : "MLflow not enabled"
  depends_on  = [module.mlflow]
}

output "mlflow_version" {
  description = "MLflow version"
  value       = var.mlflow_enabled ? module.mlflow[0].mlflow_version : "MLflow not enabled"
  depends_on  = [module.mlflow]
}

output "mlflow_image" {
  description = "MLflow image"
  value       = var.mlflow_enabled ? module.mlflow[0].mlflow_image : "MLflow not enabled"
  depends_on  = [module.mlflow]
}

output "postgres_image" {
  description = "PostgreSQL image"
  value       = var.mlflow_enabled ? module.mlflow[0].postgres_image : "MLflow not enabled"
  depends_on  = [module.mlflow]
}

output "port_forward_command" {
  description = "MLflow port forward command"
  value       = var.mlflow_enabled ? module.mlflow[0].port_forward_command : "MLflow not enabled"
  depends_on  = [module.mlflow]
}

output "database_connection_string" {
  description = "Database connection string"
  value       = var.mlflow_enabled ? module.mlflow[0].database_connection_string : "MLflow not enabled"
  sensitive   = true
  depends_on  = [module.mlflow]
}

output "model_registry_service_url" {
  description = "MLflow model registry service URL"
  value       = var.mlflow_enabled && var.enable_model_registry ? module.mlflow[0].model_registry_service_url : "Model registry not enabled"
  depends_on  = [module.mlflow]
}

output "model_registry_namespace" {
  description = "Model registry namespace"
  value       = var.mlflow_enabled && var.enable_model_registry ? module.mlflow[0].model_registry_namespace : "Model registry not enabled"
  depends_on  = [module.mlflow]
}

output "kubeflow_integration_service" {
  description = "Kubeflow integration service address"
  value       = var.mlflow_enabled && var.enable_kubeflow_integration ? module.mlflow[0].kubeflow_integration_service : "Kubeflow integration not enabled"
  depends_on  = [module.mlflow]
}

output "deployment_summary" {
  description = "Deployment Summary"
  value = {
    k8s_api_endpoint = var.k8s_api_endpoint
    mlflow_enabled   = var.mlflow_enabled
    mlflow_namespace = var.mlflow_namespace
    model_registry_enabled = var.enable_model_registry
    kubeflow_integration_enabled = var.enable_kubeflow_integration
  }
}