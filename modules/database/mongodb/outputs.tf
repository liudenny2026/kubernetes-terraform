output "namespace" {
  description = "Namespace where mongodb is installed"
  value       = var.namespace
}

output "release_name" {
  description = "Helm release name"
  value       = helm_release.mongodb.name
}

output "service_name" {
  description = "mongodb service name"
  value       = "${var.release_name}"
}
