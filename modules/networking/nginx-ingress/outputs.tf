output "nginx_ingress_url" {
  description = "NGINX Ingress controller URL"
  value = var.service_type == "LoadBalancer" ? "http://${helm_release.this.status[0].load_balancer[0].ingress[0].ip}" : "http://${helm_release.this.name}-controller.${var.namespace}"
}

output "nginx_ingress_ip" {
  description = "NGINX Ingress LoadBalancer IP"
  value       = var.service_type == "LoadBalancer" ? helm_release.this.status[0].load_balancer[0].ingress[0].ip : null
}

output "nginx_ingress_service_name" {
  description = "NGINX Ingress service name"
  value       = helm_release.this.name
}

output "nginx_ingress_namespace" {
  description = "NGINX Ingress namespace"
  value       = var.namespace
}

output "nginx_ingress_class_name" {
  description = "NGINX Ingress class name"
  value       = var.ingress_class_name
}

output "nginx_ingress_version" {
  description = "NGINX Ingress chart version"
  value       = helm_release.this.metadata[0].app_version
}

output "nginx_ingress_controller_name" {
  description = "NGINX Ingress controller deployment name"
  value       = "${helm_release.this.name}-controller"
}

output "nginx_ingress_default_backend_name" {
  description = "NGINX Ingress default backend name"
  value       = "${helm_release.this.name}-default-backend"
}

output "nginx_ingress_metrics_enabled" {
  description = "Whether metrics are enabled"
  value       = var.metrics_enabled
}

output "nginx_ingress_admission_webhooks_enabled" {
  description = "Whether admission webhooks are enabled"
  value       = var.admission_webhooks_enabled
}
