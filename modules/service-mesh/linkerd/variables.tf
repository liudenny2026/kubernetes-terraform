variable "namespace" {
  description = "Linkerd namespace"
  type        = string
  default     = "linkerd"
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

variable "linkerd_version" {
  description = "Linkerd version to deploy"
  type        = string
  default     = "stable-2.13.1"
}

variable "linkerd_chart_version" {
  description = "Linkerd Helm chart version"
  type        = string
  default     = "1.13.1"
}

variable "linkerd_repository" {
  description = "Linkerd Helm repository"
  type        = string
  default     = "https://helm.linkerd.io/stable"
}

variable "linkerd_chart_name" {
  description = "Linkerd Helm chart name"
  type        = string
  default     = "linkerd2"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "control_plane_cpu_request" {
  description = "CPU request for Linkerd control plane"
  type        = string
  default     = "100m"
}

variable "control_plane_memory_request" {
  description = "Memory request for Linkerd control plane"
  type        = string
  default     = "256Mi"
}

variable "control_plane_cpu_limit" {
  description = "CPU limit for Linkerd control plane"
  type        = string
  default     = "200m"
}

variable "control_plane_memory_limit" {
  description = "Memory limit for Linkerd control plane"
  type        = string
  default     = "512Mi"
}

variable "proxy_cpu_request" {
  description = "CPU request for Linkerd proxy"
  type        = string
  default     = "10m"
}

variable "proxy_memory_request" {
  description = "Memory request for Linkerd proxy"
  type        = string
  default     = "10Mi"
}

variable "proxy_cpu_limit" {
  description = "CPU limit for Linkerd proxy"
  type        = string
  default     = "100m"
}

variable "proxy_memory_limit" {
  description = "Memory limit for Linkerd proxy"
  type        = string
  default     = "50Mi"
}

variable "enable_proxy_injection" {
  description = "Enable automatic proxy injection"
  type        = bool
  default     = true
}

variable "enable_ha" {
  description = "Enable high availability mode"
  type        = bool
  default     = false
}