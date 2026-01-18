variable "instance_name" {
  description = "Instance name for resources"
  type        = string
  default     = "cert-manager"
}

variable "release_name" {
  description = "Helm release name"
  type        = string
  default     = "cert-manager"
}

variable "chart_version" {
  description = "Cert-Manager Helm chart version"
  type        = string
  default     = "1.16.2"
}

variable "namespace" {
  description = "Namespace to install cert-manager"
  type        = string
  default     = "cert-manager"
}

variable "create_namespace" {
  description = "Create namespace if not exists"
  type        = bool
  default     = true
}

variable "replica_count" {
  description = "Number of replicas for cert-manager deployment"
  type        = number
  default     = 1
}

variable "image_repository" {
  description = "Docker image repository for cert-manager"
  type        = string
  default     = "quay.io/jetstack/cert-manager-controller"
}

variable "image_tag" {
  description = "Docker image tag for cert-manager"
  type        = string
  default     = "v1.16.2"
}

variable "create_service_account" {
  description = "Create service account for cert-manager"
  type        = bool
  default     = true
}

variable "service_account_name" {
  description = "Service account name for cert-manager"
  type        = string
  default     = "cert-manager"
}

variable "enable_prometheus_monitoring" {
  description = "Enable Prometheus monitoring"
  type        = bool
  default     = true
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

variable "create_letsencrypt_issuer" {
  description = "Create Let's Encrypt ClusterIssuer"
  type        = bool
  default     = false
}

variable "letsencrypt_issuer_name" {
  description = "Name for Let's Encrypt issuer"
  type        = string
  default     = "letsencrypt"
}

variable "letsencrypt_email" {
  description = "Email for Let's Encrypt registration"
  type        = string
  default     = ""
}

variable "letsencrypt_solvers" {
  description = "ACME solvers for Let's Encrypt"
  type = list(object({
    selector = optional(map(string))
    http01 = optional(object({
      ingress = optional(object({
        class = optional(string)
      }))
      service = optional(object({
        name = string
        port  = number
      }))
    }))
    dns01 = optional(object({
      route53 = optional(object({
        region  = string
        accessKeyID = optional(string)
        secretAccessKeySecretRef = object({
          name = string
          key  = string
        })
      }))
      cloudflare = optional(object({
        email = string
        apiTokenSecretRef = object({
          name = string
          key  = string
        })
      }))
    }))
  }))
  default = [
    {
      http01 = {
        ingress = {
          class = "nginx"
        }
      }
    }
  ]
}

variable "create_selfsigned_issuer" {
  description = "Create self-signed Issuer"
  type        = bool
  default     = true
}

variable "selfsigned_issuer_name" {
  description = "Name for self-signed issuer"
  type        = string
  default     = "selfsigned"
}
