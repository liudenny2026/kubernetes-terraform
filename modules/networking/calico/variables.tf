# ============================================================================
# Calico Network Plugin Module - Variables
# 三级架构: 资源�?- Network Variables
# 命名规范: ${var.environment}-${var.naming_prefix}-base-calico-{resource-type}
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
  description = "Namespace for Calico deployment"
  type        = string
  default     = "kube-system"
}

# Calico版本
variable "calico_version" {
  description = "Calico image version"
  type        = string
  default     = "v3.29.1"
}

# Calico Helm仓库
variable "calico_repository" {
  description = "Helm repository for Calico"
  type        = string
  default     = "https://docs.projectcalico.org/charts"
}

# Calico Helm图表名称
variable "calico_chart_name" {
  description = "Helm chart name for Calico"
  type        = string
  default     = "tigera-operator"
}

# Calico Helm图表版本
variable "calico_chart_version" {
  description = "Helm chart version for Calico"
  type        = string
  default     = "v3.29.1"
}

# Pod CIDR
variable "pod_cidr" {
  description = "Pod CIDR for Calico network"
  type        = string
  default     = "192.168.0.0/16"
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
