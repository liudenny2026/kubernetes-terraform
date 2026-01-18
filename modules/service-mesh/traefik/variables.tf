variable "namespace" {
  description = "Traefik namespace"
  type        = string
  default     = "traefik"
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

variable "traefik_version" {
  description = "Traefik version to deploy"
  type        = string
  default     = "2.10.4"
}

variable "traefik_chart_version" {
  description = "Traefik Helm chart version"
  type        = string
  default     = "24.0.0"
}

variable "traefik_repository" {
  description = "Traefik Helm repository"
  type        = string
  default     = "https://helm.traefik.io/traefik"
}

variable "traefik_chart_name" {
  description = "Traefik Helm chart name"
  type        = string
  default     = "traefik"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "cpu_request" {
  description = "CPU request for Traefik"
  type        = string
  default     = "100m"
}

variable "memory_request" {
  description = "Memory request for Traefik"
  type        = string
  default     = "128Mi"
}

variable "cpu_limit" {
  description = "CPU limit for Traefik"
  type        = string
  default     = "300m"
}

variable "memory_limit" {
  description = "Memory limit for Traefik"
  type        = string
  default     = "256Mi"
}

variable "replica_count" {
  description = "Number of Traefik replicas"
  type        = number
  default     = 1
}

variable "enable_dashboard" {
  description = "Enable Traefik dashboard"
  type        = bool
  default     = true
}

variable "dashboard_ingress_enabled" {
  description = "Enable ingress for Traefik dashboard"
  type        = bool
  default     = false
}

variable "service_type" {
  description = "Type of service for Traefik"
  type        = string
  default     = "LoadBalancer"
}

variable "acme_enabled" {
  description = "Enable ACME (Let's Encrypt) support"
  type        = bool
  default     = false
}

variable "acme_email" {
  description = "Email for ACME certificates"
  type        = string
  default     = "admin@example.com"
}