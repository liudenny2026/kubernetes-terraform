# 模块变量定义
# 文件：modules/pvcs/variables.tf

variable "namespace" {
  description = "PVC 将被创建的命名空间"
  type        = string
}

variable "storage_class" {
  description = "使用的默认存储类"
  type        = string
  default     = "rook-ceph-blockstorage"
}

variable "database_storage_class" {
  description = "用于数据库的存储类"
  type        = string
  default     = "rook-ceph-blockstorage"
}

variable "redis_storage_class" {
  description = "用于 Redis 的存储类"
  type        = string
  default     = "rook-ceph-blockstorage"
}

variable "registry_storage_class" {
  description = "用于 Registry 的存储类"
  type        = string
  default     = "rook-ceph-blockstorage"
}

variable "pvc_size" {
  description = "PVC 大小（除 registry 外）"
  type        = string
  default     = "5Gi"
}