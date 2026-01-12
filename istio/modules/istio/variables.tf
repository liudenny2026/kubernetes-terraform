variable "istio_version" {
  description = "Istio Helm Chart版本"
  type        = string
  default     = "1.28.2"
}

variable "istio_namespace" {
  description = "Istio系统组件安装的命名空间"
  type        = string
  default     = "istio-system"
}

variable "registry_mirror" {
  description = "镜像仓库代理地址，留空则使用官方仓库"
  type        = string
  default     = ""
  # default     = "192.168.40.248/library"
}

variable "enable_istiod" {
  description = "是否启用Istiod控制平面"
  type        = bool
  default     = true
}

variable "enable_ingress" {
  description = "是否启用Ingress Gateway"
  type        = bool
  default     = true
}

variable "enable_egress" {
  description = "是否启用Egress Gateway"
  type        = bool
  default     = false
}

variable "istiod_replicas" {
  description = "Istiod副本数"
  type        = number
  default     = 1
}

variable "ingress_replicas" {
  description = "Ingress Gateway副本数"
  type        = number
  default     = 2
}

variable "ingress_service_type" {
  description = "Ingress Gateway服务类型"
  type        = string
  default     = "LoadBalancer"
}

variable "enable_autoscaling" {
  description = "是否启用Gateway自动扩缩容"
  type        = bool
  default     = true
}

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

variable "use_local_charts" {
  description = "是否使用本地Helm Charts (charts目录在项目根目录)"
  type        = bool
  default     = false
}
