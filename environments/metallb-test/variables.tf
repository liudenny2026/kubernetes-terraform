# ============================================================================
# MetalLB Test Environment - Variables
# ============================================================================

# 集群连接配置
variable "kubeconfig_path" {
  description = "Kubernetes kubeconfig 文件路径"
  type        = string
  default     = "~/.kube/config"
}

variable "config_context" {
  description = "Kubernetes 上下文名称"
  type        = string
  default     = ""
}

# MetalLB配置变量
variable "metallb_namespace" {
  description = "MetalLB命名空间"
  type        = string
  default     = "metallb-system"
}

variable "metallb_ip_address_pool_name" {
  description = "MetalLB IP地址池名称"
  type        = string
  default     = "metallb-test-pool"
}

variable "metallb_ip_addresses" {
  description = "MetalLB IP地址范围"
  type        = list(string)
  default     = ["192.168.40.200-192.168.40.210"]
}

variable "metallb_version" {
  description = "MetalLB版本"
  type        = string
  default     = "v0.15.3"
}\n