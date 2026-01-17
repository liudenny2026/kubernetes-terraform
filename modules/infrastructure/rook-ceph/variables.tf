# ============================================================================
# Rook-Ceph Module - Variables
# 命名规范: ${var.environment}-${var.naming_prefix}-rook-ceph-${resource_type}
# ============================================================================

variable "environment" {
  description = "Environment name (dev/stage/prod)"
  type        = string
  default     = "prod"
}

variable "naming_prefix" {
  description = "Naming prefix for resources"
  type        = string
  default     = "cloud-native"
}

variable "rook_namespace" {
  description = "Namespace for Rook operator"
  type        = string
  default     = "rook-ceph"
}

variable "ceph_cluster_namespace" {
  description = "Namespace for Ceph cluster"
  type        = string
  default     = "rook-ceph"
}

variable "rook_version" {
  description = "Rook version"
  type        = string
  default     = "v1.14.0"
}

variable "ceph_version" {
  description = "Ceph version"
  type        = string
  default     = "v18.2.0"
}

variable "osd_count" {
  description = "Number of OSD daemons"
  type        = number
  default     = 3
}

variable "osd_disk_size" {
  description = "Size of OSD disks"
  type        = string
  default     = "100Gi"
}

variable "mon_count" {
  description = "Number of Ceph monitors"
  type        = number
  default     = 3
}

variable "mgr_count" {
  description = "Number of Ceph managers"
  type        = number
  default     = 2
}

variable "enable_ceph_fs" {
  description = "Enable Ceph filesystem"
  type        = bool
  default     = true
}

variable "enable_rbd" {
  description = "Enable Ceph RBD"
  type        = bool
  default     = true
}

variable "ceph_fs_pool_size" {
  description = "CephFS pool replication size"
  type        = number
  default     = 3
}

variable "rbd_pool_size" {
  description = "RBD pool replication size"
  type        = number
  default     = 3
}

variable "ceph_fs_data_pool_name" {
  description = "CephFS data pool name"
  type        = string
  default     = "cephfs-data"
}

variable "ceph_fs_metadata_pool_name" {
  description = "CephFS metadata pool name"
  type        = string
  default     = "cephfs-metadata"
}

variable "rbd_pool_name" {
  description = "RBD pool name"
  type        = string
  default     = "rbd"
}

variable "storage_device" {
  description = "Storage device to use for OSDs"
  type        = string
  default     = "/dev/sdb"
}

variable "enable_dashboard" {
  description = "Enable Ceph dashboard"
  type        = bool
  default     = true
}

variable "dashboard_port" {
  description = "Ceph dashboard port"
  type        = number
  default     = 8443
}

variable "tags" {
  description = "Standard tags to apply to all resources"
  type        = map(string)
  default = {
    Environment  = "prod"
    CostCenter   = "12345"
    Security     = "cloud-native"
  }
}

variable "custom_settings" {
  description = "Custom Ceph settings"
  type        = map(string)
  default     = {}
}

variable "enable_monitoring" {
  description = "Enable Ceph monitoring"
  type        = bool
  default     = true
}

variable "use_helm_deployment" {
  description = "Use Helm deployment for Rook-Ceph instead of native Kubernetes resources"
  type        = bool
  default     = false
}

# Helm部署相关变量
variable "storage_class" {
  description = "Storage class for Rook-Ceph"
  type        = string
  default     = "standard"
}

variable "registry_mirror" {
  description = "Registry mirror for container images"
  type        = string
  default     = ""
}
