# ============================================================================
# Gatekeeper Security Module - Variables
# 三级架构: 资源�?- Security Variables
# 命名规范: ${var.environment}-${var.naming_prefix}-security-gatekeeper-{resource-type}
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
  description = "Namespace for Gatekeeper deployment"
  type        = string
  default     = "gatekeeper-system"
}

# 镜像配置
variable "gatekeeper_image_repository" {
  description = "Gatekeeper image repository"
  type        = string
  default     = "openpolicyagent/gatekeeper"
}

variable "gatekeeper_image_tag" {
  description = "Gatekeeper image tag"
  type        = string
  default     = "v3.16.0"
}

variable "image_pull_policy" {
  description = "Image pull policy"
  type        = string
  default     = "IfNotPresent"
}

# Helm配置
variable "gatekeeper_repository" {
  description = "Helm repository for Gatekeeper"
  type        = string
  default     = "https://open-policy-agent.github.io/gatekeeper/charts"
}

variable "gatekeeper_chart_name" {
  description = "Helm chart name for Gatekeeper"
  type        = string
  default     = "gatekeeper"
}

variable "gatekeeper_chart_version" {
  description = "Helm chart version for Gatekeeper"
  type        = string
  default     = "3.16.0"
}

# 部署配置
variable "controller_replicas" {
  description = "Number of controller replicas"
  type        = number
  default     = 3
}

variable "audit_replicas" {
  description = "Number of audit replicas"
  type        = number
  default     = 2
}

variable "enable_external_data" {
  description = "Enable external data feature"
  type        = bool
  default     = false
}

variable "enable_mutation" {
  description = "Enable mutation feature"
  type        = bool
  default     = true
}

# 资源请求和限�?
variable "resources_requests_cpu" {
  description = "CPU requests for Gatekeeper pods"
  type        = string
  default     = "100m"
}

variable "resources_requests_memory" {
  description = "Memory requests for Gatekeeper pods"
  type        = string
  default     = "256Mi"
}

variable "resources_limits_cpu" {
  description = "CPU limits for Gatekeeper pods"
  type        = string
  default     = "500m"
}

variable "resources_limits_memory" {
  description = "Memory limits for Gatekeeper pods"
  type        = string
  default     = "512Mi"
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
