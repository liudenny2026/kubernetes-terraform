module "mlflow" {
  source = "../../modules/mlflow"

  count = var.mlflow_enabled ? 1 : 0

  # Basic configuration
  mlflow_namespace = var.mlflow_namespace
  mlflow_replicas  = var.mlflow_replicas
  service_type     = var.service_type

  # Database configuration
  postgres_user     = var.postgres_user
  postgres_password = var.postgres_password
  postgres_db       = var.postgres_db
  postgres_replicas = var.postgres_replicas
  postgres_storage_size = var.postgres_storage_size
  postgres_service_type = var.postgres_service_type

  # Resource configuration
  postgres_cpu_request    = var.postgres_cpu_request
  postgres_memory_request = var.postgres_memory_request
  postgres_cpu_limit      = var.postgres_cpu_limit
  postgres_memory_limit   = var.postgres_memory_limit

  mlflow_server_cpu_request    = var.mlflow_server_cpu_request
  mlflow_server_memory_request = var.mlflow_server_memory_request
  mlflow_server_cpu_limit      = var.mlflow_server_cpu_limit
  mlflow_server_memory_limit   = var.mlflow_server_memory_limit

  # Version configuration
  mlflow_version              = var.mlflow_version
  mlflow_image_repository     = var.mlflow_image_repository
  postgres_image_repository   = var.postgres_image_repository
  postgres_image_tag          = var.postgres_image_tag

  # Storage class configuration
  postgres_storage_class            = var.postgres_storage_class
  artifact_storage_class          = var.artifact_storage_class
  use_persistent_storage          = var.use_persistent_storage

  # Advanced features configuration
  enable_model_registry             = var.enable_model_registry
  model_registry_replicas           = var.model_registry_replicas
  model_registry_service_type       = var.model_registry_service_type
  model_registry_cpu_request        = var.model_registry_cpu_request
  model_registry_memory_request     = var.model_registry_memory_request
  model_registry_cpu_limit          = var.model_registry_cpu_limit
  model_registry_memory_limit       = var.model_registry_memory_limit
  artifact_storage_size             = var.artifact_storage_size
  artifact_root_path                = var.artifact_root_path
  default_artifact_root             = var.default_artifact_root

  enable_kubeflow_integration       = var.enable_kubeflow_integration
  kubeflow_integration_service_type = var.kubeflow_integration_service_type
}