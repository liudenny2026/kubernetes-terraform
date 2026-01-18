# ============================================================================
# Rook-Ceph Module - Main Configuration
# 三级架构: 资源�?- Rook-Ceph Deployment/Service
# 命名规范: ${var.environment}-${var.naming_prefix}-infra-rook-ceph-{resource-type}
# ============================================================================

# 部署方式选择：false使用Helm部署，true使用原生Kubernetes资源部署
variable "use_helm_deployment" {
  default = false
}

locals {
  deployment_method = var.use_helm_deployment ? "helm" : "native"
}

# 条件部署：根据use_helm_deployment选择部署方式
resource "null_resource" "rook_deployment_selector" {
  count = 1
  provisioner "local-exec" {
    command = "echo Rook-Ceph deployment using ${local.deployment_method} method"
  }
}

# 条件部署：使用Helm方式部署Rook-Ceph
resource "kubernetes_namespace" "rook_ceph_helm" {
  count = var.use_helm_deployment ? 1 : 0
  metadata {
    name = var.rook_namespace
    labels = merge(
      var.tags,
      {
        "name"                          = var.rook_namespace
        "prod-cloud-native-component"  = "rook-ceph"
        "prod-cloud-native-resource"   = "namespace"
      }
    )
  }
}

# 安装Rook-Ceph操作符（Helm方式�?resource "helm_release" "rook_ceph_operator_helm" {
  count      = var.use_helm_deployment ? 1 : 0
  name       = "${var.environment}-${var.naming_prefix}-infra-rook-ceph-operator"
  namespace  = kubernetes_namespace.rook_ceph_helm[0].metadata[0].name
  repository = "https://charts.rook.io/release"
  chart      = "rook-ceph"
  version    = var.rook_version
  timeout    = 600

  set { name = "csi.enableRBD", value = var.enable_rbd ? "true" : "false" }
  set { name = "csi.enableCephFS", value = var.enable_ceph_fs ? "true" : "false" }
  set { name = "csi.enableObjectStore", value = "true" }
  set { name = "csi.rbd.provisioner.replicas", value = 2 }
  set { name = "csi.rbd.plugin.replicas", value = 3 }
  set { name = "csi.cephFS.provisioner.replicas", value = 2 }
  set { name = "csi.cephFS.plugin.replicas", value = 3 }
  set { name = "csi.cinder.plugin.replicas", value = 3 }

  dynamic "set" {
    for_each = var.registry_mirror != "" ? [1] : []
    content {
      name  = "image.repository"
      value = "rook/ceph"
    }
  }

  set { name = "image.tag", value = var.rook_version }

  dynamic "set" {
    for_each = var.registry_mirror != "" ? [1] : []
    content {
      name  = "csi.rbd.provisioner.image.repository"
      value = "rook/csi-rbdplugin-provisioner"
    }
  }

  dynamic "set" {
    for_each = var.registry_mirror != "" ? [1] : []
    content {
      name  = "csi.rbd.plugin.image.repository"
      value = "rook/csi-rbdplugin"
    }
  }

  dynamic "set" {
    for_each = var.registry_mirror != "" ? [1] : []
    content {
      name  = "csi.cephFS.provisioner.image.repository"
      value = "rook/csi-cephfsplugin-provisioner"
    }
  }

  dynamic "set" {
    for_each = var.registry_mirror != "" ? [1] : []
    content {
      name  = "csi.cephFS.plugin.image.repository"
      value = "rook/csi-cephfsplugin"
    }
  }
}

