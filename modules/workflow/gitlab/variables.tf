# 三级架构 - 模块�?# GitLab模块变量

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
  default     = "gitlab"
  description = "GitLab部署命名空间"
}

# GitLab Helm Chart版本
variable "chart_version" {
  type        = string
  default     = "6.11.0"
  description = "GitLab Helm Chart版本"
}

# GitLab版本
variable "gitlab_version" {
  type        = string
  default     = "18.6.0"
  description = "GitLab版本"
}

# GitLab域名
variable "domain" {
  type        = string
  default     = "gitlab.example.com"
  description = "GitLab访问域名"
}

# 存储�?variable "storage_class" {
  type        = string
  default     = "rook-ceph-block"
  description = "用于持久卷的存储�?
}

# PVC大小
variable "pvc_size" {
  type        = string
  default     = "8Gi"
  description = "持久卷声明的大小"
}

# 是否使用私有仓库
variable "use_private_registry" {
  type        = bool
  default     = true
  description = "是否使用私有仓库获取镜像"
}

# 私有仓库URL
variable "private_registry_url" {
  type        = string
  default     = "192.168.40.248/library"
  description = "私有仓库URL"
}

# GitLab资源配置
variable "gitlab_resources" {
  description = "GitLab资源限制和请�?
  type = object({
    requests = object({
      cpu    = string
      memory = string
    })
    limits = object({
      cpu    = string
      memory = string
    })
  })
  default = {
    requests = {
      cpu    = "3000m"
      memory = "10Gi"
    }
    limits = {
      cpu    = "6000m"
      memory = "20Gi"
    }
  }
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
