# Terraform variables for Harbor deployment
variable "kube_config_path" {
  description = "Kubernetes 配置文件路径"
  type        = string
  default     = ""
}

variable "loadbalancer_ip" {
  description = "Harbor LoadBalancer 外部 IP (可选，留空自动分配)"
  type        = string
  default     = ""
}

variable "harbor_chart_version" {
  description = "Harbor Helm Chart 版本"
  type        = string
  default     = "1.18.1"
}

variable "storage_class" {
  description = "存储类名称"
  type        = string
  default     = "local-path"
}

variable "harbor_namespace" {
  description = "Harbor 命名空间"
  type        = string
  default     = "harbor"
}
