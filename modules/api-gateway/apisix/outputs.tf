output "namespace" {
  description = "Namespace where apisix is installed"
  value       = var.namespace
}

output "release_name" {
  description = "Helm release name"
  value       = helm_release.apisix.name
}

output "service_name" {
  description = "apisix service name"
  value       = "${var.release_name}"
}
