# MinIO模块输出

output "namespace" {
  description = "命名空间名称"
  value       = var.namespace
}

output "storage_class_name" {
  description = "StorageClass名称"
  value       = kubernetes_storage_class_v1.minio.metadata[0].name
}

output "pv_name" {
  description = "PersistentVolume名称"
  value       = kubernetes_persistent_volume_v1.minio.metadata[0].name
}

output "pvc_name" {
  description = "PersistentVolumeClaim名称"
  value       = kubernetes_persistent_volume_claim_v1.minio.metadata[0].name
}

output "deployment_name" {
  description = "Deployment名称"
  value       = kubernetes_deployment_v1.minio.metadata[0].name
}

output "service_name" {
  description = "Service名称"
  value       = kubernetes_service_v1.minio.metadata[0].name
}

output "secret_name" {
  description = "Secret名称"
  value       = kubernetes_secret_v1.minio.metadata[0].name
}

output "minio_api_endpoint" {
  description = "MinIO API访问端点"
  value       = "http://${kubernetes_service_v1.minio.metadata[0].name}.${var.namespace}.svc.cluster.local:${var.minio_api_port}"
}

output "minio_console_endpoint" {
  description = "MinIO控制台访问端点"
  value       = "http://${kubernetes_service_v1.minio.metadata[0].name}.${var.namespace}.svc.cluster.local:${var.minio_console_port}"
}
