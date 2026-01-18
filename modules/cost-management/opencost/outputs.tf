output "namespace" {
  description = "Namespace where opencost is installed"
  value       = var.namespace
}

output "release_name" {
  description = "Helm release name"
  value       = helm_release.opencost.name
}

output "service_name" {
  description = "opencost service name"
  value       = "${var.release_name}"
}
