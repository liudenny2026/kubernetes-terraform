# ============================================================================
# Kyverno Module - Variables
# 命名规范: ${var.environment}-${var.naming_prefix}-kyverno-${resource_type}
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
  description = "Namespace for Kyverno deployment"
  type        = string
  default     = "kyverno"
}

variable "kyverno_version" {
  description = "Kyverno version"
  type        = string
  default     = "v1.12.0"
}

variable "replicas" {
  description = "Number of Kyverno replicas"
  type        = number
  default     = 3
}

variable "create_self_signed_cert" {
  description = "Create self-signed certificate"
  type        = bool
  default     = true
}

variable "enable_policy_reporting" {
  description = "Enable policy reporting"
  type        = bool
  default     = true
}

variable "enable_admission_reports" {
  description = "Enable admission reports"
  type        = bool
  default     = true
}

variable "background_scan_enabled" {
  description = "Enable background scanning"
  type        = bool
  default     = true
}

variable "background_scan_interval" {
  description = "Background scan interval in hours"
  type        = number
  default     = 1
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

variable "exclude_namespaces" {
  description = "Namespaces to exclude from policies"
  type        = list(string)
  default     = ["kube-system", "kyverno"]
}

variable "log_level" {
  description = "Kyverno log level"
  type        = string
  default     = "info"
}
