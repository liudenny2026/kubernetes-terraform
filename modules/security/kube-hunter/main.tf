# ============================================================================
# Kube-hunter Security Module - Main Configuration
# 三级架构: 资源�?- Security CronJob
# 命名规范: ${var.environment}-${var.naming_prefix}-security-kube-hunter-{resource-type}
# ============================================================================

# 创建命名空间
resource "kubernetes_namespace" "kube_hunter" {
  metadata {
    name = var.namespace
    labels = merge(
      var.tags,
      {
        "name"                          = var.namespace
        "prod-cloud-native-component"  = "kube-hunter"
        "prod-cloud-native-resource"   = "namespace"
      }
    )
  }
}

# 创建Kube-hunter定期扫描CronJob
resource "kubernetes_cron_job" "kube_hunter_scan" {
  metadata {
    name      = "${var.environment}-${var.naming_prefix}-security-kube-hunter-scan"
    namespace = kubernetes_namespace.kube_hunter.metadata[0].name
    labels = merge(
      var.tags,
      {
        "prod-cloud-native-component"  = "kube-hunter"
        "prod-cloud-native-resource"   = "cronjob"
      }
    )
  }

  spec {
    schedule = var.scan_schedule
    concurrency_policy = "Forbid"
    job_template {
      spec {
        template {
          metadata {
            labels = merge(
              var.tags,
              {
                "prod-cloud-native-component"  = "kube-hunter"
                "prod-cloud-native-resource"   = "pod"
              }
            )
          }

          spec {
            host_network    = true
            host_pid        = true
            restart_policy  = "OnFailure"

            containers {
              name  = "kube-hunter"
              image = "${var.image_repository}:${var.image_tag}"
              command = [
                "python3",
                "-m",
                "kube_hunter",
                "--pod",
                "--report",
                "json",
                "--log",
                "INFO"
              ]

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

            service_account_name = kubernetes_service_account.kube_hunter.metadata[0].name
          }
        }
      }
    }
  }
}

# 创建Kube-hunter服务账号
resource "kubernetes_service_account" "kube_hunter" {
  metadata {
    name      = "${var.environment}-${var.naming_prefix}-security-kube-hunter-sa"
    namespace = kubernetes_namespace.kube_hunter.metadata[0].name
    labels = merge(
      var.tags,
      {
        "prod-cloud-native-component"  = "kube-hunter"
        "prod-cloud-native-resource"   = "service-account"
      }
    )
  }
}

# 创建Kube-hunter集群角色
resource "kubernetes_cluster_role" "kube_hunter" {
  metadata {
    name = "${var.environment}-${var.naming_prefix}-security-kube-hunter-cluster-role"
    labels = merge(
      var.tags,
      {
        "prod-cloud-native-component"  = "kube-hunter"
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

# 绑定Kube-hunter集群角色
resource "kubernetes_cluster_role_binding" "kube_hunter" {
  metadata {
    name = "${var.environment}-${var.naming_prefix}-security-kube-hunter-cluster-role-binding"
    labels = merge(
      var.tags,
      {
        "prod-cloud-native-component"  = "kube-hunter"
        "prod-cloud-native-resource"   = "cluster-role-binding"
      }
    )
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.kube_hunter.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.kube_hunter.metadata[0].name
    namespace = kubernetes_namespace.kube_hunter.metadata[0].name
  }
}
