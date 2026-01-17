# ============================================================================
# Kube-hunter Security Module - Outputs
# ============================================================================

output "kube_hunter_namespace" {
  description = "Namespace where Kube-hunter is deployed"
  value       = kubernetes_namespace.kube_hunter.metadata[0].name
}

output "kube_hunter_cronjob_name" {
  description = "Name of the Kube-hunter cron job"
  value       = kubernetes_cron_job.kube_hunter_scan.metadata[0].name
}

output "kube_hunter_service_account_name" {
  description = "Name of the Kube-hunter service account"
  value       = kubernetes_service_account.kube_hunter.metadata[0].name
}

output "kube_hunter_scan_schedule" {
  description = "Scan schedule (cron expression)"
  value       = var.scan_schedule
}
