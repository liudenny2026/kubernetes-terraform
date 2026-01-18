output "namespace" {
  description = "Namespace where cert-manager is installed"
  value       = var.namespace
}

output "release_name" {
  description = "Helm release name"
  value       = helm_release.cert_manager.name
}

output "status" {
  description = "Status of cert-manager release"
  value       = helm_release.cert_manager.status
}

output "letsencrypt_staging_issuer" {
  description = "Let's Encrypt staging issuer name"
  value       = var.create_letsencrypt_issuer ? "${var.letsencrypt_issuer_name}-staging" : null
}

output "letsencrypt_production_issuer" {
  description = "Let's Encrypt production issuer name"
  value       = var.create_letsencrypt_issuer ? "${var.letsencrypt_issuer_name}-production" : null
}

output "selfsigned_issuer" {
  description = "Self-signed issuer name"
  value       = var.create_selfsigned_issuer ? var.selfsigned_issuer_name : null
}
