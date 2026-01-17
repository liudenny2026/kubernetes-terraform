# ============================================================================
# Resource Layer: CoreDNS ClusterRole - Variables
# ============================================================================

variable "name" {
  description = "Name of the ClusterRole"
  type        = string
}

variable "labels" {
  description = "Labels to apply to the ClusterRole"
  type        = map(string)
  default     = {}
}
