# ============================================================================
# Resource Layer: CoreDNS ServiceAccount - Variables
# ============================================================================

variable "name" {
  description = "Name of the ServiceAccount"
  type        = string
}

variable "namespace" {
  description = "Namespace for the ServiceAccount"
  type        = string
}

variable "labels" {
  description = "Labels to apply to the ServiceAccount"
  type        = map(string)
  default     = {}
}
