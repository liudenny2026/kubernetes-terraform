# ==============================================================================
# Dev环境变量配置
# ==============================================================================

variable "istio_version" {
  description = "Istio Helm Chart版本"
  type        = string
  default     = "1.28.0"
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
  # default     = "registry.aliyuncs.com/istio"
}

variable "use_local_charts" {
  description = "是否使用本地Helm Charts (charts目录在项目根目录)"
  type        = bool
  default     = true
}

# ------------------------------------------------------------------------------
# 组件配置
# ------------------------------------------------------------------------------
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

# ------------------------------------------------------------------------------
# 副本数配置
# ------------------------------------------------------------------------------
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

# ------------------------------------------------------------------------------
# 服务配置
# ------------------------------------------------------------------------------
variable "ingress_service_type" {
  description = "Ingress Gateway服务类型 (LoadBalancer, NodePort, ClusterIP)"
  type        = string
  default     = "LoadBalancer"
  validation {
    condition     = contains(["LoadBalancer", "NodePort", "ClusterIP"], var.ingress_service_type)
    error_message = "ingress_service_type必须是LoadBalancer、NodePort或ClusterIP之一。"
  }
}

variable "enable_autoscaling" {
  description = "是否启用Gateway自动扩缩容"
  type        = bool
  default     = true
}

# ------------------------------------------------------------------------------
# 资源配置
# ------------------------------------------------------------------------------
variable "resources" {
  description = "组件资源配置"
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
      cpu_request    = "2000m"
      cpu_limit      = "4000m"
      memory_request = "4048Mi"
      memory_limit   = "8096Mi"
    }
    gateway = {
      cpu_request    = "1000m"
      cpu_limit      = "2000m"
      memory_request = "512Mi"
      memory_limit   = "1024Mi"
    }
  }
}
