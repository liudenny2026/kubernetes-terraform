variable "namespace" {
  description = "KubeOperator namespace"
  type        = string
  default     = "kubeoperator"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "naming_prefix" {
  description = "Naming prefix for resources"
  type        = string
  default     = "cloud-native"
}

variable "kubeoperator_version" {
  description = "KubeOperator version to deploy"
  type        = string
  default     = "3.16.0"
}

variable "kubeoperator_chart_version" {
  description = "KubeOperator Helm chart version"
  type        = string
  default     = "3.16.0"
}

variable "kubeoperator_repository" {
  description = "KubeOperator Helm repository"
  type        = string
  default     = "https://github.com/KubeOperator/charts"
}

variable "kubeoperator_chart_name" {
  description = "KubeOperator Helm chart name"
  type        = string
  default     = "kubeoperator"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "cpu_request" {
  description = "CPU request for KubeOperator components"
  type        = string
  default     = "500m"
}

variable "memory_request" {
  description = "Memory request for KubeOperator components"
  type        = string
  default     = "1Gi"
}

variable "cpu_limit" {
  description = "CPU limit for KubeOperator components"
  type        = string
  default     = "1000m"
}

variable "memory_limit" {
  description = "Memory limit for KubeOperator components"
  type        = string
  default     = "2Gi"
}

variable "storage_size" {
  description = "Storage size for KubeOperator"
  type        = string
  default     = "20Gi"
}

variable "storage_class" {
  description = "Storage class for KubeOperator"
  type        = string
  default     = "standard"
}

variable "enable_backup" {
  description = "Enable backup functionality"
  type        = bool
  default     = true
}

variable "backup_storage_size" {
  description = "Backup storage size"
  type        = string
  default     = "50Gi"
}