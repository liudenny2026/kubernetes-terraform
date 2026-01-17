# ============================================================================
# Aqua Security Module - Variables
# 三级架构: 资源�?- Security Variables
# 命名规范: ${var.environment}-${var.naming_prefix}-security-aqua-{resource-type}
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
  description = "Namespace for Aqua Security deployment"
  type        = string
  default     = "aqua-security"
}

# 镜像配置
variable "aqua_image_repository" {
  description = "Aqua Security base image repository"
  type        = string
  default     = "aquasec/agent"
}

variable "aqua_image_tag" {
  description = "Aqua Security image tag"
  type        = string
  default     = "latest"
}

variable "aqua_server_image_repository" {
  description = "Aqua Security server image repository"
  type        = string
  default     = "aquasec/server"
}

variable "aqua_gateway_image_repository" {
  description = "Aqua Security gateway image repository"
  type        = string
  default     = "aquasec/gateway"
}

variable "aqua_database_image_repository" {
  description = "Aqua Security database image repository"
  type        = string
  default     = "aquasec/database"
}

variable "aqua_database_image_tag" {
  description = "Aqua Security database image tag"
  type        = string
  default     = "latest"
}

variable "image_pull_policy" {
  description = "Image pull policy"
  type        = string
  default     = "IfNotPresent"
}

# Helm配置
variable "aqua_repository" {
  description = "Helm repository for Aqua Security"
  type        = string
  default     = "https://aquasecurity.github.io/helm-charts/"
}

variable "aqua_chart_name" {
  description = "Helm chart name for Aqua Security"
  type        = string
  default     = "aqua"
}

variable "aqua_chart_version" {
  description = "Helm chart version for Aqua Security"
  type        = string
  default     = "7.0.0"
}

# 服务配置
variable "service_type" {
  description = "Service type for Aqua server (ClusterIP, NodePort, LoadBalancer)"
  type        = string
  default     = "LoadBalancer"
}

variable "service_port" {
  description = "Service port for Aqua server"
  type        = number
  default     = 8080
}

variable "gateway_service_type" {
  description = "Service type for Aqua gateway (ClusterIP, NodePort, LoadBalancer)"
  type        = string
  default     = "LoadBalancer"
}

variable "gateway_service_port" {
  description = "Service port for Aqua gateway"
  type        = number
  default     = 3622
}

# 存储配置
variable "storage_size" {
  description = "Storage size for Aqua database"
  type        = string
  default     = "50Gi"
}

variable "storage_class" {
  description = "Storage class for Aqua database"
  type        = string
  default     = "local-path"
}

# 资源请求和限�?variable "resources_requests_cpu" {
  description = "CPU requests for Aqua Security pods"
  type        = string
  default     = "500m"
}

variable "resources_requests_memory" {
  description = "Memory requests for Aqua Security pods"
  type        = string
  default     = "1Gi"
}

variable "resources_limits_cpu" {
  description = "CPU limits for Aqua Security pods"
  type        = string
  default     = "1000m"
}

variable "resources_limits_memory" {
  description = "Memory limits for Aqua Security pods"
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
