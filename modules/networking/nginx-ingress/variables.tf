variable "release_name" {
  type        = string
  default     = "ingress-nginx"
  description = "Helm release name"
}

variable "namespace" {
  type        = string
  default     = "ingress-nginx"
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
  default     = "https://kubernetes.github.io/ingress-nginx"
  description = "Helm chart repository"
}

variable "chart" {
  type        = string
  default     = "ingress-nginx"
  description = "Helm chart name"
}

variable "chart_version" {
  type        = string
  default     = "4.10.0"
  description = "Helm chart version"
}

variable "replica_count" {
  type        = number
  default     = 2
  description = "Number of controller replicas"
}

variable "service_type" {
  type        = string
  default     = "LoadBalancer"
  description = "Kubernetes service type"
}

variable "load_balancer_ip" {
  type        = string
  default     = ""
  description = "Static LoadBalancer IP"
}

variable "ingress_class_name" {
  type        = string
  default     = "nginx"
  description = "Ingress class name"
}

variable "ingress_class_enabled" {
  type        = bool
  default     = true
  description = "Create IngressClass resource"
}

variable "ingress_class_default" {
  type        = bool
  default     = true
  description = "Set as default IngressClass"
}

variable "metrics_enabled" {
  type        = bool
  default     = true
  description = "Enable Prometheus metrics"
}

variable "admission_webhooks_enabled" {
  type        = bool
  default     = true
  description = "Enable admission webhooks"
}

variable "service_annotations" {
  type        = map(string)
  default     = {}
  description = "Service annotations"
}

variable "resources_cpu_request" {
  type        = string
  default     = "100m"
  description = "CPU request"
}

variable "resources_memory_request" {
  type        = string
  default     = "256Mi"
  description = "Memory request"
}

variable "resources_cpu_limit" {
  type        = string
  default     = "500m"
  description = "CPU limit"
}

variable "resources_memory_limit" {
  type        = string
  default     = "512Mi"
  description = "Memory limit"
}

variable "node_selector" {
  type        = map(string)
  default     = {}
  description = "Node selector for controller pods"
}

variable "tolerations" {
  type        = list(map(string))
  default     = []
  description = "Tolerations for controller pods"
}

variable "affinity" {
  type        = map(string)
  default     = {}
  description = "Affinity rules for controller pods"
}

variable "timeout" {
  type        = number
  default     = 300
  description = "Timeout for Helm release"
}

variable "wait_duration" {
  type        = string
  default     = "60s"
  description = "Duration to wait for ingress to be ready"
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
