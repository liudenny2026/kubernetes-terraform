output "namespace" {
  description = "Namespace where kong is installed"
  value       = var.namespace
}

output "release_name" {
  description = "Helm release name"
  value       = helm_release.kong.name
}

output "service_name" {
  description = "kong service name"
  value       = "${var.release_name}"
}
