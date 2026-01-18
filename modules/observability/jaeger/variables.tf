variable "namespace" {
  description = "Jaeger namespace"
  type        = string
  default     = "jaeger"
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

variable "jaeger_version" {
  description = "Jaeger version to deploy"
  type        = string
  default     = "1.46.0"
}

variable "jaeger_chart_version" {
  description = "Jaeger Helm chart version"
  type        = string
  default     = "0.70.0"
}

variable "jaeger_repository" {
  description = "Jaeger Helm repository"
  type        = string
  default     = "https://jaegertracing.github.io/helm-charts"
}

variable "jaeger_chart_name" {
  description = "Jaeger Helm chart name"
  type        = string
  default     = "jaeger"
}

variable "storage_type" {
  description = "Storage type for Jaeger (elasticsearch, cassandra, memory)"
  type        = string
  default     = "memory"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "cpu_request" {
  description = "CPU request for Jaeger components"
  type        = string
  default     = "250m"
}

variable "memory_request" {
  description = "Memory request for Jaeger components"
  type        = string
  default     = "512Mi"
}

variable "cpu_limit" {
  description = "CPU limit for Jaeger components"
  type        = string
  default     = "500m"
}

variable "memory_limit" {
  description = "Memory limit for Jaeger components"
  type        = string
  default     = "1Gi"
}

variable "storage_size" {
  description = "Storage size for Jaeger (when using persistent storage)"
  type        = string
  default     = "10Gi"
}

variable "storage_class" {
  description = "Storage class for Jaeger (when using persistent storage)"
  type        = string
  default     = "standard"
}