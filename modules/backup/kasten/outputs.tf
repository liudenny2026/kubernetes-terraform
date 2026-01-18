output "namespace" {
  description = "Namespace where k10 is installed"
  value       = var.namespace
}

output "release_name" {
  description = "Helm release name"
  value       = helm_release.k10.name
}

output "service_name" {
  description = "k10 service name"
  value       = "${var.release_name}"
}
