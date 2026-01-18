variable "instance_name" {
  description = "Instance name for resources"
  type        = string
  default     = "velero"
}

variable "release_name" {
  description = "Helm release name"
  type        = string
  default     = "velero"
}

variable "chart_version" {
  description = "Velero Helm chart version"
  type        = string
  default     = "5.0.0"
}

variable "namespace" {
  description = "Namespace to install Velero"
  type        = string
  default     = "velero"
}

variable "create_namespace" {
  description = "Create namespace if not exists"
  type        = bool
  default     = true
}

variable "cloud_provider" {
  description = "Cloud provider (aws, azure, gcp, minio)"
  type        = string
  default     = "aws"
}

variable "region" {
  description = "Cloud provider region"
  type        = string
  default     = "us-east-1"
}

variable "backup_storage_location_name" {
  description = "Backup storage location name"
  type        = string
  default     = "default"
}

variable "backup_bucket_name" {
  description = "Backup bucket name"
  type        = string
  default     = ""
}

variable "backup_prefix" {
  description = "Backup prefix"
  type        = string
  default     = "velero"
}

variable "snapshot_location_name" {
  description = "Snapshot location name"
  type        = string
  default     = "default"
}

variable "snapshot_bucket_name" {
  description = "Snapshot bucket name"
  type        = string
  default     = ""
}

variable "create_s3_secret" {
  description = "Create S3 credentials secret"
  type        = bool
  default     = false
}

variable "s3_credentials_secret_name" {
  description = "S3 credentials secret name"
  type        = string
  default     = "velero-s3-credentials"
}

variable "s3_access_key_id" {
  description = "S3 access key ID"
  type        = string
  default     = ""
  sensitive   = true
}

variable "s3_secret_access_key" {
  description = "S3 secret access key"
  type        = string
  default     = ""
  sensitive   = true
}

variable "create_azure_secret" {
  description = "Create Azure credentials secret"
  type        = bool
  default     = false
}

variable "azure_credentials_secret_name" {
  description = "Azure credentials secret name"
  type        = string
  default     = "velero-azure-credentials"
}

variable "azure_subscription_id" {
  description = "Azure subscription ID"
  type        = string
  default     = ""
  sensitive   = true
}

variable "azure_tenant_id" {
  description = "Azure tenant ID"
  type        = string
  default     = ""
  sensitive   = true
}

variable "azure_client_id" {
  description = "Azure client ID"
  type        = string
  default     = ""
  sensitive   = true
}

variable "azure_client_secret" {
  description = "Azure client secret"
  type        = string
  default     = ""
  sensitive   = true
}

variable "create_gcs_secret" {
  description = "Create GCS credentials secret"
  type        = bool
  default     = false
}

variable "gcs_credentials_secret_name" {
  description = "GCS credentials secret name"
  type        = string
  default     = "velero-gcs-credentials"
}

variable "gcs_credentials" {
  description = "GCS service account credentials"
  type        = string
  default     = ""
  sensitive   = true
}

variable "create_service_account" {
  description = "Create service account"
  type        = bool
  default     = true
}

variable "service_account_name" {
  description = "Service account name"
  type        = string
  default     = "velero"
}

variable "plugin_image_aws" {
  description = "AWS plugin image"
  type        = string
  default     = "velero/velero-plugin-for-aws:v1.8.0"
}

variable "plugin_image_csi" {
  description = "CSI plugin image"
  type        = string
  default     = "velero/velero-plugin-for-csi:v0.6.0"
}

variable "image_repository" {
  description = "Velero image repository"
  type        = string
  default     = "velero/velero"
}

variable "image_tag" {
  description = "Velero image tag"
  type        = string
  default     = "v1.12.0"
}

variable "upgrade_crds" {
  description = "Upgrade CRDs"
  type        = bool
  default     = true
}

variable "install_crds" {
  description = "Install CRDs"
  type        = bool
  default     = true
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

variable "enable_snapshots" {
  description = "Enable volume snapshots"
  type        = bool
  default     = true
}

variable "memory_request" {
  description = "Memory request"
  type        = string
  default     = "256Mi"
}

variable "cpu_request" {
  description = "CPU request"
  type        = string
  default     = "500m"
}

variable "memory_limit" {
  description = "Memory limit"
  type        = string
  default     = "512Mi"
}

variable "cpu_limit" {
  description = "CPU limit"
  type        = string
  default     = "1000m"
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

variable "schedule_name" {
  description = "Backup schedule name"
  type        = string
  default     = "daily-backup"
}

variable "schedule_cron" {
  description = "Backup schedule cron expression"
  type        = string
  default     = "0 2 * * *"
}

variable "backup_ttl" {
  description = "Backup retention period"
  type        = string
  default     = "720h"
}

variable "backup_included_namespaces" {
  description = "Included namespaces for backup"
  type        = list(string)
  default     = ["*"]
}

variable "use_restic" {
  description = "Use Restic for backups"
  type        = bool
  default     = true
}

variable "kubeconfig_path" {
  description = "Path to kubeconfig file"
  type        = string
  default     = ""
}
