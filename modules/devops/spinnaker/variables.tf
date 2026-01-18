# ============================================================================
# Spinnaker Workflow Module - Variables
# 三级架构: 资源�?- Workflow Variables
# 命名规范: ${var.environment}-${var.naming_prefix}-workflow-spinnaker-{resource-type}
# ============================================================================

# 环境标识
variable "environment" {
  description = "Environment name (dev/stage/prod)"
  type        = string
  default     = "dev"
}

# 组件前缀
variable "naming_prefix" {
  description = "Naming prefix for resources"
  type        = string
  default     = "cloud-native"
}

# 命名空间
variable "namespace" {
  description = "Namespace for Spinnaker deployment"
  type        = string
  default     = "spinnaker"
}

# 镜像配置
variable "halyard_image_repository" {
  description = "Halyard image repository"
  type        = string
  default     = "armory/halyard"
}

variable "halyard_image_tag" {
  description = "Halyard image tag"
  type        = string
  default     = "latest"
}

variable "image_pull_policy" {
  description = "Image pull policy"
  type        = string
  default     = "IfNotPresent"
}

# Helm配置
variable "spinnaker_repository" {
  description = "Helm repository for Spinnaker"
  type        = string
  default     = "https://charts.armory.io"
}

variable "spinnaker_chart_name" {
  description = "Helm chart name for Spinnaker"
  type        = string
  default     = "spinnaker"
}

variable "spinnaker_chart_version" {
  description = "Helm chart version for Spinnaker"
  type        = string
  default     = "2.28.0"
}

# 服务配置
variable "deck_service_type" {
  description = "Service type for Spinnaker Deck (UI) (ClusterIP, NodePort, LoadBalancer)"
  type        = string
  default     = "LoadBalancer"
}

variable "deck_service_port" {
  description = "Service port for Spinnaker Deck (UI)"
  type        = number
  default     = 80
}

variable "gate_service_type" {
  description = "Service type for Spinnaker Gate (API) (ClusterIP, NodePort, LoadBalancer)"
  type        = string
  default     = "LoadBalancer"
}

variable "gate_service_port" {
  description = "Service port for Spinnaker Gate (API)"
  type        = number
  default     = 8084
}

# 存储配置
variable "storage_size" {
  description = "Storage size for Spinnaker persistent storage"
  type        = string
  default     = "50Gi"
}

variable "storage_class" {
  description = "Storage class for Spinnaker persistent storage"
  type        = string
  default     = "local-path"
}

# 资源请求和限�?variable "resources_requests_cpu" {
  description = "CPU requests for Spinnaker pods"
  type        = string
  default     = "1000m"
}

variable "resources_requests_memory" {
  description = "Memory requests for Spinnaker pods"
  type        = string
  default     = "2Gi"
}

variable "resources_limits_cpu" {
  description = "CPU limits for Spinnaker pods"
  type        = string
  default     = "2000m"
}

variable "resources_limits_memory" {
  description = "Memory limits for Spinnaker pods"
  type        = string
  default     = "4Gi"
}

# 安全标签
variable "tags" {
  description = "Standard tags to apply to all resources"
  type        = map(string)
  default = {
    Environment  = "dev"
    CostCenter   = "12345"
    Security     = "cloud-native"
    ManagedBy    = "terraform"
    Project      = "cloud-native-infrastructure"
  }
}
