variable "instance_name" {
  description = "Instance name for resources"
  type        = string
  default     = "keycloak"
}

variable "release_name" {
  description = "Helm release name"
  type        = string
  default     = "keycloak"
}

variable "chart_version" {
  description = "Keycloak Helm chart version"
  type        = string
  default     = "15.0.6"
}

variable "namespace" {
  description = "Namespace to install Keycloak"
  type        = string
  default     = "keycloak"
}

variable "create_namespace" {
  description = "Create namespace if not exists"
  type        = bool
  default     = true
}

variable "admin_user" {
  description = "Keycloak admin username"
  type        = string
  default     = "admin"
}

variable "admin_password" {
  description = "Keycloak admin password"
  type        = string
  sensitive   = true
  default     = ""
}

variable "create_admin_user" {
  description = "Create admin user"
  type        = bool
  default     = true
}

variable "create_admin_secret" {
  description = "Create admin password secret"
  type        = bool
  default     = false
}

variable "replica_count" {
  description = "Number of replicas for Keycloak"
  type        = number
  default     = 1
}

variable "image_tag" {
  description = "Keycloak Docker image tag"
  type        = string
  default     = "24.0.2"
}

variable "service_type" {
  description = "Kubernetes service type"
  type        = string
  default     = "ClusterIP"
}

variable "http_port" {
  description = "HTTP port"
  type        = number
  default     = 80
}

variable "https_port" {
  description = "HTTPS port"
  type        = number
  default     = 8443
}

variable "http_node_port" {
  description = "HTTP node port"
  type        = number
  default     = 30080
}

variable "https_node_port" {
  description = "HTTPS node port"
  type        = number
  default     = 30443
}

variable "ingress_enabled" {
  description = "Enable ingress"
  type        = bool
  default     = false
}

variable "ingress_hostname" {
  description = "Ingress hostname"
  type        = string
  default     = "keycloak.local"
}

variable "ingress_class_name" {
  description = "Ingress class name"
  type        = string
  default     = "nginx"
}

variable "ingress_tls" {
  description = "Enable TLS for ingress"
  type        = bool
  default     = false
}

variable "ingress_self_signed" {
  description = "Use self-signed certificate for ingress"
  type        = bool
  default     = false
}

variable "ingress_annotations" {
  description = "Ingress annotations"
  type        = map(string)
  default     = {}
}

variable "proxy_address" {
  description = "Keycloak proxy address"
  type        = string
  default     = "0.0.0.0"
}

variable "proxy_hostname" {
  description = "Keycloak proxy hostname"
  type        = string
  default     = ""
}

variable "database_vendor" {
  description = "Database vendor"
  type        = string
  default     = "postgresql"
}

variable "create_database" {
  description = "Create PostgreSQL database"
  type        = bool
  default     = true
}

variable "create_db_secret" {
  description = "Create database password secret"
  type        = bool
  default     = false
}

variable "db_persistence_enabled" {
  description = "Enable database persistence"
  type        = bool
  default     = true
}

variable "db_storage_size" {
  description = "Database storage size"
  type        = string
  default     = "8Gi"
}

variable "db_memory_request" {
  description = "Database memory request"
  type        = string
  default     = "256Mi"
}

variable "db_cpu_request" {
  description = "Database CPU request"
  type        = string
  default     = "250m"
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

variable "production_mode" {
  description = "Enable production mode"
  type        = bool
  default     = false
}

variable "memory_request" {
  description = "Memory request"
  type        = string
  default     = "512Mi"
}

variable "cpu_request" {
  description = "CPU request"
  type        = string
  default     = "500m"
}

variable "memory_limit" {
  description = "Memory limit"
  type        = string
  default     = "2Gi"
}

variable "cpu_limit" {
  description = "CPU limit"
  type        = string
  default     = "2000m"
}

variable "timeout" {
  description = "Timeout for Helm release"
  type        = number
  default     = 600
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

variable "set_list" {
  description = "Helm set list values"
  type = list(object({
    name  = string
    value = list(string)
  }))
  default = []
}

variable "set_sensitive" {
  description = "Helm set sensitive values"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "create_realm" {
  description = "Create initial realm"
  type        = bool
  default     = false
}

variable "realm_name" {
  description = "Realm name"
  type        = string
  default     = "master"
}

variable "realm_display_name" {
  description = "Realm display name"
  type        = string
  default     = "Master Realm"
}

variable "realm_theme" {
  description = "Realm theme"
  type        = string
  default     = "keycloak"
}

variable "realm_ssl_required" {
  description = "Require SSL for realm"
  type        = string
  default     = "external"
}

variable "kubeconfig_path" {
  description = "Path to kubeconfig file"
  type        = string
  default     = ""
}
