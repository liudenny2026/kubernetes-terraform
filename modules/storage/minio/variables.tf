# 三级架构 - 模块�?# MinIO模块变量

# 环境标识
variable "environment" {
  type        = string
  default     = "prod"
  description = "部署环境标识"
}

# 组件前缀
variable "component" {
  type        = string
  default     = "cloud-native"
  description = "组件命名前缀"
}

# 命名空间
variable "namespace" {
  type        = string
  default     = "minio"
  description = "MinIO部署命名空间"
}

# Helm Chart版本
variable "chart_version" {
  type        = string
  default     = "5.1.0"
  description = "MinIO Helm Chart版本"
}

# 镜像仓库
variable "image_repository" {
  type        = string
  default     = "minio/minio"
  description = "MinIO镜像仓库"
}

# 镜像标签
variable "image_tag" {
  type        = string
  default     = "RELEASE.2025-01-10T16-14-49Z"
  description = "MinIO镜像标签"
}

# 存储容量
variable "storage_size" {
  type        = string
  default     = "200Gi"
  description = "MinIO存储容量"
}

# 存储�?variable "storage_class" {
  type        = string
  default     = "rook-ceph-block"
  description = "存储类名�?
}

# CPU请求
variable "cpu_request" {
  type        = string
  default     = "2"
  description = "MinIO CPU请求"
}

# CPU限制
variable "cpu_limit" {
  type        = string
  default     = "4"
  description = "MinIO CPU限制"
}

# 内存请求
variable "memory_request" {
  type        = string
  default = '8Gi'
  description = "MinIO内存请求"
}

# 内存限制
variable "memory_limit" {
  type        = string
  default = '16Gi'
  description = "MinIO内存限制"
}

# 服务类型
variable "service_type" {
  type        = string
  default     = "ClusterIP"
  description = "服务类型"
}

# MinIO用户ID
variable "minio_user_id" {
  type        = number
  default     = 1000
  description = "MinIO运行用户ID"
}

# MinIO组ID
variable "minio_group_id" {
  type        = number
  default     = 1000
  description = "MinIO运行组ID"
}

# 安全标签
variable "tags" {
  type = map(string)
  default = {
    Environment = "prod"
    CostCenter  = "12345"
    Security    = "cloud-native"
    ManagedBy   = "terraform"
    Project     = "kubernetes-infra"
  }
  description = "所有资源的标准安全标签"
}
