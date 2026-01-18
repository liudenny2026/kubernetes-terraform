variable "namespace" {
  description = "Rancher namespace"
  type        = string
  default     = "cattle-system"
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

variable "rancher_version" {
  description = "Rancher version to deploy"
  type        = string
  default     = "2.8.0"
}

variable "rancher_chart_version" {
  description = "Rancher Helm chart version"
  type        = string
  default     = "2.8.0"
}

variable "rancher_repository" {
  description = "Rancher Helm repository"
  type        = string
  default     = "https://releases.rancher.com/server-charts/latest"
}

variable "rancher_chart_name" {
  description = "Rancher Helm chart name"
  type        = string
  default     = "rancher"
}

variable "hostname" {
  description = "Rancher server hostname"
  type        = string
  default     = "rancher.example.com"
}

variable "bootstrap_password" {
  description = "Bootstrap password for Rancher"
  type        = string
  default     = "admin123"
  sensitive   = true
}

variable "replica_count" {
  description = "Number of Rancher server replicas"
  type        = number
  default     = 3
}

variable "tls" {
  description = "TLS configuration for Rancher (valid options: ingress, external, false)"
  type        = string
  default     = "ingress"
}

variable "ingress_tls_source" {
  description = "TLS source for ingress (valid options: rancher, letsEncrypt, secret)"
  type        = string
  default     = "rancher"
}

variable "lets_encrypt_environment" {
  description = "Let's Encrypt environment (valid options: production, staging)"
  type        = string
  default     = "staging"
}

variable "lets_encrypt_email" {
  description = "Email for Let's Encrypt certificate"
  type        = string
  default     = "admin@example.com"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "cpu_request" {
  description = "CPU request for Rancher components"
  type        = string
  default     = "100m"
}

variable "memory_request" {
  description = "Memory request for Rancher components"
  type        = string
  default     = "256Mi"
}

variable "cpu_limit" {
  description = "CPU limit for Rancher components"
  type        = string
  default     = "500m"
}

variable "memory_limit" {
  description = "Memory limit for Rancher components"
  type        = string
  default     = "1Gi"
}

variable "private_ca" {
  description = "Indicates if using private CA"
  type        = bool
  default     = false
}