# MLflow Unified Module Outputs

output "service_url" {
  description = "MLflow service URL"
  value = var.service_type == "LoadBalancer" ? (
    length(kubernetes_service_v1.mlflow_server.status) > 0 &&
    length(kubernetes_service_v1.mlflow_server.status[0].load_balancer) > 0 &&
    length(kubernetes_service_v1.mlflow_server.status[0].load_balancer[0].ingress) > 0 &&
    length(kubernetes_service_v1.mlflow_server.status[0].load_balancer[0].ingress[0].ip) > 0 ?
    "http://${kubernetes_service_v1.mlflow_server.status[0].load_balancer[0].ingress[0].ip}:5000" :
    "LoadBalancer IP not yet assigned - use 'kubectl get svc -n ${var.mlflow_namespace} mlflow-server' to check status"
  ) : "http://${kubernetes_service_v1.mlflow_server.metadata[0].name}.${var.mlflow_namespace}.svc.cluster.local:5000"
}

output "namespace" {
  description = "MLflow namespace"
  value       = var.mlflow_namespace
}

output "postgres_service" {
  description = "PostgreSQL service address"
  value       = var.enable_internal_postgres ? "${kubernetes_service_v1.mlflow_postgres[0].metadata[0].name}.${var.mlflow_namespace}.svc.cluster.local:5432" : "Using external database"
}

output "mlflow_version" {
  description = "MLflow version"
  value       = var.mlflow_version
}

output "mlflow_image" {
  description = "MLflow image"
  value       = "${var.mlflow_image_repository}:${var.mlflow_version}"
}

output "postgres_image" {
  description = "PostgreSQL image"
  value       = var.enable_internal_postgres ? "${var.postgres_image_repository}:${var.postgres_image_tag}" : "Using external database"
}

output "port_forward_command" {
  description = "MLflow port forward command"
  value       = "kubectl port-forward -n ${var.mlflow_namespace} svc/mlflow-server 5000:5000"
}

output "database_connection_string" {
  description = "Database connection string"
  value       = "postgresql://${local.db_username}:****@${local.db_hostname}:${local.db_port}/${local.db_name}"
  sensitive   = true
}

# Advanced features outputs
output "model_registry_service_url" {
  description = "MLflow model registry service URL"
  value       = var.enable_model_registry ? (
    var.model_registry_service_type == "LoadBalancer" ? (
      length(kubernetes_service_v1.mlflow_model_registry[0].status) > 0 &&
      length(kubernetes_service_v1.mlflow_model_registry[0].status[0].load_balancer) > 0 &&
      length(kubernetes_service_v1.mlflow_model_registry[0].status[0].load_balancer[0].ingress) > 0 &&
      length(kubernetes_service_v1.mlflow_model_registry[0].status[0].load_balancer[0].ingress[0].ip) > 0 ?
      "http://${kubernetes_service_v1.mlflow_model_registry[0].status[0].load_balancer[0].ingress[0].ip}:5000" :
      "LoadBalancer IP not yet assigned - use 'kubectl get svc -n ${var.mlflow_namespace} mlflow-model-registry' to check status"
    ) : "http://${kubernetes_service_v1.mlflow_model_registry[0].metadata[0].name}.${var.mlflow_namespace}.svc.cluster.local:5000"
  ) : null
  depends_on = [kubernetes_service_v1.mlflow_model_registry]
}

output "model_registry_namespace" {
  description = "Model registry namespace"
  value       = var.enable_model_registry ? var.mlflow_namespace : null
}

output "kubeflow_integration_service" {
  description = "Kubeflow integration service address"
  value       = var.enable_kubeflow_integration ? "${kubernetes_service_v1.mlflow_kubeflow_integration[0].metadata[0].name}.${var.mlflow_namespace}.svc.cluster.local:8888" : null
  depends_on  = [kubernetes_service_v1.mlflow_kubeflow_integration]
}