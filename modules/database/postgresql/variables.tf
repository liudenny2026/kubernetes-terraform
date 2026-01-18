variable "instance_name" {
  description = "Instance name for resources"
  type        = string
  default     = "postgresql"
}

variable "release_name" {
  description = "Helm release name"
  type        = string
  default     = "postgresql"
}

variable "chart_version" {
  description = "postgresql Helm chart version"
  type        = string
  default     = "15.2.5"
}

variable "namespace" {
  description = "Namespace to install postgresql"
  type        = string
  default     = "postgresql"
}

variable "create_namespace" {
  description = "Create namespace if not exists"
  type        = bool
  default     = true
}

variable "replica_count" {
  description = "Number of replicas"
  type        = number
  default     = 1
}

variable "image_tag" {
  description = "postgresql image tag"
  type        = string
  default     = ""
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

variable "service_type" {
  description = "Kubernetes service type"
  type        = string
  default     = "ClusterIP"
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
