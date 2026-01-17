# ============================================================================
# Kube-bench Security Module - Variables
# 三级架构: 资源�?- Security Variables
# 命名规范: ${var.environment}-${var.naming_prefix}-security-kube-bench-{resource-type}
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
  description = "Namespace for Kube-bench deployment"
  type        = string
  default     = "security"
}

# 镜像配置
variable "image_repository" {
  description = "Kube-bench image repository"
  type        = string
  default     = "aquasec/kube-bench"
}

variable "image_tag" {
  description = "Kube-bench image tag"
  type        = string
  default     = "latest"
}

# 资源请求和限�?variable "resources_requests_cpu" {
  description = "CPU requests for Kube-bench pods"
  type        = string
  default     = "250m"
}

variable "resources_requests_memory" {
  description = "Memory requests for Kube-bench pods"
  type        = string
  default     = "512Mi"
}

variable "resources_limits_cpu" {
  description = "CPU limits for Kube-bench pods"
  type        = string
  default     = "500m"
}

variable "resources_limits_memory" {
  description = "Memory limits for Kube-bench pods"
  type        = string
  default     = "1Gi"
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
