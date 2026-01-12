# 根模块变量定义

variable "node_name" {
  description = "Kubernetes节点名称（PV绑定）"
  type        = string
  # 默认值可以在terraform.tfvars中覆盖
}

variable "minio_root_user" {
  description = "MinIO管理员用户名"
  type        = string
  # 生产环境应使用terraform.tfvars文件设置
}

variable "minio_root_password" {
  description = "MinIO管理员密码"
  type        = string
  # 生产环境应使用terraform.tfvars文件设置
  sensitive = true
}

variable "minio_replicas" {
  description = "MinIO副本数量"
  type        = number
  default     = 1
}

variable "storage_capacity" {
  description = "存储容量"
  type        = string
  default     = "40Gi"
}

variable "service_type" {
  description = "服务类型"
  type        = string
  default     = "LoadBalancer"
}

variable "minio_cpu_request" {
  description = "MinIO CPU请求"
  type        = string
  default     = "500m"
}

variable "minio_cpu_limit" {
  description = "MinIO CPU限制"
  type        = string
  default     = "2000m"
}

variable "minio_memory_request" {
  description = "MinIO内存请求"
  type        = string
  default     = "1Gi"
}

variable "minio_memory_limit" {
  description = "MinIO内存限制"
  type        = string
  default     = "4Gi"
}
