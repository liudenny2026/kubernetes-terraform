# ============================================================================
# Rook-Ceph Module - Outputs
# ============================================================================

output "rook_namespace" {
  description = "Rook namespace"
  value       = kubernetes_namespace.rook_ceph.metadata[0].name
}

output "ceph_cluster_namespace" {
  description = "Ceph cluster namespace"
  value       = kubernetes_namespace.ceph_cluster.metadata[0].name
}

output "rook_operator_deployment_name" {
  description = "Rook operator deployment name"
  value       = kubernetes_deployment.rook_operator.metadata[0].name
}

output "ceph_cluster_name" {
  description = "Ceph cluster name"
  value       = kubernetes_manifest.ceph_cluster.manifest.metadata.name
}

output "ceph_fs_enabled" {
  description = "CephFS enabled"
  value       = var.enable_ceph_fs
}

output "rbd_enabled" {
  description = "RBD enabled"
  value       = var.enable_rbd
}

output "dashboard_url" {
  description = "Ceph dashboard URL"
  value       = var.enable_dashboard ? "https://rook-ceph-dashboard.${var.ceph_cluster_namespace}.svc:8443" : ""
}
