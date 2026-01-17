# ============================================================================
# Kube-bench Security Module - Main Configuration
# 三级架构: 资源�?- Security Job
# 命名规范: ${var.environment}-${var.naming_prefix}-security-kube-bench-{resource-type}
# ============================================================================

# 创建命名空间
resource "kubernetes_namespace" "kube_bench" {
  metadata {
    name = var.namespace
    labels = merge(
      var.tags,
      {
        "name"                          = var.namespace
        "prod-cloud-native-component"  = "kube-bench"
        "prod-cloud-native-resource"   = "namespace"
      }
    )
  }
}

# 创建Kube-bench集群扫描作业
resource "kubernetes_job" "kube_bench_cluster_scan" {
  metadata {
    name      = "${var.environment}-${var.naming_prefix}-security-kube-bench-cluster-scan"
    namespace = kubernetes_namespace.kube_bench.metadata[0].name
    labels = merge(
      var.tags,
      {
        "prod-cloud-native-component"  = "kube-bench"
        "prod-cloud-native-resource"   = "job"
      }
    )
  }

  spec {
    template {
      metadata {
        labels = merge(
          var.tags,
          {
            "prod-cloud-native-component"  = "kube-bench"
            "prod-cloud-native-resource"   = "pod"
          }
        )
      }

      spec {
        host_network    = true
        host_pid        = true
        restart_policy  = "Never"

        containers {
          name  = "kube-bench"
          image = "${var.image_repository}:${var.image_tag}"
          command = [
            "kube-bench",
            "run",
            "--targets",
            "node,master",
            "--output",
            "json"
          ]

          volume_mount {
            name       = "host-etc"
            mount_path = "/etc"
            read_only  = true
          }

          volume_mount {
            name       = "host-var"
            mount_path = "/var"
            read_only  = true
          }

          volume_mount {
            name       = "host-run"
            mount_path = "/run"
            read_only  = true
          }

          volume_mount {
            name       = "host-lib"
            mount_path = "/lib"
            read_only  = true
          }

          volume_mount {
            name       = "host-usr"
            mount_path = "/usr"
            read_only  = true
          }

          resources {
            requests = {
              cpu    = var.resources_requests_cpu
              memory = var.resources_requests_memory
            }

            limits = {
              cpu    = var.resources_limits_cpu
              memory = var.resources_limits_memory
            }
          }
        }

        volumes {
          name = "host-etc"
          host_path {
            path = "/etc"
            type = "Directory"
          }
        }

        volumes {
          name = "host-var"
          host_path {
            path = "/var"
            type = "Directory"
          }
        }

        volumes {
          name = "host-run"
          host_path {
            path = "/run"
            type = "Directory"
          }
        }

        volumes {
          name = "host-lib"
          host_path {
            path = "/lib"
            type = "Directory"
          }
        }

        volumes {
          name = "host-usr"
          host_path {
            path = "/usr"
            type = "Directory"
          }
        }

        service_account_name = kubernetes_service_account.kube_bench.metadata[0].name
        security_context {
          run_as_user = 0
        }
      }
    }
  }
}

# 创建Kube-bench服务账号
resource "kubernetes_service_account" "kube_bench" {
  metadata {
    name      = "${var.environment}-${var.naming_prefix}-security-kube-bench-sa"
    namespace = kubernetes_namespace.kube_bench.metadata[0].name
    labels = merge(
      var.tags,
      {
        "prod-cloud-native-component"  = "kube-bench"
        "prod-cloud-native-resource"   = "service-account"
      }
    )
  }
}

# 创建Kube-bench集群角色
resource "kubernetes_cluster_role" "kube_bench" {
  metadata {
    name = "${var.environment}-${var.naming_prefix}-security-kube-bench-cluster-role"
    labels = merge(
      var.tags,
      {
        "prod-cloud-native-component"  = "kube-bench"
        "prod-cloud-native-resource"   = "cluster-role"
      }
    )
  }

  rule {
    api_groups = ["*"]
    resources  = ["*"]
    verbs      = ["get", "list", "watch"]
  }
}

# 绑定Kube-bench集群角色
resource "kubernetes_cluster_role_binding" "kube_bench" {
  metadata {
    name = "${var.environment}-${var.naming_prefix}-security-kube-bench-cluster-role-binding"
    labels = merge(
      var.tags,
      {
        "prod-cloud-native-component"  = "kube-bench"
        "prod-cloud-native-resource"   = "cluster-role-binding"
      }
    )
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.kube_bench.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.kube_bench.metadata[0].name
    namespace = kubernetes_namespace.kube_bench.metadata[0].name
  }
}
