# MinIO命名空间
resource "kubernetes_namespace_v1" "minio" {
  metadata {
    name = var.namespace
    labels = {
      name                                         = var.namespace
      app                                          = "minio"
      "pod-security.kubernetes.io/enforce"         = "privileged"
      "pod-security.kubernetes.io/enforce-version" = "latest"
      "pod-security.kubernetes.io/audit"           = "privileged"
      "pod-security.kubernetes.io/audit-version"   = "latest"
      "pod-security.kubernetes.io/warn"            = "privileged"
      "pod-security.kubernetes.io/warn-version"    = "latest"
    }
  }

  lifecycle {
    ignore_changes = [
      # 忽略标签变化，防止现有命名空间的标签被修改
      metadata[0].labels,
    ]
  }
}
