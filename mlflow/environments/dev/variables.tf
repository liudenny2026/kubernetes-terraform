# Core configuration
variable "kubeconfig_path" {
  description = "Kubernetes config file path"
  type        = string
  default     = "~/.kube/config"
}

variable "k8s_api_endpoint" {
  description = "Kubernetes API endpoint"
  type        = string
  default     = "192.168.40.241"
}

# MLflow settings
variable "mlflow_enabled" {
  description = "Whether to enable MLflow"
  type        = bool
  default     = true
}

variable "mlflow_namespace" {
  description = "Namespace for MLflow deployment"
  type        = string
  default     = "mlflow"
}

variable "mlflow_replicas" {
  description = "Number of MLflow server replicas"
  type        = number
  default     = 1
}

variable "service_type" {
  description = "Service type (ClusterIP, NodePort, LoadBalancer)"
  type        = string
  default     = "ClusterIP"
}

# Database configuration
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

# Resource allocation
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

# Enhanced database configuration
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

variable "artifact_storage_size" {
  description = "Storage size for artifacts persistent volume"
  type        = string
  default     = "20Gi"
}

variable "artifact_root_path" {
  description = "Root path for artifact storage"
  type        = string
  default     = "/artifacts"
}

variable "default_artifact_root" {
  description = "Default artifact root path for MLflow server"
  type        = string
  default     = "/mlflow/artifacts"
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

# Storage configuration
variable "use_persistent_storage" {
  description = "Whether to use persistent storage (PVCs) or ephemeral storage (emptyDir)"
  type        = bool
  default     = false  # Set to false to avoid WaitForFirstConsumer issues with local-path storage
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

# Storage class configuration
variable "postgres_storage_class" {
  description = "Storage class for PostgreSQL PVC"
  type        = string
  default     = ""
}

variable "artifact_storage_class" {
  description = "Storage class for MLflow artifacts PVC"
  type        = string
  default     = ""
}

# Image configuration
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
