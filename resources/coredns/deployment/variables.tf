# ============================================================================
# Resource Layer: CoreDNS Deployment - Variables
# ============================================================================

variable "name" {
  description = "Name of the Deployment"
  type        = string
}

variable "namespace" {
  description = "Namespace for the Deployment"
  type        = string
}

variable "image" {
  description = "Container image"
  type        = string
}

variable "replicas" {
  description = "Number of replicas"
  type        = number
  default     = 2
}

variable "labels" {
  description = "Labels to apply to the Deployment"
  type        = map(string)
  default     = {}
}

variable "service_account" {
  description = "Service account name"
  type        = string
}

variable "cpu_request" {
  description = "CPU request"
  type        = string
  default     = "100m"
}

variable "cpu_limit" {
  description = "CPU limit"
  type        = string
  default     = "1000m"
}

variable "memory_request" {
  description = "Memory request"
  type        = string
  default     = "70Mi"
}

variable "memory_limit" {
  description = "Memory limit"
  type        = string
  default     = "170Mi"
}
