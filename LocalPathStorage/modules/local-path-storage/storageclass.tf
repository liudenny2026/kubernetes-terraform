# Local-Path-Provisioner StorageClass配置

# 创建StorageClass
resource "kubernetes_storage_class_v1" "local_path" {
  metadata {
    name = var.storage_class_name
    annotations = {
      "storageclass.kubernetes.io/is-default-class" = var.is_default_storage_class ? "true" : "false"
    }
  }

  storage_provisioner    = "rancher.io/local-path"
  volume_binding_mode    = "WaitForFirstConsumer"
  reclaim_policy         = "Delete"
  allow_volume_expansion = false
}