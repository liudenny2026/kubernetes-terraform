output "namespace" {
  description = "Namespace where elasticsearch is installed"
  value       = var.namespace
}

output "release_name" {
  description = "Helm release name"
  value       = helm_release.elasticsearch.name
}

output "service_name" {
  description = "elasticsearch service name"
  value       = "${var.release_name}"
}
