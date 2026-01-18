variable "namespace" {
  description = "OAM namespace"
  type        = string
  default     = "oam-system"
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

variable "oam_version" {
  description = "OAM runtime version to deploy (using Crossplane as OAM implementation)"
  type        = string
  default     = "1.14.3"
}

variable "crossplane_chart_version" {
  description = "Crossplane Helm chart version (as OAM implementation)"
  type        = string
  default     = "1.14.3"
}

variable "crossplane_repository" {
  description = "Crossplane Helm repository"
  type        = string
  default     = "https://charts.crossplane.io/stable"
}

variable "crossplane_chart_name" {
  description = "Crossplane Helm chart name"
  type        = string
  default     = "crossplane"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "cpu_request" {
  description = "CPU request for OAM components"
  type        = string
  default     = "100m"
}

variable "memory_request" {
  description = "Memory request for OAM components"
  type        = string
  default     = "256Mi"
}

variable "cpu_limit" {
  description = "CPU limit for OAM components"
  type        = string
  default     = "200m"
}

variable "memory_limit" {
  description = "Memory limit for OAM components"
  type        = string
  default     = "512Mi"
}

variable "enable_configuration_packages" {
  description = "Enable configuration packages for OAM"
  type        = bool
  default     = true
}

variable "enable_provider_aws" {
  description = "Enable AWS provider for OAM"
  type        = bool
  default     = false
}

variable "enable_provider_kubernetes" {
  description = "Enable Kubernetes provider for OAM"
  type        = bool
  default     = true
}