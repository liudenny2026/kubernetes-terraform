# MinIO模块变量定义

variable "namespace" {
  description = "Kubernetes命名空间"
  type        = string
  default     = "minio"
}

variable "app_name" {
  description = "应用名称"
  type        = string
  default     = "minio"
}

variable "node_name" {
  description = "Kubernetes节点名称（PV绑定）"
  type        = string
  default     = "node1"
}

variable "storage_path" {
  description = "PV本地存储路径"
  type        = string
  default     = "/data/minio"
}

variable "storage_capacity" {
  description = "存储容量"
  type        = string
  default     = "40Gi"
}

variable "storage_class_name" {
  description = "StorageClass名称"
  type        = string
  default     = "minio-sc"
}

variable "pv_name" {
  description = "PersistentVolume名称"
  type        = string
  default     = "minio-pv"
}

variable "pvc_name" {
  description = "PersistentVolumeClaim名称"
  type        = string
  default     = "minio-pvc"
}

variable "deployment_name" {
  description = "Deployment名称"
  type        = string
  default     = "minio"
}

variable "service_name" {
  description = "Service名称"
  type        = string
  default     = "minio"
}

variable "secret_name" {
  description = "Secret名称"
  type        = string
  default     = "minio-secret"
}

variable "replicas" {
  description = "MinIO副本数量"
  type        = number
  default     = 2
}

variable "minio_image" {
  description = "MinIO镜像地址"
  type        = string
  default     = "192.168.40.248/library/minio/minio:RELEASE.2025-07-23T15-54-02Z"
}

variable "minio_root_user" {
  description = "MinIO管理员用户名"
  type        = string
  default     = "admin"
}

variable "minio_root_password" {
  description = "MinIO管理员密码"
  type        = string
  default     = "MinIO@Admin2024@Secure"
}

variable "minio_root_user_b64" {
  description = "Base64编码的MinIO用户名"
  type        = string
  default     = "YWRtaW4=" # base64 of "admin"
}

variable "minio_root_password_b64" {
  description = "Base64编码的MinIO密码"
  type        = string
  default     = "TWluaU9BQWRtaW4yMDI0QFNlY3VyZQ==" # base64 of "MinIO@Admin2024@Secure"
}

variable "minio_user_id" {
  description = "MinIO运行用户ID"
  type        = number
  default     = 1000
}

variable "minio_group_id" {
  description = "MinIO运行组ID"
  type        = number
  default     = 1000
}

variable "minio_api_port" {
  description = "MinIO API端口"
  type        = number
  default     = 9000
}

variable "minio_console_port" {
  description = "MinIO控制台端口"
  type        = number
  default     = 9001
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

variable "service_type" {
  description = "服务类型"
  type        = string
  default     = "ClusterIP"
}
