# ============================================================================
# Resource Layer: CoreDNS Deployment
# 三级架构: 资源层 - 单个Kubernetes资源定义
# ============================================================================

resource "kubernetes_deployment" "coredns" {
  metadata {
    name      = var.name
    namespace = var.namespace
    labels    = var.labels
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = {
        app = var.labels.app
        component = var.labels.component
      }
    }

    template {
      metadata {
        labels = var.labels
      }

      spec {
        service_account_name = var.service_account

        affinity {
          pod_anti_affinity {
            preferred_during_scheduling_ignored_during_execution {
              weight = 100
              pod_affinity_term {
                label_selector {
                  match_labels = {
                    app = var.labels.app
                  }
                }
                topology_key = "kubernetes.io/hostname"
              }
            }
          }
        }

        container {
          name  = "coredns"
          image = var.image

          args = [
            "-conf",
            "/etc/coredns/Corefile"
          ]

          resources {
            requests = {
              cpu    = var.cpu_request
              memory = var.memory_request
            }
            limits = {
              cpu    = var.cpu_limit
              memory = var.memory_limit
            }
          }

          liveness_probe {
            http_get {
              path = "/health"
              port = 8080
              scheme = "HTTP"
            }
            initial_delay_seconds = 60
            timeout_seconds       = 5
            success_threshold     = 1
            failure_threshold     = 5
            period_seconds        = 10
          }

          readiness_probe {
            http_get {
              path = "/ready"
              port = 8181
              scheme = "HTTP"
            }
            initial_delay_seconds = 0
            timeout_seconds       = 5
            success_threshold     = 1
            failure_threshold     = 3
            period_seconds        = 10
          }

          port {
            name           = "dns"
            container_port = 53
            protocol       = "UDP"
          }

          port {
            name           = "dns-tcp"
            container_port = 53
            protocol       = "TCP"
          }

          port {
            name           = "metrics"
            container_port = 9153
            protocol       = "TCP"
          }

          security_context {
            allow_privilege_escalation = false
            capabilities {
              drop = ["all"]
            }
            read_only_root_filesystem = true
          }

          volume_mount {
            name       = "config-volume"
            mount_path = "/etc/coredns"
            read_only  = true
          }
        }

        dns_policy = "Default"

        volume {
          name = "config-volume"
          config_map {
            name = "${var.name}-configmap"
            items {
              key   = "Corefile"
              path  = "Corefile"
              mode  = "0644"
            }
          }
        }
      }
    }
  }
}
