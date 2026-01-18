output "namespace" {
  description = "Namespace where redis is installed"
  value       = var.namespace
}

output "release_name" {
  description = "Helm release name"
  value       = helm_release.redis.name
}

output "service_name" {
  description = "redis service name"
  value       = "${var.release_name}"
}
