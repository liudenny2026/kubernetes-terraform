output "namespace" {
  description = "Namespace where postgresql is installed"
  value       = var.namespace
}

output "release_name" {
  description = "Helm release name"
  value       = helm_release.postgresql.name
}

output "service_name" {
  description = "postgresql service name"
  value       = "${var.release_name}"
}
