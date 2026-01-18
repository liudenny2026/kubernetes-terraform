# ============================================================================
# Kubeflow Module - Variables
# 命名规范: ${var.environment}-${var.naming_prefix}-kubeflow-${resource_type}
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
  description = "Namespace for Kubeflow deployment"
  type        = string
  default     = "kubeflow"
}

variable "kubeflow_version" {
  description = "Kubeflow version"
  type        = string
  default     = "1.10.1"
}

variable "pipelines_replicas" {
  description = "Number of Kubeflow Pipelines replicas"
  type        = number
  default     = 3
}

variable "notebook_replicas" {
  description = "Number of Jupyter notebook replicas"
  type        = number
  default     = 2
}

variable "storage_size" {
  description = "Size of Kubeflow storage"
  type        = string
  default     = "100Gi"
}

variable "storage_class" {
  description = "Storage class for Kubeflow"
  type        = string
  default     = "ceph-rbd"
}

variable "kubeflow_cpu_request" {
  description = "Kubeflow CPU request"
  type        = string
  default = '1000m'
}

variable "kubeflow_memory_request" {
  description = "Kubeflow memory request"
  type        = string
  default = '4Gi'
}

variable "kubeflow_cpu_limit" {
  description = "Kubeflow CPU limit"
  type        = string
  default = '4000m'
}

variable "kubeflow_memory_limit" {
  description = "Kubeflow memory limit"
  type        = string
  default = '8Gi'
}

variable "domain_name" {
  description = "Kubeflow domain name"
  type        = string
  default     = "kubeflow.example.com"
}

variable "enable_auth" {
  description = "Enable authentication"
  type        = bool
  default     = true
}

variable "enable_monitoring" {
  description = "Enable monitoring"
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

variable "custom_components" {
  description = "Enable custom Kubeflow components"
  type        = list(string)
  default     = ["pipelines", "notebooks", "katib", "training-operator", "spark-operator", "kserve"]
}

variable "mlflow_enabled" {
  description = "Enable MLflow integration"
  type        = bool
  default     = true
}

# ---------------------------------------------------------------------------
# Spark Operator Variables
# ---------------------------------------------------------------------------
variable "spark_operator_version" {
  description = "Spark Operator version"
  type        = string
  default     = "v1beta2-1.3.7-3.1.1"
}

variable "spark_operator_replicas" {
  description = "Number of Spark Operator replicas"
  type        = number
  default     = 2
}

variable "spark_operator_cpu_request" {
  description = "Spark Operator CPU request"
  type        = string
  default = '200m'
}

variable "spark_operator_memory_request" {
  description = "Spark Operator memory request"
  type        = string
  default = '512Mi'
}

variable "spark_operator_cpu_limit" {
  description = "Spark Operator CPU limit"
  type        = string
  default = '1000m'
}

variable "spark_operator_memory_limit" {
  description = "Spark Operator memory limit"
  type        = string
  default = '1024Mi'
}

# ---------------------------------------------------------------------------
# Training Operator Variables
# ---------------------------------------------------------------------------
variable "training_operator_version" {
  description = "Training Operator version"
  type        = string
  default     = "v1.8.0"
}

variable "training_operator_replicas" {
  description = "Number of Training Operator replicas"
  type        = number
  default     = 2
}

variable "training_operator_cpu_request" {
  description = "Training Operator CPU request"
  type        = string
  default = '200m'
}

variable "training_operator_memory_request" {
  description = "Training Operator memory request"
  type        = string
  default = '512Mi'
}

variable "training_operator_cpu_limit" {
  description = "Training Operator CPU limit"
  type        = string
  default = '1000m'
}

variable "training_operator_memory_limit" {
  description = "Training Operator memory limit"
  type        = string
  default = '1024Mi'
}

# ---------------------------------------------------------------------------
# Katib Variables
# ---------------------------------------------------------------------------
variable "katib_version" {
  description = "Katib version"
  type        = string
  default     = "v0.16.0"
}

variable "katib_replicas" {
  description = "Number of Katib replicas"
  type        = number
  default     = 2
}

variable "katib_cpu_request" {
  description = "Katib CPU request"
  type        = string
  default = '200m'
}

variable "katib_memory_request" {
  description = "Katib memory request"
  type        = string
  default = '512Mi'
}

variable "katib_cpu_limit" {
  description = "Katib CPU limit"
  type        = string
  default = '1000m'
}

variable "katib_memory_limit" {
  description = "Katib memory limit"
  type        = string
  default = '1024Mi'
}

# ---------------------------------------------------------------------------
# KServe Variables
# ---------------------------------------------------------------------------
variable "kserve_version" {
  description = "KServe version"
  type        = string
  default     = "v0.13.0"
}

variable "kserve_replicas" {
  description = "Number of KServe replicas"
  type        = number
  default     = 2
}

variable "kserve_cpu_request" {
  description = "KServe CPU request"
  type        = string
  default = '200m'
}

variable "kserve_memory_request" {
  description = "KServe memory request"
  type        = string
  default = '512Mi'
}

variable "kserve_cpu_limit" {
  description = "KServe CPU limit"
  type        = string
  default = '1000m'
}

variable "kserve_memory_limit" {
  description = "KServe memory limit"
  type        = string
  default = '1024Mi'
}
