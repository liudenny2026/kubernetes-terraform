# 三级架构 - 模块�?# MinIO模块输出

# MinIO S3端点
output "endpoint" {
  value = "http://${kubernetes_service.minio.default[0].metadata[0].name}.${var.namespace}.svc.cluster.local:9000"
  description = "MinIO S3 API端点"
}

# MinIO控制台URL
output "console_url" {
  value = "http://${kubernetes_service.minio_console.default[0].metadata[0].name}.${var.namespace}.svc.cluster.local:9001"
  description = "MinIO控制台URL"
}

# MinIO命名空间
output "namespace" {
  value = kubernetes_namespace.minio.metadata[0].name
  description = "MinIO部署命名空间"
}

# MinIO版本
output "version" {
  value = var.version
  description = "部署的MinIO版本"
}

# MinIO访问密钥
output "access_key" {
  value = random_password.minio_access_key.result
  description = "MinIO访问密钥"
  sensitive = true
}

# MinIO秘密密钥
output "secret_key" {
  value = random_password.minio_secret_key.result
  description = "MinIO秘密密钥"
  sensitive = true
}

# 获取MinIO服务信息
resource "kubernetes_service" "minio" {
  depends_on = [helm_release.minio]
  metadata {
    name      = "${var.environment}-${var.component}-minio"
    namespace = var.namespace
  }
}

# 获取MinIO控制台服务信�?resource "kubernetes_service" "minio_console" {
  depends_on = [helm_release.minio]
  metadata {
    name      = "${var.environment}-${var.component}-minio-console"
    namespace = var.namespace
  }
}
