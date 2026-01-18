# ============================================================================
# CoreDNS Module - Variables
# 标准命名规范: {env}-{component}-coredns-{resource-type}
# ============================================================================

variable "environment" {
  description = "Environment name (dev/stage/prod)"
  type        = string
  default     = "prod"
  validation {
    condition     = contains(["dev", "stage", "prod"], var.environment)
    error_message = "Environment must be dev, stage, or prod."
  }
}

variable "component" {
  description = "Component name for naming prefix"
  type        = string
  default     = "cloud-native"
}

variable "namespace" {
  description = "Namespace for CoreDNS deployment"
  type        = string
  default     = "kube-system"
}

variable "coredns_version" {
  description = "CoreDNS image version"
  type        = string
  default     = "1.11.1"
}

variable "coredns_replicas" {
  description = "Number of CoreDNS replicas"
  type        = number
  default     = 2
  validation {
    condition     = var.coredns_replicas >= 1
    error_message = "Replicas must be at least 1."
  }
}

variable "coredns_cpu_request" {
  description = "CoreDNS CPU request"
  type        = string
  default     = "200m"
}

variable "coredns_cpu_limit" {
  description = "CoreDNS CPU limit"
  type        = string
  default     = "200m"
}

variable "coredns_memory_request" {
  description = "CoreDNS memory request"
  type        = string
  default     = "140Mi"
}

variable "coredns_memory_limit" {
  description = "CoreDNS memory limit"
  type        = string
  default     = "170Mi"
}

variable "cluster_domain" {
  description = "Cluster domain"
  type        = string
  default     = "cluster.local"
}

variable "upstream_dns_servers" {
  description = "Upstream DNS servers"
  type        = list(string)
  default     = ["8.8.8.8", "8.8.4.4"]
  validation {
    condition     = length(var.upstream_dns_servers) > 0
    error_message = "At least one upstream DNS server must be specified."
  }
}

variable "tags" {
  description = "Standard security tags: Environment, CostCenter, Security, ManagedBy, Project"
  type        = map(string)
  default = {
    Environment  = "prod"
    CostCenter   = "12345"
    Security     = "cloud-native"
    ManagedBy    = "terraform"
    Project      = "kubernetes-infra"
  }
}

variable "enable_stub_domains" {
  description = "Enable stub domains configuration"
  type        = bool
  default     = false
}

variable "stub_domains" {
  description = "Stub domains configuration"
  type        = map(list(string))
  default     = {}
}
