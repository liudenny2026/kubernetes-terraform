# Local-Path-Provisioner模块输出

output "namespace" {
  description = "命名空间名称"
  value       = kubernetes_namespace_v1.local_path_storage.metadata[0].name
}

output "storage_class_name" {
  description = "StorageClass名称"
  value       = kubernetes_storage_class_v1.local_path.metadata[0].name
}

output "provisioner_status" {
  description = "Local-Path-Provisioner状态"
  value       = "Deployment created"
}