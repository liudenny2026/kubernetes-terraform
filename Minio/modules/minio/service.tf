# MinIO Service配置
resource "kubernetes_service_v1" "minio" {
  metadata {
    name      = var.service_name
    namespace = var.namespace
    labels = {
      app = var.app_name
    }
  }

  spec {
    type = var.service_type

    port {
      name        = "api"
      port        = var.minio_api_port
      target_port = var.minio_api_port
      protocol    = "TCP"
    }

    port {
      name        = "console"
      port        = var.minio_console_port
      target_port = var.minio_console_port
      protocol    = "TCP"
    }

    selector = {
      app = var.app_name
    }
  }

  lifecycle {
    ignore_changes = [
      # 忽略选择器变化
      spec[0].selector,
    ]
  }
}
