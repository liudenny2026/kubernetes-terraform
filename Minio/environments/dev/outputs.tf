# 根模块输出

output "namespace" {
  description = "命名空间"
  value       = module.minio.namespace
}

output "minio_api_endpoint" {
  description = "MinIO API访问端点"
  value       = module.minio.minio_api_endpoint
}

output "minio_console_endpoint" {
  description = "MinIO控制台访问端点"
  value       = module.minio.minio_console_endpoint
}

output "minio_credentials" {
  description = "MinIO访问凭证"
  sensitive   = true
  value = {
    username = var.minio_root_user
    password = var.minio_root_password
  }
}

output "storage_info" {
  description = "存储信息"
  value = {
    storage_class_name = module.minio.storage_class_name
    pv_name            = module.minio.pv_name
    pvc_name           = module.minio.pvc_name
    storage_capacity   = var.storage_capacity
  }
}

output "deployment_info" {
  description = "部署信息"
  value = {
    deployment_name = module.minio.deployment_name
    service_name    = module.minio.service_name
    secret_name     = module.minio.secret_name
    replicas        = var.minio_replicas
  }
}
