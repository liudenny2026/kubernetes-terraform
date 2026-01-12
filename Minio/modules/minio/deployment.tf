# MinIO Secret配置
resource "kubernetes_secret_v1" "minio" {
  metadata {
    name      = var.secret_name
    namespace = var.namespace
    labels = {
      app = var.app_name
    }
  }

  type = "Opaque"

  data = {
    "rootUser"           = var.minio_root_user_b64
    "rootPassword"       = var.minio_root_password_b64
    "CONSOLE_ACCESS_KEY" = var.minio_root_user_b64
    "CONSOLE_SECRET_KEY" = var.minio_root_password_b64
  }

  lifecycle {
    create_before_destroy = true
  }
}

# MinIO Deployment配置
resource "kubernetes_deployment_v1" "minio" {
  metadata {
    name      = var.deployment_name
    namespace = var.namespace
    labels = {
      app = var.app_name
    }
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = {
        app = var.app_name
      }
    }

    strategy {
      type = "RollingUpdate"
      rolling_update {
        max_surge       = "25%"
        max_unavailable = "0"
      }
    }

    revision_history_limit = 10
    min_ready_seconds      = 10

    template {
      metadata {
        labels = {
          app = var.app_name
        }
        annotations = {
          "prometheus.io/scrape" = "true"
          "prometheus.io/port"   = "9000"
          "prometheus.io/path"   = "/minio/v2/metrics/cluster"
        }
      }

      spec {
        affinity {
          pod_anti_affinity {
            preferred_during_scheduling_ignored_during_execution {
              weight = 100

              pod_affinity_term {
                label_selector {
                  match_labels = {
                    app = var.app_name
                  }
                }
                topology_key = "kubernetes.io/hostname"
              }
            }
          }
        }

        security_context {
          run_as_user            = var.minio_user_id
          run_as_group           = var.minio_group_id
          fs_group               = var.minio_group_id
          fs_group_change_policy = "OnRootMismatch"
        }

        container {
          name              = var.app_name
          image             = var.minio_image
          image_pull_policy = "IfNotPresent"

          command = ["/bin/bash"]
          args    = ["-c", "mkdir -p /data/.minio && minio server /data --console-address \":9001\""]

          port {
            name           = "api"
            container_port = var.minio_api_port
            protocol       = "TCP"
          }

          port {
            name           = "console"
            container_port = var.minio_console_port
            protocol       = "TCP"
          }

          env {
            name = "MINIO_ROOT_USER"
            value_from {
              secret_key_ref {
                name = kubernetes_secret_v1.minio.metadata[0].name
                key  = "rootUser"
              }
            }
          }

          env {
            name = "MINIO_ROOT_PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret_v1.minio.metadata[0].name
                key  = "rootPassword"
              }
            }
          }

          env {
            name  = "MINIO_SERVER_URL"
            value = "http://${var.service_name}.${var.namespace}.svc.cluster.local:${var.minio_api_port}"
          }

          env {
            name  = "MINIO_BROWSER_REDIRECT_URL"
            value = "http://${var.service_name}.${var.namespace}.svc.cluster.local:${var.minio_console_port}"
          }

          resources {
            limits = {
              cpu    = var.minio_cpu_limit
              memory = var.minio_memory_limit
            }
            requests = {
              cpu    = var.minio_cpu_request
              memory = var.minio_memory_request
            }
          }

          security_context {
            allow_privilege_escalation = false
            capabilities {
              drop = ["ALL"]
            }
            read_only_root_filesystem = false
            run_as_non_root           = true
            run_as_user               = var.minio_user_id
            seccomp_profile {
              type = "RuntimeDefault"
            }
          }

          volume_mount {
            name       = "data"
            mount_path = "/data"
          }

          liveness_probe {
            http_get {
              path = "/minio/health/live"
              port = var.minio_api_port
            }
            initial_delay_seconds = 30
            period_seconds        = 20
            timeout_seconds       = 5
            failure_threshold     = 3
          }

          readiness_probe {
            http_get {
              path = "/minio/health/ready"
              port = var.minio_api_port
            }
            initial_delay_seconds = 10
            period_seconds        = 10
            timeout_seconds       = 5
            failure_threshold     = 3
          }

          startup_probe {
            http_get {
              path = "/minio/health/live"
              port = var.minio_api_port
            }
            initial_delay_seconds = 30
            period_seconds        = 10
            timeout_seconds       = 5
            failure_threshold     = 30
          }
        }

        toleration {
          key      = "node-role.kubernetes.io/control-plane"
          operator = "Exists"
          effect   = "NoSchedule"
        }

        toleration {
          key      = "node-role.kubernetes.io/master"
          operator = "Exists"
          effect   = "NoSchedule"
        }

        node_selector = {
          "kubernetes.io/hostname" = var.node_name
        }

        volume {
          name = "data"
          persistent_volume_claim {
            claim_name = var.pvc_name
          }
        }
      }
    }
  }
}
