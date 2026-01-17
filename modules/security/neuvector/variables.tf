# 三级架构 - 模块�?# NeuVector模块变量

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
  default     = "neuvector"
  description = "NeuVector部署命名空间"
}

# Helm Chart版本
variable "chart_version" {
  type        = string
  default     = "2.6.0"
  description = "NeuVector Helm Chart版本"
}

# 镜像仓库
variable "image_registry" {
  type        = string
  default     = "neuvector"
  description = "NeuVector镜像仓库"
}

# 镜像标签
variable "image_tag" {
  type        = string
  default     = "5.4.5"
  description = "NeuVector镜像标签"
}

# 服务类型
variable "service_type" {
  type        = string
  default     = "ClusterIP"
  description = "服务暴露类型"
}

# All-in-One模式
variable "use_allinone" {
  type        = bool
  default     = false
  description = "是否使用All-in-One模式部署"
}

# Manager副本�?variable "manager_replicas" {
  type        = number
  default     = 2
  description = "Manager组件副本�?
}

# Controller副本�?variable "controller_replicas" {
  type        = number
  default     = 3
  description = "Controller组件副本�?
}

# Manager CPU请求
variable "manager_cpu_request" {
  type        = string
  default = '1000m'
  description = "Manager CPU请求"
}

# Manager内存请求
variable "manager_memory_request" {
  type        = string
  default = '2Gi'
  description = "Manager内存请求"
}

# Manager CPU限制
variable "manager_cpu_limit" {
  type        = string
  default = '4000m'
  description = "Manager CPU限制"
}

# Manager内存限制
variable "manager_memory_limit" {
  type        = string
  default = '4Gi'
  description = "Manager内存限制"
}

# Controller CPU请求
variable "controller_cpu_request" {
  type        = string
  default = '400m'
  description = "Controller CPU请求"
}

# Controller内存请求
variable "controller_memory_request" {
  type        = string
  default = '1024Mi'
  description = "Controller内存请求"
}

# Controller CPU限制
variable "controller_cpu_limit" {
  type        = string
  default = '2000m'
  description = "Controller CPU限制"
}

# Controller内存限制
variable "controller_memory_limit" {
  type        = string
  default = '2Gi'
  description = "Controller内存限制"
}

# Enforcer CPU请求
variable "enforcer_cpu_request" {
  type        = string
  default = '200m'
  description = "Enforcer CPU请求"
}

# Enforcer内存请求
variable "enforcer_memory_request" {
  type        = string
  default = '512Mi'
  description = "Enforcer内存请求"
}

# Enforcer CPU限制
variable "enforcer_cpu_limit" {
  type        = string
  default = '1000m'
  description = "Enforcer CPU限制"
}

# Enforcer内存限制
variable "enforcer_memory_limit" {
  type        = string
  default = '1024Mi'
  description = "Enforcer内存限制"
}

# 是否暴露Manager为LoadBalancer
variable "expose_manager_loadbalancer" {
  type        = bool
  default     = false
  description = "是否将Manager暴露为LoadBalancer"
}

# 是否创建RBAC
variable "create_rbac" {
  type        = bool
  default     = true
  description = "是否创建RBAC权限"
}

# 调试模式
variable "debug_mode" {
  type        = bool
  default     = false
  description = "是否启用调试模式"
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
