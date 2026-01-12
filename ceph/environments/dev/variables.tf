# Variables for Ceph on Kubernetes deployment

variable "k8s_config_path" {
  description = "Path to kubeconfig file"
  type        = string
  default     = "~/.kube/config"
}

variable "k8s_context" {
  description = "Kubernetes context to use"
  type        = string
  default     = ""
}

variable "ceph_namespace" {
  description = "Namespace for Ceph deployment"
  type        = string
  default     = "rook-ceph"
}

variable "ceph_cluster_name" {
  description = "Name of the Ceph cluster"
  type        = string
  default     = "rook-ceph"
}

variable "node_names" {
  description = "List of Kubernetes node names where Ceph will be deployed (use 'kubectl get nodes' to see actual node names - replace master, node1, node2 with your actual node names)"
  type        = list(string)
  default     = ["master", "node1", "node2"]
}

variable "storage_devices" {
  description = "List of storage devices to use for Ceph OSDs"
  type        = list(string)
  default     = ["sdb"]
}

variable "storage_size" {
  description = "Size of storage to allocate per device (in GB)"
  type        = number
  default     = 100
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

variable "dashboard_ingress_enabled" {
  description = "Enable ingress for Ceph dashboard"
  type        = bool
  default     = false
}

variable "dashboard_ingress_host" {
  description = "Host for Ceph dashboard ingress"
  type        = string
  default     = "ceph.local"
}