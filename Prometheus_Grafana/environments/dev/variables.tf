variable "kubeconfig_path" {
  description = "Path to kubeconfig file"
  type        = string
  default     = "~/.kube/config"
}

variable "namespace" {
  description = "Namespace for monitoring stack"
  type        = string
  default     = "monitoring"
}

variable "enable_istio_monitoring" {
  description = "Enable Istio monitoring"
  type        = bool
  default     = true
}

variable "enable_ceph_monitoring" {
  description = "Enable Ceph monitoring"
  type        = bool
  default     = true
}

variable "enable_metallb_monitoring" {
  description = "Enable MetalLB monitoring"
  type        = bool
  default     = true
}

variable "enable_kubeflow_monitoring" {
  description = "Enable Kubeflow monitoring"
  type        = bool
  default     = true
}

variable "enable_mlflow_monitoring" {
  description = "Enable MLflow monitoring"
  type        = bool
  default     = true
}

variable "enable_minio_monitoring" {
  description = "Enable MinIO monitoring"
  type        = bool
  default     = true
}

variable "storage_class" {
  description = "Storage class for persistent storage"
  type        = string
  default     = "standard"
}

variable "registry_mirror" {
  description = "Container registry mirror for China"
  type        = string
  default     = "docker.mirrors.ustc.edu.cn"
}
