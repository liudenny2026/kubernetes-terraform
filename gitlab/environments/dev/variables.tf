variable "gitlab_version" {
  description = "GitLab version to deploy"
  type        = string
  default     = "18.6.0"
}

variable "namespace" {
  description = "Kubernetes namespace to deploy GitLab"
  type        = string
  default     = "gitlab"
}

variable "storage_class" {
  description = "Storage class to use for persistent volumes"
  type        = string
  default     = "local-path"
}

variable "pvc_size" {
  description = "Size of the persistent volume claim"
  type        = string
  default     = "18Gi"
}

variable "service_type" {
  description = "Type of service to expose GitLab"
  type        = string
  default     = "LoadBalancer"
}

variable "gitlab_admin_password" {
  description = "Password for GitLab admin user"
  type        = string
  sensitive   = true
}

variable "gitlab_initial_root_password" {
  description = "Initial root password for GitLab"
  type        = string
  sensitive   = true
}

variable "gitlab_replica_count" {
  description = "Number of GitLab pod replicas"
  type        = number
  default     = 1
}

variable "use_private_registry" {
  description = "Whether to use private registry for images"
  type        = bool
  default     = true
}

variable "private_registry_url" {
  description = "Private registry URL for pulling images"
  type        = string
  default     = "192.168.40.248/library"
}