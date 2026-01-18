# 三级架构 - 模块�?# Istio模块变量

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
  default     = "istio-system"
  description = "Istio部署命名空间"
}

# Istio Helm Chart版本
variable "chart_version" {
  type        = string
  default     = "1.28.2"
  description = "Istio Helm Chart版本"
}

# 镜像仓库代理地址
variable "registry_mirror" {
  description = "镜像仓库代理地址，留空则使用官方仓库"
  type        = string
  default     = ""
}

# 是否启用Istiod控制平面
variable "enable_istiod" {
  description = "是否启用Istiod控制平面"
  type        = bool
  default     = true
}

# 是否启用Ingress Gateway
variable "enable_ingress" {
  description = "是否启用Ingress Gateway"
  type        = bool
  default     = true
}

# 是否启用Egress Gateway
variable "enable_egress" {
  description = "是否启用Egress Gateway"
  type        = bool
  default     = false
}

# Istiod副本�?variable "istiod_replicas" {
  description = "Istiod副本�?
  type        = number
  default     = 1
}

# Ingress Gateway副本�?variable "ingress_replicas" {
  description = "Ingress Gateway副本�?
  type        = number
  default     = 2
}

# Ingress Gateway服务类型
variable "ingress_service_type" {
  description = "Ingress Gateway服务类型"
  type        = string
  default     = "LoadBalancer"
}

# 是否启用Gateway自动扩缩�?variable "enable_autoscaling" {
  description = "是否启用Gateway自动扩缩�?
  type        = bool
  default     = true
}

# 资源配置
variable "resources" {
  description = "资源配置"
  type = object({
    istiod = object({
      cpu_request    = string
      cpu_limit      = string
      memory_request = string
      memory_limit   = string
    })
    gateway = object({
      cpu_request    = string
      cpu_limit      = string
      memory_request = string
      memory_limit   = string
    })
  })
  default = {
    istiod = {
      cpu_request    = "500m"
      cpu_limit      = "1000m"
      memory_request = "2048Mi"
      memory_limit   = "4096Mi"
    }
    gateway = {
      cpu_request    = "100m"
      cpu_limit      = "500m"
      memory_request = "128Mi"
      memory_limit   = "256Mi"
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
