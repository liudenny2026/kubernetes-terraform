# MLflow Unified Module Variables
# This module combines basic and advanced MLflow deployment features

# Namespace configuration
variable "mlflow_namespace" {
  description = "Namespace for MLflow deployment"
  type        = string
  default     = "mlflow"
}

variable "create_namespace" {
  description = "Whether to create the namespace (set to false if using existing namespace)"
  type        = bool
  default     = true
}

# MLflow server configuration
variable "mlflow_replicas" {
  description = "Number of MLflow server replicas"
  type        = number
  default     = 1
}

variable "service_type" {
  description = "MLflow server service type (ClusterIP, NodePort, LoadBalancer)"
  type        = string
  default     = "ClusterIP"
}

# MLflow image configuration
variable "mlflow_version" {
  description = "MLflow version"
  type        = string
  default     = "3.3.2"
}

variable "mlflow_image_repository" {
  description = "MLflow image repository address"
  type        = string
  default     = "192.168.40.248/library/mlflow/mlflow"
}

# PostgreSQL configuration (for internal DB)
variable "enable_internal_postgres" {
  description = "Whether to deploy internal PostgreSQL database (set to false to use external database)"
  type        = bool
  default     = true
}

variable "postgres_user" {
  description = "PostgreSQL username"
  type        = string
  default     = "mlflow"
}

variable "postgres_password" {
  description = "PostgreSQL password"
  type        = string
  sensitive   = true
  default     = "mlflowpassword"
}

variable "postgres_db" {
  description = "PostgreSQL database name"
  type        = string
  default     = "mlflow"
}

variable "postgres_replicas" {
  description = "Number of PostgreSQL replicas"
  type        = number
  default     = 1
}

variable "postgres_storage_size" {
  description = "Storage size for PostgreSQL persistent volume"
  type        = string
  default     = "10Gi"
}

variable "postgres_service_type" {
  description = "PostgreSQL service type (ClusterIP, NodePort, LoadBalancer)"
  type        = string
  default     = "ClusterIP"
}

variable "postgres_image_repository" {
  description = "PostgreSQL image repository address"
  type        = string
  default     = "192.168.40.248/library/postgres"
}

variable "postgres_image_tag" {
  description = "PostgreSQL image tag"
  type        = string
  default     = "13-alpine"
}

# Advanced database configuration (for external DB)
variable "use_advanced_db_config" {
  description = "Whether to use advanced database configuration (for external database)"
  type        = bool
  default     = false
}

variable "db_hostname" {
  description = "Database hostname (for external database)"
  type        = string
  default     = "mlflow-postgres"
}

variable "db_port" {
  description = "Database port (for external database)"
  type        = string
  default     = "5432"
}

variable "db_username" {
  description = "Database username (for external database)"
  type        = string
  default     = "mlflow"
}

variable "db_password" {
  description = "Database password (for external database)"
  type        = string
  sensitive   = true
  default     = "mlflowpassword"
}

variable "db_name" {
  description = "Database name (for external database)"
  type        = string
  default     = "mlflow"
}

# Storage class configuration
variable "postgres_storage_class" {
  description = "Storage class for PostgreSQL PVC"
  type        = string
  default     = ""  # Using cluster default storage class
}

variable "artifact_storage_class" {
  description = "Storage class for MLflow artifacts PVC"
  type        = string
  default     = ""  # Using cluster default storage class
}

# Artifact storage configuration
variable "default_artifact_root" {
  description = "Default artifact root path for MLflow server"
  type        = string
  default     = "/mlflow/artifacts"
}

variable "artifact_root_path" {
  description = "Root path for artifact storage (for model registry)"
  type        = string
  default     = "/artifacts"
}

variable "artifact_storage_size" {
  description = "Storage size for artifacts persistent volume"
  type        = string
  default     = "20Gi"
}

# Resource allocation
# PostgreSQL resources
variable "postgres_cpu_request" {
  description = "PostgreSQL CPU request"
  type        = string
  default     = "1000m"
}

variable "postgres_memory_request" {
  description = "PostgreSQL memory request"
  type        = string
  default     = "1Gi"
}

variable "postgres_cpu_limit" {
  description = "PostgreSQL CPU limit"
  type        = string
  default     = "2000m"
}

variable "postgres_memory_limit" {
  description = "PostgreSQL memory limit"
  type        = string
  default     = "2Gi"
}

# MLflow server resources
variable "mlflow_server_cpu_request" {
  description = "MLflow Server CPU request"
  type        = string
  default     = "2000m"
}

variable "mlflow_server_memory_request" {
  description = "MLflow Server memory request"
  type        = string
  default     = "2Gi"
}

variable "mlflow_server_cpu_limit" {
  description = "MLflow Server CPU limit"
  type        = string
  default     = "4000m"
}

variable "mlflow_server_memory_limit" {
  description = "MLflow Server memory limit"
  type        = string
  default     = "4Gi"
}

# Storage configuration
variable "use_persistent_storage" {
  description = "Whether to use persistent storage (PVCs) or ephemeral storage (emptyDir)"
  type        = bool
  default     = true
}

# Model registry configuration
variable "enable_model_registry" {
  description = "Enable MLflow model registry component"
  type        = bool
  default     = false
}

variable "model_registry_replicas" {
  description = "Number of model registry replicas"
  type        = number
  default     = 1
}

variable "model_registry_service_type" {
  description = "Model registry service type (ClusterIP, NodePort, LoadBalancer)"
  type        = string
  default     = "ClusterIP"
}

# Model registry resources
variable "model_registry_cpu_request" {
  description = "Model registry CPU request"
  type        = string
  default     = "1000m"
}

variable "model_registry_memory_request" {
  description = "Model registry memory request"
  type        = string
  default     = "1Gi"
}

variable "model_registry_cpu_limit" {
  description = "Model registry CPU limit"
  type        = string
  default     = "2000m"
}

variable "model_registry_memory_limit" {
  description = "Model registry memory limit"
  type        = string
  default     = "2Gi"
}

# Kubeflow integration configuration
variable "enable_kubeflow_integration" {
  description = "Enable Kubeflow integration components"
  type        = bool
  default     = false
}

variable "kubeflow_integration_service_type" {
  description = "Kubeflow integration service type (ClusterIP, NodePort, LoadBalancer)"
  type        = string
  default     = "ClusterIP"
}