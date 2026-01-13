variable "kube_config_path" {
  description = "Path to kubeconfig file"
  type        = string
  default     = "~/.kube/config"
}

variable "namespace" {
  description = "Namespace to deploy ArgoCD"
  type        = string
  default     = "argocd"
}

variable "chart_version" {
  description = "ArgoCD Helm chart version"
  type        = string
  default     = "5.33.0"
}

variable "image_repository" {
  description = "ArgoCD image repository"
  type        = string
  default     = "registry.cn-hangzhou.aliyuncs.com/argoproj"
}

variable "values" {
  description = "Additional values to pass to Helm chart"
  type        = map(any)
  default     = {}
}