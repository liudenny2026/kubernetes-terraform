# ============================================================================
# Falco Module - Variables
# 命名规范: ${var.environment}-${var.naming_prefix}-falco-${resource_type}
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
  description = "Namespace for Falco deployment"
  type        = string
  default     = "falco"
}

variable "falco_version" {
  description = "Falco version"
  type        = string
  default     = "0.38.0"
}

variable "falco_cpu_request" {
  description = "Falco CPU request"
  type        = string
  default = '200m'
}

variable "falco_memory_request" {
  description = "Falco memory request"
  type        = string
  default = '1024Mi'
}

variable "falco_cpu_limit" {
  description = "Falco CPU limit"
  type        = string
  default = '2000m'
}

variable "falco_memory_limit" {
  description = "Falco memory limit"
  type        = string
  default = '4Gi'
}

variable "enable_auditd" {
  description = "Enable auditd integration"
  type        = bool
  default     = true
}

variable "enable_syslog" {
  description = "Enable syslog output"
  type        = bool
  default     = false
}

variable "enable_stdout" {
  description = "Enable stdout output"
  type        = bool
  default     = true
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

variable "rules" {
  description = "Custom Falco rules"
  type        = list(string)
  default     = []
}

variable "log_level" {
  description = "Falco log level"
  type        = string
  default     = "info"
}
