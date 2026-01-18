output "namespace" {
  description = "Namespace where cost-analyzer is installed"
  value       = var.namespace
}

output "release_name" {
  description = "Helm release name"
  value       = helm_release.cost-analyzer.name
}

output "service_name" {
  description = "cost-analyzer service name"
  value       = "${var.release_name}"
}
