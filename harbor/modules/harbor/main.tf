# 模块：创建 Harbor 所需的 PV 和 PVC
# 文件：modules/pvcs/main.tf

# Harbor 数据库 PVC
resource "kubernetes_persistent_volume_claim_v1" "harbor_database" {
  metadata {
    name      = "harbor-database-data"
    namespace = var.namespace
  }

  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = var.pvc_size
      }
    }
    storage_class_name = var.database_storage_class
  }

  wait_until_bound = false
}

# Harbor Redis PVC
resource "kubernetes_persistent_volume_claim_v1" "harbor_redis" {
  metadata {
    name      = "harbor-redis-data"
    namespace = var.namespace
  }

  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = var.pvc_size
      }
    }
    storage_class_name = var.redis_storage_class
  }

  wait_until_bound = false
}

# Harbor Registry PVC
resource "kubernetes_persistent_volume_claim_v1" "harbor_registry" {
  metadata {
    name      = "harbor-registry-data"
    namespace = var.namespace
  }

  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "50Gi"  # Registry 通常需要更多空间
      }
    }
    storage_class_name = var.registry_storage_class
  }

  wait_until_bound = false
}

# Harbor ChartMuseum PVC
resource "kubernetes_persistent_volume_claim_v1" "harbor_chartmuseum" {
  metadata {
    name      = "harbor-chartmuseum"
    namespace = var.namespace
  }

  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = var.pvc_size
      }
    }
    storage_class_name = var.storage_class
  }

  wait_until_bound = false
}