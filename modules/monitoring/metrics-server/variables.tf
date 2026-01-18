# ============================================================================
# Metrics Server Module - Variables
# 三级架构: 资源�?- Metrics Variables
# 命名规范: ${var.environment}-${var.naming_prefix}-infra-metrics-{resource-type}
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
  description = "Namespace for Metrics Server deployment"
  type        = string
  default     = "kube-system"
}

# 镜像配置
variable "image_repository" {
  description = "Metrics Server image repository"
  type        = string
  default     = "registry.k8s.io/metrics-server/metrics-server"
}

variable "image_tag" {
  description = "Metrics Server image tag"
  type        = string
  default     = "v0.7.2"
}

variable "image_pull_policy" {
  description = "Image pull policy"
  type        = string
  default     = "IfNotPresent"
}

# Helm配置
variable "repository" {
  description = "Helm repository URL"
  type        = string
  default     = "https://kubernetes-sigs.github.io/metrics-server"
}

variable "chart" {
  description = "Helm chart name"
  type        = string
  default     = "metrics-server"
}

variable "chart_version" {
  description = "Helm chart version"
  type        = string
  default     = "3.12.3"
}

# 资源请求和限�?variable "resources_requests_cpu" {
  description = "CPU requests for Metrics Server pods"
  type        = string
  default     = "100m"
}

variable "resources_requests_memory" {
  description = "Memory requests for Metrics Server pods"
  type        = string
  default     = "200Mi"
}

variable "resources_limits_cpu" {
  description = "CPU limits for Metrics Server pods"
  type        = string
  default     = "200m"
}

variable "resources_limits_memory" {
  description = "Memory limits for Metrics Server pods"
  type        = string
  default     = "400Mi"
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
