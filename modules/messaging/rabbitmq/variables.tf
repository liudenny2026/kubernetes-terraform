variable "instance_name" {
  description = "Instance name for resources"
  type        = string
  default     = "rabbitmq"
}

variable "release_name" {
  description = "Helm release name"
  type        = string
  default     = "rabbitmq"
}

variable "chart_version" {
  description = "RabbitMQ Helm chart version"
  type        = string
  default     = "12.12.7"
}

variable "namespace" {
  description = "Namespace to install RabbitMQ"
  type        = string
  default     = "rabbitmq"
}

variable "create_namespace" {
  description = "Create namespace if not exists"
  type        = bool
  default     = true
}

variable "rabbitmq_username" {
  description = "RabbitMQ admin username"
  type        = string
  default     = "admin"
}

variable "create_secret" {
  description = "Create RabbitMQ secret"
  type        = bool
  default     = true
}

variable "rabbitmq_secret_name" {
  description = "RabbitMQ secret name"
  type        = string
  default     = "rabbitmq-secret"
}

variable "replica_count" {
  description = "Number of replicas"
  type        = number
  default     = 1
}

variable "image_tag" {
  description = "RabbitMQ image tag"
  type        = string
  default     = "3.13-management"
}

variable "persistence_enabled" {
  description = "Enable persistence"
  type        = bool
  default     = true
}

variable "persistence_size" {
  description = "Persistence size"
  type        = string
  default     = "8Gi"
}

variable "storage_class" {
  description = "Storage class name"
  type        = string
  default     = ""
}

variable "service_type" {
  description = "Kubernetes service type"
  type        = string
  default     = "ClusterIP"
}

variable "amqp_port" {
  description = "AMQP port"
  type        = number
  default     = 5672
}

variable "management_port" {
  description = "Management UI port"
  type        = number
  default     = 15672
}

variable "enable_metrics" {
  description = "Enable Prometheus metrics"
  type        = bool
  default     = true
}

variable "enable_service_monitor" {
  description = "Enable Prometheus ServiceMonitor"
  type        = bool
  default     = false
}

variable "memory_request" {
  description = "Memory request"
  type        = string
  default     = "256Mi"
}

variable "cpu_request" {
  description = "CPU request"
  type        = string
  default     = "250m"
}

variable "memory_limit" {
  description = "Memory limit"
  type        = string
  default     = "1Gi"
}

variable "cpu_limit" {
  description = "CPU limit"
  type        = string
  default     = "1000m"
}

variable "topology_spread_constraints_enabled" {
  description = "Enable topology spread constraints"
  type        = bool
  default     = true
}

variable "topology_spread_max_skew" {
  description = "Maximum skew for topology spread"
  type        = number
  default     = 1
}

variable "ingress_enabled" {
  description = "Enable ingress"
  type        = bool
  default     = false
}

variable "ingress_hostname" {
  description = "Ingress hostname"
  type        = string
  default     = "rabbitmq.local"
}

variable "ingress_tls" {
  description = "Enable TLS for ingress"
  type        = bool
  default     = false
}

variable "cert_manager_enabled" {
  description = "Use cert-manager for TLS"
  type        = bool
  default     = false
}

variable "load_balancer_enabled" {
  description = "Enable load balancer"
  type        = bool
  default     = false
}

variable "extra_sets" {
  description = "Extra Helm set values"
  type = list(object({
    name  = string
    value = string
    type  = optional(string)
  }))
  default = []
}

variable "timeout" {
  description = "Timeout for Helm release"
  type        = number
  default     = 600
}

variable "kubeconfig_path" {
  description = "Path to kubeconfig file"
  type        = string
  default     = ""
}
