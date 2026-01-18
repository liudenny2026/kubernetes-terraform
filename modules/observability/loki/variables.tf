variable "namespace" {
  description = "Loki namespace"
  type        = string
  default     = "loki"
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

variable "loki_version" {
  description = "Loki version to deploy"
  type        = string
  default     = "2.9.2"
}

variable "loki_chart_version" {
  description = "Loki Helm chart version"
  type        = string
  default     = "5.37.0"
}

variable "loki_repository" {
  description = "Loki Helm repository"
  type        = string
  default     = "https://grafana.github.io/helm-charts"
}

variable "loki_chart_name" {
  description = "Loki Helm chart name"
  type        = string
  default     = "loki-stack"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "cpu_request" {
  description = "CPU request for Loki components"
  type        = string
  default     = "250m"
}

variable "memory_request" {
  description = "Memory request for Loki components"
  type        = string
  default     = "512Mi"
}

variable "cpu_limit" {
  description = "CPU limit for Loki components"
  type        = string
  default     = "500m"
}

variable "memory_limit" {
  description = "Memory limit for Loki components"
  type        = string
  default     = "1Gi"
}

variable "storage_size" {
  description = "Storage size for Loki"
  type        = string
  default     = "10Gi"
}

variable "storage_class" {
  description = "Storage class for Loki"
  type        = string
  default     = "standard"
}

variable "enable_promtail" {
  description = "Enable Promtail sidecar"
  type        = bool
  default     = true
}

variable "enable_grafana" {
  description = "Enable Grafana in Loki stack"
  type        = bool
  default     = false
}