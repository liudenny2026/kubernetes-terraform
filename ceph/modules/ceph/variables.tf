# Variables for Ceph cluster module

variable "namespace" {
  description = "Namespace for Ceph cluster"
  type        = string
}

variable "cluster_name" {
  description = "Name of the Ceph cluster"
  type        = string
  default     = "rook-ceph"
}

variable "node_names" {
  description = "List of node names where Ceph will be deployed"
  type        = list(string)
}

variable "storage_devices" {
  description = "List of storage devices to use for Ceph OSDs"
  type        = list(string)
}

variable "storage_size" {
  description = "Size of storage to allocate per device (in GB)"
  type        = number
}

variable "monitor_count" {
  description = "Number of Ceph monitors to deploy"
  type        = number
  default     = 3
}

variable "enable_dashboard" {
  description = "Enable Ceph dashboard"
  type        = bool
  default     = true
}

variable "dashboard_loadbalancer_enabled" {
  description = "Enable LoadBalancer for dashboard"
  type        = bool
  default     = false
}

variable "dashboard_loadbalancer_ip_mode" {
  description = "IP mode for LoadBalancer (e.g., 'ipv4', 'ipv6', 'dual')"
  type        = string
  default     = ""
}

variable "ingress_enabled" {
  description = "Enable ingress for Ceph dashboard"
  type        = bool
  default     = false
}

variable "ingress_host" {
  description = "Host for Ceph dashboard ingress"
  type        = string
  default     = "ceph.local"
}