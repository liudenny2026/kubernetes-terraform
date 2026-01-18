output "namespace" {
  description = "Namespace where dex is installed"
  value       = var.namespace
}

output "release_name" {
  description = "Helm release name"
  value       = helm_release.dex.name
}

output "service_name" {
  description = "dex service name"
  value       = "${var.release_name}"
}
