# ============================================================================
# MLflow Module - Variables
# 命名规范: ${var.environment}-${var.naming_prefix}-mlflow-${resource_type}
# ============================================================================

variable "environment" {
  description = "Environment name (dev/stage/prod)"
  type        = string
  default     = "prod"
}

variable "naming_prefix" {
  description = "Naming prefix for resources"
  type        = string
  default     = "cloud-native"
}

variable "namespace" {
  description = "Namespace for MLflow deployment"
  type        = string
  default     = "mlflow"
}

variable "mlflow_version" {
  description = "MLflow image version"
  type        = string
  default     = "2.18.0"
}

# MLflow服务器副本数
variable "mlflow_replicas" {
  description = "Number of MLflow server replicas"
  type        = number
  default     = 2
}

variable "service_type" {
  description = "Service type for MLflow"
  type        = string
  default     = "ClusterIP"
}

# 镜像拉取策略
variable "image_pull_policy" {
  description = "Image pull policy"
  type        = string
  default     = "IfNotPresent"
}

variable "backend_store_type" {
  description = "Backend store type (postgresql, mysql, sqlite)"
  type        = string
  default     = "postgresql"
}

variable "default_artifact_root" {
  description = "Default artifact root"
  type        = string
  default     = "s3://mlflow-artifacts"
}

# 制品根目录路�?variable "artifact_root_path" {
  description = "Artifact root path for MLflow model registry"
  type        = string
  default     = "/artifacts"
}

# 内部PostgreSQL配置
variable "enable_internal_postgres" {
  description = "Whether to deploy internal PostgreSQL database (set to false to use external database)"
  type        = bool
  default     = true
}

# PostgreSQL用户
variable "postgres_user" {
  description = "PostgreSQL username"
  type        = string
  default     = "mlflow"
}

# PostgreSQL密码
variable "postgres_password" {
  description = "PostgreSQL password"
  type        = string
  sensitive   = true
  default     = "mlflow-password"
}

# PostgreSQL数据库名�?variable "postgres_db" {
  description = "PostgreSQL database name"
  type        = string
  default     = "mlflow"
}

# PostgreSQL副本�?variable "postgres_replicas" {
  description = "Number of PostgreSQL replicas"
  type        = number
  default     = 1
}

# PostgreSQL存储大小
variable "postgres_storage_size" {
  description = "Storage size for PostgreSQL persistent volume"
  type        = string
  default     = "10Gi"
}

# PostgreSQL服务类型
variable "postgres_service_type" {
  description = "PostgreSQL service type (ClusterIP, NodePort, LoadBalancer)"
  type        = string
  default     = "ClusterIP"
}

# PostgreSQL镜像仓库
variable "postgres_image_repository" {
  description = "PostgreSQL image repository address"
  type        = string
  default     "postgres"
}

# PostgreSQL镜像标签
variable "postgres_image_tag" {
  description = "PostgreSQL image tag"
  type        = string
  default     = "17-alpine"
}

# PostgreSQL存储�?variable "postgres_storage_class" {
  description = "Storage class for PostgreSQL PVC"
  type        = string
  default     = ""  # Using cluster default storage class
}

# 制品存储�?variable "artifact_storage_class" {
  description = "Storage class for MLflow artifacts PVC"
  type        = string
  default     = ""  # Using cluster default storage class
}

# 制品存储大小
variable "artifact_storage_size" {
  description = "Storage size for artifacts persistent volume"
  type        = string
  default     = "50Gi"
}

# 高级数据库配�?variable "use_advanced_db_config" {
  description = "Whether to use advanced database configuration (for external database)"
  type        = bool
  default     = false
}

# 数据库主机名
variable "db_hostname" {
  description = "Database hostname (for external database)"
  type        = string
  default     = "mlflow-postgres"
}

# 数据库端�?variable "db_port" {
  description = "Database port (for external database)"
  type        = string
  default     = "5432"
}

# 数据库用户名
variable "db_username" {
  description = "Database username (for external database)"
  type        = string
  default     = "mlflow"
}

# 数据库密�?variable "db_password" {
  description = "Database password (for external database)"
  type        = string
  sensitive   = true
  default     = "mlflow-password"
}

# 数据库名�?variable "db_name" {
  description = "Database name (for external database)"
  type        = string
  default     = "mlflow"
}

# PostgreSQL CPU请求
variable "postgres_cpu_request" {
  description = "PostgreSQL CPU request"
  type        = string
  default = '2000m'
}

# PostgreSQL内存请求
variable "postgres_memory_request" {
  description = "PostgreSQL memory request"
  type        = string
  default = '2Gi'
}

# PostgreSQL CPU限制
variable "postgres_cpu_limit" {
  description = "PostgreSQL CPU limit"
  type        = string
  default = '4000m'
}

# PostgreSQL内存限制
variable "postgres_memory_limit" {
  description = "PostgreSQL memory limit"
  type        = string
  default = '4Gi'
}

# MLflow服务器CPU请求
variable "mlflow_server_cpu_request" {
  description = "MLflow Server CPU request"
  type        = string
  default = '4000m'
}

# MLflow服务器内存请�?variable "mlflow_server_memory_request" {
  description = "MLflow Server memory request"
  type        = string
  default = '4Gi'
}

# MLflow服务器CPU限制
variable "mlflow_server_cpu_limit" {
  description = "MLflow Server CPU limit"
  type        = string
  default = '8000m'
}

# MLflow服务器内存限�?variable "mlflow_server_memory_limit" {
  description = "MLflow Server memory limit"
  type        = string
  default = '8Gi'
}

variable "storage_size" {
  description = "Size of MLflow storage"
  type        = string
  default     = "50Gi"
}

variable "storage_class" {
  description = "Storage class for MLflow"
  type        = string
  default     = "ceph-rbd"
}

# 是否使用持久化存�?variable "use_persistent_storage" {
  description = "Whether to use persistent storage (PVCs) or ephemeral storage (emptyDir)"
  type        = bool
  default     = true
}

# 模型注册服务配置
variable "enable_model_registry" {
  description = "Enable MLflow model registry component"
  type        = bool
  default     = false
}

# 模型注册服务副本�?variable "model_registry_replicas" {
  description = "Number of model registry replicas"
  type        = number
  default     = 1
}

# 模型注册服务类型
variable "model_registry_service_type" {
  description = "Model registry service type (ClusterIP, NodePort, LoadBalancer)"
  type        = string
  default     = "ClusterIP"
}

# 模型注册服务CPU请求
variable "model_registry_cpu_request" {
  description = "Model registry CPU request"
  type        = string
  default = '2000m'
}

# 模型注册服务内存请求
variable "model_registry_memory_request" {
  description = "Model registry memory request"
  type        = string
  default = '2Gi'
}

# 模型注册服务CPU限制
variable "model_registry_cpu_limit" {
  description = "Model registry CPU limit"
  type        = string
  default = '4000m'
}

# 模型注册服务内存限制
variable "model_registry_memory_limit" {
  description = "Model registry memory limit"
  type        = string
  default = '4Gi'
}

variable "domain_name" {
  description = "MLflow domain name"
  type        = string
  default     = "mlflow.example.com"
}

variable "enable_tracking" {
  description = "Enable MLflow tracking"
  type        = bool
  default     = true
}

variable "enable_models" {
  description = "Enable MLflow models"
  type        = bool
  default     = true
}

variable "enable_projects" {
  description = "Enable MLflow projects"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Standard tags to apply to all resources"
  type        = map(string)
  default = {
    Environment  = "prod"
    CostCenter   = "12345"
    Security     = "cloud-native"
  }
}

