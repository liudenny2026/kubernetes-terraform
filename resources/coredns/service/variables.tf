# ============================================================================
# Resource Layer: CoreDNS Service - Variables
# ============================================================================

variable "name" {
  description = "Name of the Service"
  type        = string
}

variable "namespace" {
  description = "Namespace for the Service"
  type        = string
}

variable "selector_labels" {
  description = "Labels to select pods"
  type        = map(string)
}

variable "labels" {
  description = "Labels to apply to the Service"
  type        = map(string)
  default     = {}
}

variable "enable_metrics" {
  description = "Enable Prometheus metrics"
  type        = bool
  default     = true
}
