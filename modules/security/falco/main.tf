# ============================================================================
# Falco Module - Main Configuration
# 三级架构: 资源�?- Falco Deployment/Service
# 命名规范: prod-cloud-native-falco-{resource-type}
# ============================================================================

resource "kubernetes_namespace" "falco" {
  metadata {
    name = var.namespace
    labels = merge(var.tags, {
      app       = "falco"
      component = "security"
    })
  }
}

resource "kubernetes_config_map" "falco_rules" {
  metadata {
    name      = "${var.environment}-${var.naming_prefix}-falco-rules"
    namespace = var.namespace
    labels = merge(var.tags, {
      app       = "falco"
      component = "security"
    })
  }

  data = {
    "custom_rules.yaml" = join("\n", var.rules)
  }
}

resource "kubernetes_daemonset" "falco" {
  metadata {
    name      = "${var.environment}-${var.naming_prefix}-falco-daemonset"
    namespace = var.namespace
    labels = merge(var.tags, {
      app       = "falco"
      component = "security"
    })
  }

  spec {
    selector {
      match_labels = merge(var.tags, {
        app = "falco"
      })
    }

    template {
      metadata {
        labels = merge(var.tags, {
          app       = "falco"
          component = "security"
        })
      }

      spec {
        service_account_name = "${var.environment}-${var.naming_prefix}-falco-sa"

        toleration {
          key      = "node-role.kubernetes.io/master"
          operator = "Exists"
          effect   = "NoSchedule"
        }

        toleration {
          key      = "node-role.kubernetes.io/control-plane"
          operator = "Exists"
          effect   = "NoSchedule"
        }

        container {
          name  = "falco"
          image = "falcosecurity/falco:${var.falco_version}"

          args = [
            "/usr/bin/falco",
            "--cri",
            "/var/run/containerd/containerd.sock",
            "--json-output",
            "--log-level",
            var.log_level
          ]

          security_context {
            privileged = true
          }

          resources {
            requests = {
              cpu    = var.falco_cpu_request
              memory = var.falco_memory_request
            }
            limits = {
              cpu    = var.falco_cpu_limit
              memory = var.falco_memory_limit
            }
          }

          volume_mount {
            name       = "var-run"
            mount_path = "/var/run"
          }

          volume_mount {
            name       = "host-etc"
            mount_path = "/host/etc"
            read_only  = true
          }

          volume_mount {
            name       = "host-usr"
            mount_path = "/host/usr"
            read_only  = true
          }

          volume_mount {
            name       = "host-boot"
            mount_path = "/host/boot"
            read_only  = true
          }

          volume_mount {
            name       = "lib-modules"
            mount_path = /lib/modules
            read_only  = true
          }

          volume_mount {
            name       = "usr-lib"
            mount_path = /usr/lib
            read_only  = true
          }

          volume_mount {
            name       = "falco-rules"
            mount_path = /etc/falco/rules.d
          }
        }

        volume {
          name = "var-run"
          host_path {
            path = "/var/run"
          }
        }

        volume {
          name = "host-etc"
          host_path {
            path = "/etc"
          }
        }

        volume {
          name = "host-usr"
          host_path {
            path = "/usr"
          }
        }

        volume {
          name = "host-boot"
          host_path {
            path = "/boot"
          }
        }

        volume {
          name = "lib-modules"
          host_path {
            path = "/lib/modules"
          }
        }

        volume {
          name = "usr-lib"
          host_path {
            path = "/usr/lib"
          }
        }

        volume {
          name = "falco-rules"
          config_map {
            name = kubernetes_config_map.falco_rules.metadata[0].name
          }
        }
      }
    }
  }

  depends_on = [kubernetes_namespace.falco]
}

resource "kubernetes_service_account" "falco" {
  metadata {
    name      = "${var.environment}-${var.naming_prefix}-falco-sa"
    namespace = var.namespace
    labels = merge(var.tags, {
      app       = "falco"
      component = "security"
    })
  }
}

resource "kubernetes_cluster_role" "falco" {
  metadata {
    name = "${var.environment}-${var.naming_prefix}-falco-clusterrole"
    labels = merge(var.tags, {
      app       = "falco"
      component = "security"
    })
  }

  rule {
    api_groups = [""]
    resources  = ["pods", "nodes", "nodes/spec"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = ["extensions"]
    resources  = ["deployments", "replicasets", "daemonsets"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = ["apps"]
    resources  = ["deployments", "replicasets", "daemonsets", "statefulsets"]
    verbs      = ["get", "list", "watch"]
  }
}

resource "kubernetes_cluster_role_binding" "falco" {
  metadata {
    name = "${var.environment}-${var.naming_prefix}-falco-clusterrolebinding"
    labels = merge(var.tags, {
      app       = "falco"
      component = "security"
    })
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.falco.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.falco.metadata[0].name
    namespace = var.namespace
  }
}
