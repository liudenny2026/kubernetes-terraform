# ============================================================================
# Flux Workflow Module - Variables
# 三级架构: 资源�?- Workflow Variables
# 命名规范: ${var.environment}-${var.naming_prefix}-workflow-flux-{resource-type}
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
  description = "Namespace for Flux CD deployment"
  type        = string
  default     = "flux-system"
}

# 镜像配置
variable "flux_image_repository" {
  description = "Flux CD base image repository"
  type        = string
  default     = "ghcr.io/fluxcd/flux-cli"
}

variable "flux_image_tag" {
  description = "Flux CD image tag"
  type        = string
  default     = "latest"
}

variable "source_controller_image_repository" {
  description = "Flux Source Controller image repository"
  type        = string
  default     = "ghcr.io/fluxcd/source-controller"
}

variable "kustomize_controller_image_repository" {
  description = "Flux Kustomize Controller image repository"
  type        = string
  default     = "ghcr.io/fluxcd/kustomize-controller"
}

variable "helm_controller_image_repository" {
  description = "Flux Helm Controller image repository"
  type        = string
  default     = "ghcr.io/fluxcd/helm-controller"
}

variable "notification_controller_image_repository" {
  description = "Flux Notification Controller image repository"
  type        = string
  default     = "ghcr.io/fluxcd/notification-controller"
}

variable "image_pull_policy" {
  description = "Image pull policy"
  type        = string
  default     = "IfNotPresent"
}

# Helm配置
variable "flux_repository" {
  description = "Helm repository for Flux CD"
  type        = string
  default     = "https://fluxcd-community.github.io/helm-charts"
}

variable "flux_chart_name" {
  description = "Helm chart name for Flux CD"
  type        = string
  default     = "flux"
}

variable "flux_chart_version" {
  description = "Helm chart version for Flux CD"
  type        = string
  default     = "2.18.0"
}

# 资源请求和限�?variable "resources_requests_cpu" {
  description = "CPU requests for Flux pods"
  type        = string
  default     = "100m"
}

variable "resources_requests_memory" {
  description = "Memory requests for Flux pods"
  type        = string
  default     = "128Mi"
}

variable "resources_limits_cpu" {
  description = "CPU limits for Flux pods"
  type        = string
  default     = "500m"
}

variable "resources_limits_memory" {
  description = "Memory limits for Flux pods"
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
