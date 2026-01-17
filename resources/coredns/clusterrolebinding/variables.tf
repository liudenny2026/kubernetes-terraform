# ============================================================================
# Resource Layer: CoreDNS ClusterRoleBinding - Variables
# ============================================================================

variable "name" {
  description = "Name of the ClusterRoleBinding"
  type        = string
}

variable "labels" {
  description = "Labels to apply to the ClusterRoleBinding"
  type        = map(string)
  default     = {}
}

variable "clusterrole_name" {
  description = "Name of the ClusterRole to bind"
  type        = string
}

variable "serviceaccount_name" {
  description = "Name of the ServiceAccount to bind"
  type        = string
}

variable "namespace" {
  description = "Namespace of the ServiceAccount"
  type        = string
}
