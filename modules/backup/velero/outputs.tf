output "namespace" {
  description = "Namespace where Velero is installed"
  value       = var.namespace
}

output "release_name" {
  description = "Helm release name"
  value       = helm_release.velero.name
}

output "service_name" {
  description = "Velero service name"
  value       = "${var.release_name}"
}

output "backup_bucket" {
  description = "Backup bucket name"
  value       = var.backup_bucket_name
}

output "schedule_name" {
  description = "Backup schedule name"
  value       = var.schedule_name
}

output "backup_ttl" {
  description = "Backup retention period"
  value       = var.backup_ttl
}
