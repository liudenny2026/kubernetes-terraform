output "namespace" {
  description = "Namespace where cp-kafka is installed"
  value       = var.namespace
}

output "release_name" {
  description = "Helm release name"
  value       = helm_release.cp-kafka.name
}

output "service_name" {
  description = "cp-kafka service name"
  value       = "${var.release_name}"
}
