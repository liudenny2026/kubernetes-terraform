output "namespace" {
  description = "Namespace where devspace is installed"
  value       = var.namespace
}

output "release_name" {
  description = "Helm release name"
  value       = helm_release.devspace.name
}

output "service_name" {
  description = "devspace service name"
  value       = "${var.release_name}"
}
