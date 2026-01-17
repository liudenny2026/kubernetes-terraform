# ============================================================================
# Trivy Security Module - Variables
# 三级架构: 资源�?- Security Variables
# 命名规范: ${var.environment}-${var.naming_prefix}-security-trivy-{resource-type}
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
  description = "Namespace for Trivy deployment"
  type        = string
  default     = "security"
}

# 镜像配置
variable "trivy_image_repository" {
  description = "Trivy operator image repository"
  type        = string
  default     = "ghcr.io/aquasecurity/trivy-operator"
}

variable "trivy_image_tag" {
  description = "Trivy operator image tag"
  type        = string
  default     = "0.22.0"
}

variable "image_pull_policy" {
  description = "Image pull policy"
  type        = string
  default     = "IfNotPresent"
}

# Helm配置
variable "trivy_repository" {
  description = "Helm repository for Trivy"
  type        = string
  default     = "https://aquasecurity.github.io/helm-charts/"
}

variable "trivy_chart_name" {
  description = "Helm chart name for Trivy"
  type        = string
  default     = "trivy-operator"
}

variable "trivy_chart_version" {
  description = "Helm chart version for Trivy"
  type        = string
  default     = "0.22.0"
}

# Trivy配置
variable "trivy_mode" {
  description = "Trivy scan mode (Standalone, ClientServer)"
  type        = string
  default     = "Standalone"
}

variable "trivy_vuln_type" {
  description = "Vulnerability types to scan for"
  type        = string
  default     = "os,library"
}

variable "trivy_severity" {
  description = "Severity levels to report"
  type        = string
  default     = "CRITICAL,HIGH"
}

# 资源请求和限�?variable "resources_requests_cpu" {
  description = "CPU requests for Trivy scan jobs"
  type        = string
  default     = "250m"
}

variable "resources_requests_memory" {
  description = "Memory requests for Trivy scan jobs"
  type        = string
  default     = "512Mi"
}

variable "resources_limits_cpu" {
  description = "CPU limits for Trivy scan jobs"
  type        = string
  default     = "500m"
}

variable "resources_limits_memory" {
  description = "Memory limits for Trivy scan jobs"
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
