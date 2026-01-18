output "namespace" {
  description = "Namespace where mysql is installed"
  value       = var.namespace
}

output "release_name" {
  description = "Helm release name"
  value       = helm_release.mysql.name
}

output "service_name" {
  description = "mysql service name"
  value       = "${var.release_name}"
}
