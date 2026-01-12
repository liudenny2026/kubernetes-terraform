variable "namespace" {
  description = "Kubernetes命名空间"
  type        = string
  default     = "metallb-system"
}

variable "ip_address_pool_name" {
  description = "IPAddressPool名称"
  type        = string
  default     = "metallb-pool"
}

variable "ip_addresses" {
  description = "MetalLB IP地址池"
  type        = list(string)
  default     = ["192.168.40.100-192.168.40.110"]
}

variable "l2_advertisement_name" {
  description = "L2Advertisement名称"
  type        = string
  default     = "metallb-l2"
}

variable "metallb_version" {
  description = "MetalLB版本"
  type        = string
  default     = "v0.15.3"
}

variable "kube_proxy_strict_arp" {
  description = "kube-proxy strictARP配置（MetalLB L2模式必需）"
  type        = bool
  default     = true
}

variable "configure_kube_proxy" {
  description = "是否配置kube-proxy strictARP（kube-proxy ConfigMap已存在时设为false）"
  type        = bool
  default     = true
}
