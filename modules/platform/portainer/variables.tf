# ============================================================================
# Portainer Security Module - Variables
# 三级架构: 资源�?- Security Variables
# 命名规范: ${var.environment}-${var.naming_prefix}-security-portainer-{resource-type}
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
  description = "Namespace for Portainer deployment"
  type        = string
  default     = "security"
}

# 镜像配置
variable "portainer_image_repository" {
  description = "Portainer image repository"
  type        = string
  default     = "portainer/portainer-ce"
}

variable "portainer_image_tag" {
  description = "Portainer image tag"
  type        = string
  default     = "latest"
}

variable "image_pull_policy" {
  description = "Image pull policy"
  type        = string
  default     = "IfNotPresent"
}

# Helm配置
variable "portainer_repository" {
  description = "Helm repository for Portainer"
  type        = string
  default     = "https://portainer.github.io/k8s/"
}

variable "portainer_chart_name" {
  description = "Helm chart name for Portainer"
  type        = string
  default     = "portainer"
}

variable "portainer_chart_version" {
  description = "Helm chart version for Portainer"
  type        = string
  default     = "20.0.0"
}

# 服务配置
variable "service_type" {
  description = "Service type (ClusterIP, NodePort, LoadBalancer)"
  type        = string
  default     = "LoadBalancer"
}

variable "service_port" {
  description = "Service port"
  type        = number
  default     = 9000
}

# 存储配置
variable "storage_size" {
  description = "Storage size for Portainer data"
  type        = string
  default     = "10Gi"
}

variable "storage_class" {
  description = "Storage class for Portainer data"
  type        = string
  default     = "local-path"
}

# 资源请求和限�?variable "resources_requests_cpu" {
  description = "CPU requests for Portainer pods"
  type        = string
  default     = "500m"
}

variable "resources_requests_memory" {
  description = "Memory requests for Portainer pods"
  type        = string
  default     = "1Gi"
}

variable "resources_limits_cpu" {
  description = "CPU limits for Portainer pods"
  type        = string
  default     = "1000m"
}

variable "resources_limits_memory" {
  description = "Memory limits for Portainer pods"
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
