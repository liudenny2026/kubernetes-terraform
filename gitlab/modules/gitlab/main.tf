# Create namespace for GitLab
resource "kubernetes_namespace_v1" "gitlab" {
  metadata {
    name = var.namespace
  }
}

# Create secret for GitLab credentials
resource "kubernetes_secret_v1" "gitlab_credentials" {
  metadata {
    name      = "gitlab-credentials"
    namespace = kubernetes_namespace_v1.gitlab.metadata[0].name
  }

  data = {
    # Admin password for initial setup
    admin-password     = var.gitlab_admin_password
    initial-root-pw    = var.gitlab_initial_root_password
  }

  type = "Opaque"
}

# Create PersistentVolumeClaim for GitLab data
resource "kubernetes_persistent_volume_claim_v1" "gitlab" {
  metadata {
    name      = "gitlab-data"
    namespace = kubernetes_namespace_v1.gitlab.metadata[0].name
  }

  spec {
    access_modes       = ["ReadWriteOnce"]
    storage_class_name = var.storage_class
    resources {
      requests = {
        storage = var.pvc_size
      }
    }
  }

  wait_until_bound = false
}

# Create ConfigMap for GitLab configuration
resource "kubernetes_config_map_v1" "gitlab_config" {
  metadata {
    name      = "gitlab-config"
    namespace = kubernetes_namespace_v1.gitlab.metadata[0].name
  }

  data = {
    "gitlab.rb" = <<EOF
# GitLab configuration file
external_url 'http://gitlab.${kubernetes_namespace_v1.gitlab.metadata[0].name}.svc.cluster.local'

# PostgreSQL settings
postgresql['enable'] = true

# Redis settings
redis['enable'] = true

# GitLab Rails settings
gitlab_rails['initial_root_password'] = ENV['GITLAB_ROOT_PASSWORD']

# Storage settings
gitlab_rails['shared_path'] = '/var/opt/gitlab/shared'
gitlab_rails['uploads_directory'] = '/var/opt/gitlab/gitlab-rails/uploads'

# Backup settings
gitlab_rails['backup_path'] = '/var/opt/gitlab/backups'
EOF
  }
}

# Create GitLab deployment
resource "kubernetes_deployment_v1" "gitlab" {
  metadata {
    name      = "gitlab"
    namespace = kubernetes_namespace_v1.gitlab.metadata[0].name
    labels = {
      app = "gitlab"
    }
  }

  spec {
    replicas = var.gitlab_replica_count

    selector {
      match_labels = {
        app = "gitlab"
      }
    }

    template {
      metadata {
        labels = {
          app = "gitlab"
        }
      }

      spec {
        container {
          name  = "gitlab"
          image = var.use_private_registry ? "${var.private_registry_url}/gitlab/gitlab-ce:${var.gitlab_version}-ce.0" : "gitlab/gitlab-ce:${var.gitlab_version}-ce.0"
          
          port {
            container_port = 80
            name           = "http"
          }

          port {
            container_port = 443
            name           = "https"
          }

          port {
            container_port = 22
            name           = "ssh"
          }

          env {
            name  = "GITLAB_ROOT_PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret_v1.gitlab_credentials.metadata[0].name
                key  = "initial-root-pw"
              }
            }
          }
          env {
            name  = "EXTERNAL_URL"
            value = "http://gitlab.${kubernetes_namespace_v1.gitlab.metadata[0].name}.svc.cluster.local"
          }

          volume_mount {
            name       = "gitlab-data"
            mount_path = "/var/opt/gitlab"
          }

          volume_mount {
            name       = "gitlab-data"
            mount_path = "/etc/gitlab"
            sub_path   = "config"
            read_only  = false
          }

          resources {
            requests = {
              cpu    = var.gitlab_resources.requests.cpu
              memory = var.gitlab_resources.requests.memory
            }
            limits = {
              cpu    = var.gitlab_resources.limits.cpu
              memory = var.gitlab_resources.limits.memory
            }
          }

          liveness_probe {
            http_get {
              path = "/"
              port = 80
            }
            initial_delay_seconds = 300
            period_seconds        = 30
            timeout_seconds       = 10
            failure_threshold     = 5
          }

          readiness_probe {
            http_get {
              path = "/"
              port = 80
            }
            initial_delay_seconds = 120
            period_seconds        = 10
            timeout_seconds       = 5
            failure_threshold     = 10
          }
        }

        volume {
          name = "gitlab-data"

          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim_v1.gitlab.metadata[0].name
          }
        }

      }
    }
  }

  depends_on = [
    kubernetes_namespace_v1.gitlab,
    kubernetes_persistent_volume_claim_v1.gitlab
  ]
}

# Create GitLab service
resource "kubernetes_service_v1" "gitlab" {
  metadata {
    name      = "gitlab"
    namespace = kubernetes_namespace_v1.gitlab.metadata[0].name
    annotations = {
      "service.beta.kubernetes.io/aws-load-balancer-type" = "nlb"
    }
  }

  spec {
    type = var.service_type

    port {
      name        = "http"
      port        = 80
      target_port = 80
      protocol    = "TCP"
    }

    port {
      name        = "https"
      port        = 443
      target_port = 443
      protocol    = "TCP"
    }

    port {
      name        = "ssh"
      port        = 22
      target_port = 22
      protocol    = "TCP"
    }

    selector = {
      app = kubernetes_deployment_v1.gitlab.spec[0].selector[0].match_labels.app
    }

    session_affinity = "None"
  }

  depends_on = [
    kubernetes_deployment_v1.gitlab
  ]
}

# Create ingress for GitLab if needed
resource "kubernetes_ingress_v1" "gitlab" {
  count = var.service_type == "LoadBalancer" ? 0 : 1

  metadata {
    name      = "gitlab"
    namespace = kubernetes_namespace_v1.gitlab.metadata[0].name
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
      "nginx.ingress.kubernetes.io/proxy-body-size" = "100m"
      "nginx.ingress.kubernetes.io/ssl-redirect" = "false"
    }
  }

  spec {
    rule {
      http {
        path {
          path = "/"
          backend {
            service {
              name = kubernetes_service_v1.gitlab.metadata[0].name
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }

  depends_on = [
    kubernetes_service_v1.gitlab
  ]
}