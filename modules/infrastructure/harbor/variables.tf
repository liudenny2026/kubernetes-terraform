# 三级架构 - 模块�?# Harbor模块变量

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
  default     = "harbor"
  description = "Harbor部署命名空间"
}

# Harbor Helm Chart版本
variable "chart_version" {
  type        = string
  default     = "1.18.1"
  description = "Harbor Helm Chart版本"
}

# Harbor域名
variable "domain" {
  type        = string
  default     = "harbor.example.com"
  description = "Harbor访问域名"
}

# 暴露类型
variable "expose_type" {
  type        = string
  default     = "LoadBalancer"
  description = "Harbor暴露类型"
}

# TLS启用
variable "tls_enabled" {
  type        = bool
  default     = true
  description = "是否启用TLS"
}

# 存储�?variable "storage_class" {
  type        = string
  default     = "rook-ceph-block"
  description = "存储类名�?
}

# Registry PVC大小
variable "registry_pvc_size" {
  type        = string
  default     = "50Gi"
  description = "Registry持久卷大�?
}

# Jobservice PVC大小
variable "jobservice_pvc_size" {
  type        = string
  default     = "10Gi"
  description = "Jobservice持久卷大�?
}

# Database PVC大小
variable "database_pvc_size" {
  type        = string
  default     = "5Gi"
  description = "Database持久卷大�?
}

# Redis PVC大小
variable "redis_pvc_size" {
  type        = string
  default     = "5Gi"
  description = "Redis持久卷大�?
}

# Trivy PVC大小
variable "trivy_pvc_size" {
  type        = string
  default     = "5Gi"
  description = "Trivy持久卷大�?
}

# Registry副本�?variable "registry_replicas" {
  type        = number
  default     = 2
  description = "Registry副本�?
}

# Core副本�?variable "core_replicas" {
  type        = number
  default     = 2
  description = "Core副本�?
}

# Portal副本�?variable "portal_replicas" {
  type        = number
  default     = 2
  description = "Portal副本�?
}

# Jobservice副本�?variable "jobservice_replicas" {
  type        = number
  default     = 2
  description = "Jobservice副本�?
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
