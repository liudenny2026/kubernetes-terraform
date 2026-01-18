output "namespace" {
  description = "Namespace where cilium is installed"
  value       = var.namespace
}

output "release_name" {
  description = "Helm release name"
  value       = helm_release.cilium.name
}

output "service_name" {
  description = "cilium service name"
  value       = "${var.release_name}"
}
