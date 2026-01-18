output "namespace" {
  description = "Namespace where tilt is installed"
  value       = var.namespace
}

output "release_name" {
  description = "Helm release name"
  value       = helm_release.tilt.name
}

output "service_name" {
  description = "tilt service name"
  value       = "${var.release_name}"
}
