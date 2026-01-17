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

# Istio and Cert Manager variables removed
# These components should be deployed separately if needed
