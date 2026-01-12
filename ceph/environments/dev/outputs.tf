# Outputs for Ceph on Kubernetes deployment

output "ceph_namespace" {
  description = "Namespace where Ceph is deployed"
  value       = var.ceph_namespace
}

output "ceph_cluster_name" {
  description = "Name of the deployed Ceph cluster"
  value       = var.ceph_cluster_name
}

output "ceph_operator_status" {
  description = "Status of the Rook Ceph operator deployment"
  value       = helm_release.rook_ceph_operator.status
}

output "dashboard_service_endpoint" {
  description = "Endpoint for accessing the Ceph dashboard"
  value       = module.ceph_cluster.dashboard_service_endpoint
  depends_on  = [module.ceph_cluster]
}

output "dashboard_username" {
  description = "Username for Ceph dashboard (if applicable)"
  value       = module.ceph_cluster.dashboard_username
  depends_on  = [module.ceph_cluster]
}

output "dashboard_password_secret" {
  description = "Name of the secret containing Ceph dashboard password"
  value       = module.ceph_cluster.dashboard_password_secret
  depends_on  = [module.ceph_cluster]
}