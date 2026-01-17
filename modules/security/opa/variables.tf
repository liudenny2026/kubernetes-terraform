# ============================================================================
# OPA Gatekeeper Module - Variables
# 命名规范: ${var.environment}-${var.naming_prefix}-opa-${resource_type}
# ============================================================================

variable "environment" {
  description = "Environment name (dev/stage/prod)"
  type        = string
  default     = "prod"
}

variable "naming_prefix" {
  description = "Naming prefix for resources"
  type        = string
  default     = "cloud-native"
}

variable "namespace" {
  description = "Namespace for OPA Gatekeeper deployment"
  type        = string
  default     = "gatekeeper-system"
}

variable "gatekeeper_version" {
  description = "OPA Gatekeeper version"
  type        = string
  default     = "3.16.0"
}

variable "replicas" {
  description = "Number of OPA Gatekeeper replicas"
  type        = number
  default     = 3
}

variable "audit_interval" {
  description = "Audit interval in seconds"
  type        = number
  default     = 60
}

variable "constraint_enforcement_action" {
  description = "Constraint enforcement action (deny, warn, dryrun)"
  type        = string
  default     = "deny"
}

variable "enable_mutation" {
  description = "Enable mutation webhooks"
  type        = bool
  default     = false
}

variable "enable_external_data" {
  description = "Enable external data feature"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Standard tags to apply to all resources"
  type        = map(string)
  default = {
    Environment  = "prod"
    CostCenter   = "12345"
    Security     = "cloud-native"
  }
}

variable "whitelisted_namespaces" {
  description = "Namespaces to whitelist from constraints"
  type        = list(string)
  default     = ["kube-system", "gatekeeper-system"]
}

variable "log_level" {
  description = "Gatekeeper log level"
  type        = string
  default     = "INFO"
}
