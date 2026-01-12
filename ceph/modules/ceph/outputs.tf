# Outputs for Ceph cluster module

output "dashboard_service_endpoint" {
  description = "Endpoint for accessing the Ceph dashboard"
  value = length(kubernetes_service.dashboard_lb) > 0 ? (
    kubernetes_service.dashboard_lb[0].status[0].load_balancer[0].ingress[0].ip != "" ? (
      "https://${kubernetes_service.dashboard_lb[0].status[0].load_balancer[0].ingress[0].ip}:8443"
    ) : "LoadBalancer pending..."
  ) : var.ingress_enabled ? "https://${var.ingress_host}" : "rook-ceph-mgr-dashboard.${var.namespace}.svc.cluster.local:8443"
}

output "dashboard_username" {
  description = "Username for Ceph dashboard (default is admin)"
  value       = "admin"
}

output "dashboard_password" {
  description     = "Password for Ceph dashboard"
  value           = random_password.dashboard_password.result
  sensitive       = true
}

output "cluster_status" {
  description = "Status of the Ceph cluster deployment"
  value       = null_resource.ceph_cluster.triggers.cluster_config
}

output "storage_class_name" {
  description = "Name of the created RBD storage class"
  value       = "${var.cluster_name}-blockstorage"
}

output "filesystem_name" {
  description = "Name of the created Ceph filesystem"
  value       = "${var.cluster_name}-filesystem"
}

output "object_store_name" {
  description = "Name of the created Ceph object store"
  value       = "${var.cluster_name}-objectstore"
}