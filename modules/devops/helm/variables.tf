# ============================================================================
# Helm Workflow Module - Variables
# 三级架构: 资源�?- Workflow Variables
# 命名规范: ${var.environment}-${var.naming_prefix}-workflow-helm-{resource-type}
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

# 镜像配置
variable "nginx_image_repository" {
  description = "Nginx example image repository"
  type        = string
  default     = "bitnami/nginx"
}

variable "nginx_image_tag" {
  description = "Nginx example image tag"
  type        = string
  default     = "latest"
}

variable "image_pull_policy" {
  description = "Image pull policy"
  type        = string
  default     = "IfNotPresent"
}

# 服务配置
variable "nginx_service_type" {
  description = "Service type for Nginx example (ClusterIP, NodePort, LoadBalancer)"
  type        = string
  default     = "ClusterIP"
}

# Helm配置
variable "nginx_chart_version" {
  description = "Helm chart version for Nginx example"
  type        = string
  default     = "15.0.0"
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
