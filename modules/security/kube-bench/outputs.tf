# ============================================================================
# Kube-bench Security Module - Outputs
# ============================================================================

output "kube_bench_namespace" {
  description = "Namespace where Kube-bench is deployed"
  value       = kubernetes_namespace.kube_bench.metadata[0].name
}

output "kube_bench_job_name" {
  description = "Name of the Kube-bench cluster scan job"
  value       = kubernetes_job.kube_bench_cluster_scan.metadata[0].name
}

output "kube_bench_service_account_name" {
  description = "Name of the Kube-bench service account"
  value       = kubernetes_service_account.kube_bench.metadata[0].name
}
