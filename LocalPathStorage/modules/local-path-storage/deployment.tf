# Local-Path-Provisioner Deployment配置

# 创建Deployment
resource "kubernetes_deployment_v1" "local_path_provisioner" {
  metadata {
    name      = "local-path-provisioner"
    namespace = kubernetes_namespace_v1.local_path_storage.metadata[0].name
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = {
        app = "local-path-provisioner"
      }
    }

    template {
      metadata {
        labels = {
          app = "local-path-provisioner"
        }
      }

      spec {
        service_account_name = kubernetes_service_account_v1.local_path_provisioner.metadata[0].name

        dynamic "image_pull_secrets" {
          for_each = var.docker_registry_enabled ? concat(["${kubernetes_secret_v1.docker_registry[0].metadata[0].name}"], var.image_pull_secrets) : var.image_pull_secrets
          content {
            name = image_pull_secrets.value
          }
        }

        container {
          name              = "local-path-provisioner"
          image             = var.provisioner_image
          image_pull_policy = "IfNotPresent"

          command = [
            "local-path-provisioner",
            "--debug",
            "start",
            "--config",
            "/etc/config/config.json"
          ]

          env {
            name = "POD_NAMESPACE"
            value_from {
              field_ref {
                field_path = "metadata.namespace"
              }
            }
          }

          env {
            name  = "CONFIG_MOUNT_PATH"
            value = "/etc/config/"
          }

          volume_mount {
            name       = "config-volume"
            mount_path = "/etc/config/"
          }
        }

        volume {
          name = "config-volume"
          config_map {
            name = kubernetes_config_map_v1.local_path_config.metadata[0].name
          }
        }
      }
    }
  }
}