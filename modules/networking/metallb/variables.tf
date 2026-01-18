variable "namespace" {
  description = "Kubernetes命名空间 - 建议使用独立命名空间避免冲突"
  type        = string
  default     = "metallb-system"
  validation {
    condition     = contains(["metallb-system", "metallb"], var.namespace) || length(regexall("metallb.*", var.namespace)) > 0
    error_message = "命名空间必须包含'metallb'或使用标准命名空间'metallb-system'/'metallb'"
  }
}

variable "metallb_version" {
  description = "MetalLB版本"
  type        = string
  default     = "v0.15.5"
  validation {
    condition     = length(regexall("^v[0-9]+\\.[0-9]+\\.[0-9]+$|^main$|^master$", var.metallb_version)) > 0
    error_message = "版本必须符合语义化版本格式或指定分支名"
  }
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

# 新增：环境标签变量 - 用于资源隔离
variable "tags" {
  description = "资源标签 - 用于环境隔离和成本分配"
  type        = map(string)
  default     = {}
  validation {
    condition     = length(var.tags) >= 0
    error_message = "标签必须是有效的map类型"
  }
}

# 新增：多IP地址池配置（支持多个IPAddressPool）
variable "ip_address_pools" {
  description = "MetalLB IP地址池配置列表 - 支持多个IP地址池"
  type = list(object({
    name         = string
    addresses    = list(string)
    auto_assign  = optional(bool, true)
    avoid_buggy_ips = optional(bool, false)
    block_size   = optional(number, 24)
    cidr         = optional(list(string), [])
  }))
  default = [
    {
      name      = "metallb-default-pool"
      addresses = ["192.168.40.100-192.168.40.110"]
      auto_assign = true
    }
  ]
  validation {
    condition     = length(var.ip_address_pools) >= 0
    error_message = "IP地址池列表必须有效"
  }
}

# 新增：高级L2广告配置
variable "l2_advertisements" {
  description = "MetalLB L2广告配置列表 - 支持高级L2广告配置"
  type = list(object({
    name                 = string
    ip_address_pools     = optional(list(string), [])
    ip_address_pool_selectors = optional(list(object({
      match_labels = optional(map(string), {})
    })), [])
    interfaces           = optional(list(string), [])
    node_selectors       = optional(list(object({
      match_labels = optional(map(string), {})
      match_expressions = optional(list(object({
        key      = string
        operator = string
        values   = list(string)
      })), [])
    })), [])
  }))
  default = [
    {
      name                 = "metallb-default-l2"
      ip_address_pools     = ["metallb-default-pool"]
    }
  ]
  validation {
    condition     = length(var.l2_advertisements) >= 0
    error_message = "L2广告配置列表必须有效"
  }
}

# 新增：BGP对等体配置
variable "bgp_peers" {
  description = "MetalLB BGP对等体配置列表 - 支持BGP模式"
  type = list(object({
    name           = string
    my_asn         = number
    peer_asn       = number
    peer_address   = string
    peer_port      = optional(number, 179)
    hold_time      = optional(string, "10s")
    keepalive_time = optional(string, "30s")
    router_id      = optional(string, null)
    node_selectors = optional(list(object({
      match_labels = optional(map(string), {})
      match_expressions = optional(list(object({
        key      = string
        operator = string
        values   = list(string)
      })), [])
    })), [])
    password_secret = optional(object({
      name = string
      key  = string
    }), null)
  }))
  default = []
  validation {
    condition     = length(var.bgp_peers) >= 0
    error_message = "BGP对等体配置列表必须有效"
  }
}

# 新增：BGP广告配置
variable "bgp_advertisements" {
  description = "MetalLB BGP广告配置列表 - 支持BGP广告配置"
  type = list(object({
    name                    = string
    ip_address_pools        = optional(list(string), [])
    ip_address_pool_selectors = optional(list(object({
      match_labels = optional(map(string), {})
    })), [])
    aggregation_length      = optional(number, 32)
    aggregation_length_v6   = optional(number, 128)
    local_pref              = optional(number, null)
    communities             = optional(list(string), [])
  }))
  default = []
  validation {
    condition     = length(var.bgp_advertisements) >= 0
    error_message = "BGP广告配置列表必须有效"
  }
}
