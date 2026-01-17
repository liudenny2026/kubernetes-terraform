# ============================================================================
# Resource Layer: CoreDNS ConfigMap - Variables
# ============================================================================

variable "name" {
  description = "Name of the ConfigMap"
  type        = string
}

variable "namespace" {
  description = "Namespace for the ConfigMap"
  type        = string
}

variable "labels" {
  description = "Labels to apply to the ConfigMap"
  type        = map(string)
  default     = {}
}

variable "cluster_domain" {
  description = "Kubernetes cluster domain"
  type        = string
  default     = "cluster.local"
}

variable "upstream_dns" {
  description = "Upstream DNS servers (space separated)"
  type        = string
}

variable "enable_stub_domains" {
  description = "Enable stub domains in Corefile"
  type        = bool
  default     = false
}

variable "stub_domains" {
  description = "Stub domains configuration"
  type        = map(list(string))
  default     = {}
}
