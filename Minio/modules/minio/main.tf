# MinIO模块主配置文件

# 导入或创建存储类
resource "kubernetes_storage_class_v1" "minio" {
  metadata {
    name = var.storage_class_name
    annotations = {
      "storageclass.kubernetes.io/is-default-class" = "false"
    }
  }

  storage_provisioner    = "kubernetes.io/no-provisioner"
  volume_binding_mode    = "WaitForFirstConsumer"
  reclaim_policy         = "Retain"
  allow_volume_expansion = true

  allowed_topologies {
    match_label_expressions {
      key    = "kubernetes.io/hostname"
      values = [var.node_name]
    }
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      # 忽略某些属性变化
      metadata[0].annotations,
    ]
  }
}

# PV配置 - 40G
resource "kubernetes_persistent_volume_v1" "minio" {
  metadata {
    name = var.pv_name
  }

  spec {
    capacity = {
      storage = var.storage_capacity
    }

    access_modes = ["ReadWriteOnce"]

    persistent_volume_reclaim_policy = "Retain"
    storage_class_name               = var.storage_class_name

    persistent_volume_source {
      local {
        path = var.storage_path
      }
    }

    node_affinity {
      required {
        node_selector_term {
          match_expressions {
            key      = "kubernetes.io/hostname"
            operator = "In"
            values   = [var.node_name]
          }
        }
      }
    }
  }

  lifecycle {
    ignore_changes = [
      # 忽略容量和存储类的变化，避免PV被重新创建
      spec[0].capacity,
      spec[0].storage_class_name,
    ]
  }
}

# PVC配置
resource "kubernetes_persistent_volume_claim_v1" "minio" {
  metadata {
    name      = var.pvc_name
    namespace = var.namespace
  }

  spec {
    access_modes       = ["ReadWriteOnce"]
    storage_class_name = var.storage_class_name

    resources {
      requests = {
        storage = var.storage_capacity
      }
    }
  }

  lifecycle {
    ignore_changes = [
      # 忽略存储容量变化，避免PVC被重新创建
      spec[0].resources,
    ]
  }
}
