# Dev Environment Variables

variable "kube_config_path" {
  description = "Path to the kubeconfig file"
  type        = string
  default     = "C:/Users/liude/.kube/config"
}

variable "kubeflow_version" {
  description = "Target Kubeflow version for dev environment"
  type        = string
  default     = "1.9.1"
}

variable "deploy_istio" {
  description = "Whether to deploy Istio in dev environment"
  type        = bool
  default     = false
}

variable "istio_version" {
  description = "Istio version for dev environment"
  type        = string
  default     = "1.28.0"
}

variable "cert_manager_version" {
  description = "Cert-Manager version for dev environment"
  type        = string
  default     = "v1.16.1"
}
