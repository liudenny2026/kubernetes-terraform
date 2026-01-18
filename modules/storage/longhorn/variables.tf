variable "namespace" {
  description = "Longhorn namespace"
  type        = string
  default     = "longhorn-system"
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

variable "longhorn_version" {
  description = "Longhorn version to deploy"
  type        = string
  default     = "1.5.1"
}

variable "longhorn_chart_version" {
  description = "Longhorn Helm chart version"
  type        = string
  default     = "1.5.3"
}

variable "longhorn_repository" {
  description = "Longhorn Helm repository"
  type        = string
  default     = "https://charts.longhorn.io"
}

variable "longhorn_chart_name" {
  description = "Longhorn Helm chart name"
  type        = string
  default     = "longhorn"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "default_replica_count" {
  description = "Default replica count for Longhorn volumes"
  type        = number
  default     = 3
}

variable "storage_class" {
  description = "Default storage class name"
  type        = string
  default     = "longhorn"
}

variable "create_default_storage_class" {
  description = "Create default Longhorn storage class"
  type        = bool
  default     = true
}

variable "cpu_request" {
  description = "CPU request for Longhorn components"
  type        = string
  default     = "100m"
}

variable "memory_request" {
  description = "Memory request for Longhorn components"
  type        = string
  default     = "128Mi"
}

variable "cpu_limit" {
  description = "CPU limit for Longhorn components"
  type        = string
  default     = "200m"
}

variable "memory_limit" {
  description = "Memory limit for Longhorn components"
  type        = string
  default     = "512Mi"
}

variable "ui_replica_count" {
  description = "Replica count for Longhorn UI"
  type        = number
  default     = 1
}