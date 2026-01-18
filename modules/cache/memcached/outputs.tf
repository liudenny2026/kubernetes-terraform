output "namespace" {
  description = "Namespace where memcached is installed"
  value       = var.namespace
}

output "release_name" {
  description = "Helm release name"
  value       = helm_release.memcached.name
}

output "service_name" {
  description = "memcached service name"
  value       = "${var.release_name}"
}
