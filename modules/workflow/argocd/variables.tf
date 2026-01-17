# 三级架构 - 模块�?# ArgoCD模块变量

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
  default     = "argocd"
  description = "ArgoCD部署命名空间"
}

# ArgoCD Helm chart版本
variable "chart_version" {
  type        = string
  default     = "5.33.0"
  description = "ArgoCD Helm chart版本"
}

# ArgoCD镜像仓库
variable "image_repository" {
  type        = string
  default     = "registry.cn-hangzhou.aliyuncs.com/argoproj"
  description = "ArgoCD镜像仓库"
}

# ArgoCD Server服务类型
variable "server_service_type" {
  type        = string
  default     = "LoadBalancer"
  description = "ArgoCD Server服务类型"
}

# ArgoCD域名
variable "domain" {
  type        = string
  default     = "argocd.example.com"
  description = "ArgoCD访问域名"
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
