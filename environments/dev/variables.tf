# ============================================================================
# Development Environment - Variables
# ============================================================================

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "naming_prefix" {
  description = "Naming prefix for resources"
  type        = string
  default     = "cloud-native"
}

variable "tags" {
  description = "Standard tags to apply to all resources"
  type        = map(string)
  default = {
    Environment  = "dev"
    CostCenter   = "12345"
    Security     = "cloud-native"
    ManagedBy    = "terraform"
    Project      = "cloud-native-infrastructure"
  }
}

variable "versions" {
  description = "Component versions"
  type        = map(string)
  default = {
    istio      = "1.28.0"
    rook_ceph  = "v1.14.0"
    minio      = "RELEASE.2024-01-16T16-07-38Z"
    harbor     = "1.15.0"
    prometheus = "15.12.0"
    grafana    = "7.3.9"
    calico     = "3.28.0"
    metallb    = "v0.15.3"
    coredns    = "1.11.1"
  }
}

variable "minio_secret_key" {
  description = "MinIO secret key"
  type        = string
  sensitive   = true
  default     = "minioadmin"
}

variable "mlflow_password" {
  description = "MLflow PostgreSQL password"
  type        = string
  sensitive   = true
  default     = "mlflow-password"
}

variable "argocd_password" {
  description = "ArgoCD admin password"
  type        = string
  sensitive   = true
  default     = "argocd-password"
}
