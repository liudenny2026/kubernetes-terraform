# ============================================================================
# Production Environment - Variables
# ============================================================================

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "prod"
}

variable "component" {
  description = "Component name"
  type        = string
  default     = "cloud-native"
}

variable "tags" {
  description = "Standard tags to apply to all resources"
  type        = map(string)
  default = {
    Environment  = "prod"
    CostCenter   = "12345"
    Security     = "cloud-native"
    ManagedBy    = "terraform"
    Project      = "cloud-native-infrastructure"
  }
}

variable "versions" {
  description = "Component versions"
  type        = map(string)
  default = {
    metallb    = "v0.15.3"
  }
}

# 集群连接配置
variable "kubeconfig_path" {
  description = "Path to kubeconfig file for production cluster"
  type        = string
  default     = "~/.kube/config"
}

variable "config_context" {
  description = "Kubernetes config context name for production cluster"
  type        = string
  default     = "prod.kubernetes.cluster"
}

# MetalLB配置
variable "metallb_ip_ranges" {
  description = "IP address ranges for MetalLB load balancer"
  type        = list(string)
  default     = ["192.168.40.200-192.168.40.250"]
}