# 安装Rook-Ceph集群（Helm方式�?resource "helm_release" "rook_ceph_cluster_helm" {
  count      = var.use_helm_deployment ? 1 : 0
  name       = "${var.environment}-${var.naming_prefix}-infra-rook-ceph-cluster"
  namespace  = kubernetes_namespace.rook_ceph_helm[0].metadata[0].name
  repository = "https://charts.rook.io/release"
  chart      = "rook-ceph-cluster"
  version    = var.rook_version
  timeout    = 900

  set { name = "cephClusterSpec.dataDirHostPath", value = "/var/lib/rook" }
  set { name = "cephClusterSpec.network.provider", value = "host" }
  set { name = "cephClusterSpec.mon.count", value = var.mon_count }
  set { name = "cephClusterSpec.storage.useAllNodes", value = "true" }
  set { name = "cephClusterSpec.storage.useAllDevices", value = "true" }
  set { name = "cephClusterSpec.storage.config.metadataDevice", value = "" }
  set { name = "cephClusterSpec.storage.deviceFilter", value = "" }
  set { name = "cephClusterSpec.storage.location", value = "" }
  set { name = "cephClusterSpec.storage.config.osdsPerDevice", value = "1" }
  set { name = "cephClusterSpec.storage.config.bluestoreConfig", value = "{\"block_db_size\":\"1073741824\",\"block_wal_size\":\"1073741824\"}" }
  set { name = "cephClusterSpec.storage.nodes", value = "[]" }
  set { name = "cephClusterSpec.monitoring.enabled", value = var.enable_monitoring ? "true" : "false" }
  set { name = "cephClusterSpec.monitoring.rulesNamespace", value = "monitoring" }
  set { name = "cephClusterSpec.logCollector.enabled", value = "true" }
  set { name = "cephClusterSpec.statusCheck.true", value = "true" }

  dynamic "set" {
    for_each = var.registry_mirror != "" ? [1] : []
    content {
      name  = "cephClusterSpec.cephVersion.image"
      value = "ceph/ceph:${var.ceph_version}"
    }
  }
  
  dynamic "set" {
    for_each = var.registry_mirror == "" ? [1] : []
    content {
      name  = "cephClusterSpec.cephVersion.image"
      value = "ceph/ceph:${var.ceph_version}"
    }
  }

  depends_on = [helm_release.rook_ceph_operator_helm]
}

# 条件部署：使用原生Kubernetes资源部署Rook-Ceph
resource "kubernetes_namespace" "rook_ceph" {
  count = var.use_helm_deployment ? 0 : 1
  metadata {
    name = var.rook_namespace
    labels = merge(var.tags, {
      app       = "rook-ceph"
      component = "storage"
    })
  }
}

resource "kubernetes_namespace" "ceph_cluster" {
  count = var.use_helm_deployment ? 0 : 1
  metadata {
    name = var.ceph_cluster_namespace
    labels = merge(var.tags, {
      app       = "ceph-cluster"
      component = "storage"
    })
  }
}

resource "kubernetes_config_map" "rook_operator" {
  count = var.use_helm_deployment ? 0 : 1
  metadata {
    name      = "${var.environment}-${var.naming_prefix}-rook-operator-config"
    namespace = var.rook_namespace
    labels = merge(var.tags, {
      app       = "rook"
      component = "operator"
    })
  }

  data = {
    ROOK_CSI_ENABLE_CEPHFS   = var.enable_ceph_fs ? "true" : "false"
    ROOK_CSI_ENABLE_RBD      = var.enable_rbd ? "true" : "false"
    ROOK_ENABLE_DISCOVERY_DAEMONSET = "true"
  }
}

resource "kubernetes_deployment" "rook_operator" {
  count = var.use_helm_deployment ? 0 : 1
  metadata {
    name      = "${var.environment}-${var.naming_prefix}-rook-operator-deployment"
    namespace = var.rook_namespace
    labels = merge(var.tags, {
      app       = "rook-ceph-operator"
      component = "operator"
    })
  }

  spec {
    replicas = 1

    selector {
      match_labels = merge(var.tags, {
        app = "rook-ceph-operator"
      })
    }

    template {
      metadata {
        labels = merge(var.tags, {
          app       = "rook-ceph-operator"
          component = "operator"
        })
      }

      spec {
        service_account_name = "${var.environment}-${var.naming_prefix}-rook-operator-sa"

        container {
          name  = "rook-ceph-operator"
          image = "rook/ceph:${var.rook_version}"

          args = [
            "ceph",
            "operator"
          ]

          env {
            name  = "ROOK_CURRENT_NAMESPACE_ONLY"
            value = "false"
          }

          env {
            name = "ROOK_LOG_LEVEL"
            value_from {
              config_map_key_ref {
                name = kubernetes_config_map.rook_operator.metadata[0].name
                key  = "ROOK_LOG_LEVEL"
              }
            }
          }

          env {
            name = "ROOK_CSI_ENABLE_CEPHFS"
            value_from {
              config_map_key_ref {
                name = kubernetes_config_map.rook_operator.metadata[0].name
                key  = "ROOK_CSI_ENABLE_CEPHFS"
              }
            }
          }

          env {
            name = "ROOK_CSI_ENABLE_RBD"
            value_from {
              config_map_key_ref {
                name = kubernetes_config_map.rook_operator.metadata[0].name
                key  = "ROOK_CSI_ENABLE_RBD"
              }
            }
          }

          resources {
            requests = {
              cpu    = "100m"
              memory = "512Mi"
            }
            limits = {
              cpu    = "500m"
              memory = "1Gi"
            }
          }

          security_context {
            run_as_non_root = true
            run_as_user     = 2016
          }

          volume_mount {
            name       = "rook-config"
            mount_path = "/etc/rook"
          }
        }

        volume {
          name = "rook-config"
          config_map {
            name = kubernetes_config_map.rook_operator.metadata[0].name
          }
        }
      }
    }
  }

  depends_on = [kubernetes_namespace.rook_ceph]
}

