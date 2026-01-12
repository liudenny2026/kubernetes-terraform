# Local-Path-Provisioner根模块输出

output "namespace" {
  description = "命名空间名称"
  value       = module.local_path_storage.namespace
}

output "storage_class_name" {
  description = "StorageClass名称"
  value       = module.local_path_storage.storage_class_name
}

output "provisioner_status" {
  description = "Local-Path-Provisioner状态"
  value       = module.local_path_storage.provisioner_status
}