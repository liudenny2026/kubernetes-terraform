# ============================================================================
# Tekton Workflow Module - Variables
# 三级架构: 资源�?- Workflow Variables
# 命名规范: ${var.environment}-${var.naming_prefix}-workflow-tekton-{resource-type}
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
  description = "Namespace for Tekton deployment"
  type        = string
  default     = "tekton-pipelines"
}

# 镜像配置
variable "tekton_image_repository" {
  description = "Tekton base image repository"
  type        = string
  default     = "ghcr.io/tektoncd/pipeline/cmd/controller"
}

variable "tekton_image_tag" {
  description = "Tekton image tag"
  type        = string
  default     = "latest"
}

variable "tekton_dashboard_image_repository" {
  description = "Tekton Dashboard image repository"
  type        = string
  default     = "ghcr.io/tektoncd/dashboard/cmd/dashboard"
}

variable "tekton_dashboard_image_tag" {
  description = "Tekton Dashboard image tag"
  type        = string
  default     = "latest"
}

variable "image_pull_policy" {
  description = "Image pull policy"
  type        = string
  default     = "IfNotPresent"
}

# Helm配置
variable "tekton_repository" {
  description = "Helm repository for Tekton"
  type        = string
  default     = "https://tekton.dev/charts"
}

variable "tekton_pipelines_version" {
  description = "Helm chart version for Tekton Pipelines"
  type        = string
  default     = "0.76.0"
}

variable "tekton_dashboard_version" {
  description = "Helm chart version for Tekton Dashboard"
  type        = string
  default     = "0.53.0"
}

variable "tekton_triggers_version" {
  description = "Helm chart version for Tekton Triggers"
  type        = string
  default     = "0.41.0"
}

# 服务配置
variable "dashboard_service_type" {
  description = "Service type for Tekton Dashboard (ClusterIP, NodePort, LoadBalancer)"
  type        = string
  default     = "LoadBalancer"
}

variable "dashboard_service_port" {
  description = "Service port for Tekton Dashboard"
  type        = number
  default     = 9097
}

# 资源请求和限�?variable "resources_requests_cpu" {
  description = "CPU requests for Tekton pods"
  type        = string
  default     = "200m"
}

variable "resources_requests_memory" {
  description = "Memory requests for Tekton pods"
  type        = string
  default     = "512Mi"
}

variable "resources_limits_cpu" {
  description = "CPU limits for Tekton pods"
  type        = string
  default     = "1000m"
}

variable "resources_limits_memory" {
  description = "Memory limits for Tekton pods"
  type        = string
  default     = "2Gi"
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
