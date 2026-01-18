output "namespace" {
  description = "Namespace where RabbitMQ is installed"
  value       = var.namespace
}

output "release_name" {
  description = "Helm release name"
  value       = helm_release.rabbitmq.name
}

output "service_name" {
  description = "RabbitMQ service name"
  value       = "${var.release_name}"
}

output "username" {
  description = "RabbitMQ username"
  value       = var.rabbitmq_username
}

output "password" {
  description = "RabbitMQ password"
  value       = random_password.rabbitmq_password.result
  sensitive   = true
}

output "amqp_url" {
  description = "RabbitMQ AMQP URL"
  value       = "amqp://${var.rabbitmq_username}:${random_password.rabbitmq_password.result}@${var.release_name}.${var.namespace}.svc.cluster.local:${var.amqp_port}"
  sensitive   = true
}

output "management_url" {
  description = "RabbitMQ Management UI URL"
  value       = "http://${var.release_name}.${var.namespace}.svc.cluster.local:${var.management_port}"
}

output "external_url" {
  description = "RabbitMQ external URL"
  value       = var.ingress_enabled ? (var.ingress_tls ? "https://${var.ingress_hostname}" : "http://${var.ingress_hostname}") : null
}
