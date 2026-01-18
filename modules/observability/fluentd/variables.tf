# ============================================================================
# Fluentd Logging Module - Variables
# 三级架构: 资源�?- Logging Variables
# 命名规范: ${var.environment}-${var.naming_prefix}-infra-fluentd-{resource-type}
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
  description = "Namespace for Fluentd deployment"
  type        = string
  default     = "logging"
}

# 镜像配置
variable "image_repository" {
  description = "Fluentd image repository"
  type        = string
  default     = "fluentd/fluentd-kubernetes-daemonset"
}

variable "image_tag" {
  description = "Fluentd image tag"
  type        = string
  default     = "v1.16.2-debian-elasticsearch8-1"
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
  default     = "https://fluent.github.io/helm-charts"
}

variable "chart" {
  description = "Helm chart name"
  type        = string
  default     = "fluentd"
}

variable "chart_version" {
  description = "Helm chart version"
  type        = string
  default     = "0.3.1"
}

# Elasticsearch配置
variable "elasticsearch_host" {
  description = "Elasticsearch host"
  type        = string
  default     = "elasticsearch-master"
}

variable "elasticsearch_port" {
  description = "Elasticsearch port"
  type        = number
  default     = 9200
}

variable "elasticsearch_scheme" {
  description = "Elasticsearch scheme (http/https)"
  type        = string
  default     = "http"
}

variable "elasticsearch_ssl_verify" {
  description = "Verify Elasticsearch SSL certificate"
  type        = bool
  default     = false
}

# 资源请求和限�?variable "resources_requests_cpu" {
  description = "CPU requests for Fluentd pods"
  type        = string
  default     = "100m"
}

variable "resources_requests_memory" {
  description = "Memory requests for Fluentd pods"
  type        = string
  default     = "256Mi"
}

variable "resources_limits_cpu" {
  description = "CPU limits for Fluentd pods"
  type        = string
  default     = "500m"
}

variable "resources_limits_memory" {
  description = "Memory limits for Fluentd pods"
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
