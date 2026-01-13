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

variable "prometheus_repository" {
  description = "Helm repository for Prometheus (Alibaba Cloud for China network)"
  type        = string
  default     = "https://aliacs-app-catalog.oss-cn-hangzhou.aliyuncs.com/charts-incubator/"
}

variable "prometheus_chart_name" {
  description = "Helm chart name for Prometheus stack (ack-prometheus-operator)"
  type        = string
  default     = "ack-prometheus-operator"
}

variable "prometheus_chart_version" {
  description = "Prometheus chart version"
  type        = string
  default     = "65.1.1"
}

variable "grafana_repository" {
  description = "Helm repository for Grafana"
  type        = string
  default     = "https://grafana.github.io/helm-charts"
}

variable "grafana_chart_version" {
  description = "Grafana chart version"
  type        = string
  default     = "7.3.9"
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
  default     = "local-path"
}

variable "registry_mirror" {
  description = "Container registry mirror for China"
  type        = string
  default     = "registry.cn-hangzhou.aliyuncs.com"
}
