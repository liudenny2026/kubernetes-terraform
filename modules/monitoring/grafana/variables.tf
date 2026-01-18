variable "release_name" {
  type        = string
  default     = "grafana"
  description = "Helm release name"
}

variable "namespace" {
  type        = string
  default     = "monitoring"
  description = "Kubernetes namespace"
}

variable "create_namespace" {
  type        = bool
  default     = true
  description = "Create namespace if not exists"
}

variable "environment" {
  type        = string
  default     = "prod"
  description = "Environment label"
}

variable "repository" {
  type        = string
  default     = "https://grafana.github.io/helm-charts"
  description = "Helm chart repository"
}

variable "chart" {
  type        = string
  default     = "grafana"
  description = "Helm chart name"
}

variable "chart_version" {
  type        = string
  default     = "11.4.1"
  description = "Helm chart version"
}

variable "replica_count" {
  type        = number
  default     = 1
  description = "Number of replicas"
}

variable "persistence_enabled" {
  type        = bool
  default     = true
  description = "Enable persistent storage"
}

variable "persistence_size" {
  type        = string
  default     = "10Gi"
  description = "Persistence storage size"
}

variable "service_type" {
  type        = string
  default     = "ClusterIP"
  description = "Kubernetes service type"
}

variable "service_port" {
  type        = number
  default     = 3000
  description = "Grafana service port"
}

variable "admin_user" {
  type        = string
  default     = "admin"
  description = "Grafana admin username"
}

variable "admin_password" {
  type        = string
  default     = ""
  description = "Grafana admin password (empty for auto-generated)"
  sensitive   = true
}

variable "plugins" {
  type        = string
  default     = ""
  description = "Grafana plugins to install (comma separated)"
}

variable "timeout" {
  type        = number
  default     = 300
  description = "Timeout for Helm release"
}

variable "custom_values" {
  type        = string
  default     = ""
  description = "Custom values YAML"
}

variable "extra_settings" {
  type = list(object({
    name  = string
    value = string
  }))
  default     = []
  description = "Extra Helm settings"
}

variable "prometheus_datasource_enabled" {
  type        = bool
  default     = true
  description = "Enable Prometheus datasource"
}

variable "prometheus_datasource_url" {
  type        = string
  default     = "http://prometheus-operated.monitoring.svc.cluster.local:9090"
  description = "Prometheus datasource URL"
}