resource "kubernetes_service_account" "rook_operator" {
  count = var.use_helm_deployment ? 0 : 1
  metadata {
    name      = "${var.environment}-${var.naming_prefix}-rook-operator-sa"
    namespace = var.rook_namespace
    labels = merge(var.tags, {
      app       = "rook"
      component = "operator"
    })
  }
}

resource "kubernetes_cluster_role" "rook_operator" {
  count = var.use_helm_deployment ? 0 : 1
  metadata {
    name = "${var.environment}-${var.naming_prefix}-rook-operator-clusterrole"
    labels = merge(var.tags, {
      app       = "rook"
      component = "operator"
    })
  }

  rule {
    api_groups = [""]
    resources  = ["pods", "nodes", "nodes/status"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = [""]
    resources  = ["configmaps", "endpoints"]
    verbs      = ["get", "list", "watch", "create", "update", "delete"]
  }

  rule {
    api_groups = ["storage.k8s.io"]
    resources  = ["storageclasses"]
    verbs      = ["get", "list", "watch"]
  }
}

resource "kubernetes_cluster_role_binding" "rook_operator" {
  count = var.use_helm_deployment ? 0 : 1
  metadata {
    name = "${var.environment}-${var.naming_prefix}-rook-operator-clusterrolebinding"
    labels = merge(var.tags, {
      app       = "rook"
      component = "operator"
    })
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.rook_operator[0].metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.rook_operator[0].metadata[0].name
    namespace = var.rook_namespace
  }
}

resource "kubernetes_manifest" "ceph_cluster" {
  count = var.use_helm_deployment ? 0 : 1
  manifest = {
    apiVersion = "ceph.rook.io/v1"
    kind       = "CephCluster"
    metadata = {
      name      = "${var.environment}-${var.naming_prefix}-ceph-cluster"
      namespace = var.ceph_cluster_namespace
      labels = merge(var.tags, {
        app       = "ceph"
        component = "cluster"
      })
    }
    spec = {
      cephVersion = {
        image = "ceph/ceph:${var.ceph_version}"
      }
      dataDirHostPath = "/var/lib/rook"
      mon = {
        count = var.mon_count
        allowMultiplePerNode = false
      }
      mgr = {
        count = var.mgr_count
        modules = [
          { name = "pg_autoscaler", enabled = true }
        ]
      }
      dashboard = {
        enabled = var.enable_dashboard
        port    = var.dashboard_port
        ssl     = true
      }
      monitoring = {
        enabled = var.enable_monitoring
      }
      storage = {
        useAllNodes = false
        useAllDevices = false
        deviceFilter = var.storage_device
        config = {
          databaseSizeMB = "1024"
          journalSizeMB  = "1024"
        }
        nodes = [
          {
            name = "node1"
            devices = [
              { name = var.storage_device }
            ]
          }
        ]
      }
    }
  }

  depends_on = [
    kubernetes_deployment.rook_operator[0],
    kubernetes_namespace.ceph_cluster[0]
  ]
}
