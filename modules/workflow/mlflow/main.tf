# ============================================================================
# MLflow Module - Main Configuration
# 三级架构: 资源�?- MLflow Deployment/Service
# 命名规范: prod-cloud-native-mlflow-{resource-type}
# ============================================================================

locals {
  # Use common database connection parameters if advanced database config is enabled
  db_hostname = var.use_advanced_db_config ? var.db_hostname : "${var.environment}-${var.naming_prefix}-mlflow-postgres"
  db_port     = var.use_advanced_db_config ? var.db_port : "5432"
  db_username = var.use_advanced_db_config ? var.db_username : var.postgres_user
  db_password = var.use_advanced_db_config ? var.db_password : var.postgres_password
  db_name     = var.use_advanced_db_config ? var.db_name : var.postgres_db
}

resource "kubernetes_namespace" "mlflow" {
  metadata {
    name = var.namespace
    labels = merge(var.tags, {
      app       = "mlflow"
      component = "workflow"
    })
  }
}

# MLflow PostgreSQL Secret
resource "kubernetes_secret" "mlflow_db" {
  metadata {
    name      = "${var.environment}-${var.naming_prefix}-mlflow-db-secret"
    namespace = var.namespace
    labels = merge(var.tags, {
      app       = "mlflow"
      component = "workflow"
    })
  }

  data = {
    postgres-password = var.postgres_password
    postgres-user     = var.postgres_user
    postgres-db       = var.postgres_db
  }

  type = "Opaque"

  depends_on = [kubernetes_namespace.mlflow]
}

# Deploy PostgreSQL database (only if internal DB is enabled)
resource "kubernetes_deployment" "mlflow_postgres" {
  count = var.enable_internal_postgres ? 1 : 0

  metadata {
    name      = "${var.environment}-${var.naming_prefix}-mlflow-postgres"
    namespace = var.namespace
    labels = merge(var.tags, {
      app       = "mlflow-postgres"
      component = "workflow"
    })
  }

  spec {
    replicas = var.postgres_replicas

    selector {
      match_labels = merge(var.tags, {
        app = "mlflow-postgres"
      })
    }

    template {
      metadata {
        labels = merge(var.tags, {
          app = "mlflow-postgres"
        })
      }

      spec {
        container {
          name  = "postgres"
          image = "${var.postgres_image_repository}:${var.postgres_image_tag}"
          image_pull_policy = var.image_pull_policy

          port {
            container_port = 5432
          }

          env {
            name = "POSTGRES_PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.mlflow_db.metadata[0].name
                key  = "postgres-password"
              }
            }
          }

          env {
            name = "POSTGRES_USER"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.mlflow_db.metadata[0].name
                key  = "postgres-user"
              }
            }
          }

          env {
            name = "POSTGRES_DB"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.mlflow_db.metadata[0].name
                key  = "postgres-db"
              }
            }
          }

          env {
            name  = "PGDATA"
            value = "/var/lib/postgresql/data/pgdata"
          }

          resources {
            requests = {
              cpu    = var.postgres_cpu_request
              memory = var.postgres_memory_request
            }
            limits = {
              cpu    = var.postgres_cpu_limit
              memory = var.postgres_memory_limit
            }
          }

          volume_mount {
            name       = "postgres-storage"
            mount_path = "/var/lib/postgresql/data"
          }
        }

        dynamic "volume" {
          for_each = var.use_persistent_storage ? [1] : []
          content {
            name = "postgres-storage"
            persistent_volume_claim {
              claim_name = kubernetes_persistent_volume_claim.postgres_storage[0].metadata[0].name
            }
          }
        }
        dynamic "volume" {
          for_each = var.use_persistent_storage ? [] : [1]
          content {
            name = "postgres-storage"
            empty_dir {
              medium = "Memory"
            }
          }
        }
      }
    }
  }

  depends_on = [kubernetes_secret.mlflow_db]
}

# PostgreSQL Persistent Volume Claim
resource "kubernetes_persistent_volume_claim" "postgres_storage" {
  count = var.enable_internal_postgres && var.use_persistent_storage ? 1 : 0
  
  metadata {
    name      = "${var.environment}-${var.naming_prefix}-mlflow-postgres-storage"
    namespace = var.namespace
    labels = merge(var.tags, {
      app       = "mlflow-postgres"
      component = "workflow"
    })
  }

  spec {
    access_modes = ["ReadWriteOnce"]
    storage_class_name = var.postgres_storage_class != "" ? var.postgres_storage_class : var.storage_class

    resources {
      requests = {
        storage = var.postgres_storage_size
      }
    }
  }
}

# PostgreSQL Service
resource "kubernetes_service" "mlflow_postgres" {
  count = var.enable_internal_postgres ? 1 : 0
  
  metadata {
    name      = "${var.environment}-${var.naming_prefix}-mlflow-postgres"
    namespace = var.namespace
    labels = merge(var.tags, {
      app       = "mlflow-postgres"
      component = "workflow"
    })
  }

  spec {
    selector = merge(var.tags, {
      app = "mlflow-postgres"
    })

    port {
      port        = 5432
      target_port = 5432
    }

    type = var.postgres_service_type
  }

  depends_on = [kubernetes_deployment.mlflow_postgres]
}

# MLflow Artifacts Persistent Volume Claim
resource "kubernetes_persistent_volume_claim" "mlflow_artifacts" {
  count = var.use_persistent_storage ? 1 : 0

  metadata {
    name      = "${var.environment}-${var.naming_prefix}-mlflow-artifacts"
    namespace = var.namespace
    labels = merge(var.tags, {
      app       = "mlflow"
      component = "workflow"
    })
  }

  spec {
    access_modes = ["ReadWriteOnce"]
    storage_class_name = var.artifact_storage_class != "" ? var.artifact_storage_class : var.storage_class

    resources {
      requests = {
        storage = var.artifact_storage_size
      }
    }
  }
}

resource "kubernetes_deployment" "mlflow" {
  metadata {
    name      = "${var.environment}-${var.naming_prefix}-mlflow-deployment"
    namespace = var.namespace
    labels = merge(var.tags, {
      app       = "mlflow"
      component = "workflow"
    })
  }

  spec {
    replicas = var.mlflow_replicas

    selector {
      match_labels = merge(var.tags, {
        app = "mlflow-server"
      })
    }

    template {
      metadata {
        labels = merge(var.tags, {
          app = "mlflow-server"
        })
      }

      spec {
        service_account_name = "${var.environment}-${var.naming_prefix}-mlflow-sa"

        container {
          name  = "mlflow-server"
          image = "ghcr.io/mlflow/mlflow:v${var.mlflow_version}"
          image_pull_policy = var.image_pull_policy

          command = [
            "mlflow",
            "server",
            "--backend-store-uri",
            "postgresql://${local.db_username}:${local.db_password}@${local.db_hostname}.${var.namespace}.svc:${local.db_port}/${local.db_name}",
            "--default-artifact-root",
            var.default_artifact_root,
            "--host",
            "0.0.0.0",
            "--port",
            "5000"
          ]

          env {
            name  = "MLFLOW_TRACKING_URI"
            value = "http://0.0.0.0:5000"
          }

          port {
            name           = "http"
            container_port = 5000
            protocol       = "TCP"
          }

          resources {
            requests = {
              cpu    = var.mlflow_server_cpu_request
              memory = var.mlflow_server_memory_request
            }
            limits = {
              cpu    = var.mlflow_server_cpu_limit
              memory = var.mlflow_server_memory_limit
            }
          }

          liveness_probe {
            http_get {
              path = "/health"
              port = 5000
            }
            initial_delay_seconds = 30
            period_seconds        = 10
          }

          readiness_probe {
            http_get {
              path = "/health"
              port = 5000
            }
            initial_delay_seconds = 10
            period_seconds        = 10
          }

          dynamic "volume_mount" {
            for_each = var.use_persistent_storage ? [1] : []
            content {
              name       = "mlflow-artifacts"
              mount_path = var.default_artifact_root
            }
          }
        }

        dynamic "volume" {
          for_each = var.use_persistent_storage ? [1] : []
          content {
            name = "mlflow-artifacts"
            persistent_volume_claim {
              claim_name = kubernetes_persistent_volume_claim.mlflow_artifacts[0].metadata[0].name
            }
          }
        }
        dynamic "volume" {
          for_each = var.use_persistent_storage ? [] : [1]
          content {
            name = "mlflow-artifacts"
            empty_dir {
              medium = "Memory"
            }
          }
        }
      }
    }
  }

  depends_on = [
    kubernetes_namespace.mlflow,
    kubernetes_service.mlflow_postgres
  ]
}

resource "kubernetes_service" "mlflow" {
  metadata {
    name      = "${var.environment}-${var.naming_prefix}-mlflow-service"
    namespace = var.namespace
    labels = merge(var.tags, {
      app       = "mlflow"
      component = "workflow"
    })
  }

  spec {
    type = var.service_type

    selector = merge(var.tags, {
      app = "mlflow-server"
    })

    port {
      name       = "http"
      port       = 80
      target_port = 5000
      protocol   = "TCP"
    }
  }

  depends_on = [kubernetes_deployment.mlflow]
}

resource "kubernetes_service_account" "mlflow" {
  metadata {
    name      = "${var.environment}-${var.naming_prefix}-mlflow-sa"
    namespace = var.namespace
    labels = merge(var.tags, {
      app       = "mlflow"
      component = "workflow"
    })
  }
}

# MLflow Model Registry Deployment (Optional)
resource "kubernetes_deployment" "mlflow_model_registry" {
  count = var.enable_model_registry ? 1 : 0

  metadata {
    name      = "${var.environment}-${var.naming_prefix}-mlflow-model-registry"
    namespace = var.namespace
    labels = merge(var.tags, {
      app       = "mlflow-model-registry"
      component = "workflow"
    })
  }

  spec {
    replicas = var.model_registry_replicas

    selector {
      match_labels = merge(var.tags, {
        app = "mlflow-model-registry"
      })
    }

    template {
      metadata {
        labels = merge(var.tags, {
          app = "mlflow-model-registry"
        })
      }

      spec {
        service_account_name = "${var.environment}-${var.naming_prefix}-mlflow-sa"

        container {
          name  = "mlflow-model-registry"
          image = "ghcr.io/mlflow/mlflow:v${var.mlflow_version}"
          image_pull_policy = var.image_pull_policy

          command = [
            "mlflow",
            "server",
            "--backend-store-uri",
            "postgresql://${local.db_username}:${local.db_password}@${local.db_hostname}.${var.namespace}.svc:${local.db_port}/${local.db_name}",
            "--default-artifact-root",
            var.artifact_root_path,
            "--host",
            "0.0.0.0",
            "--port",
            "5000",
            "--serve-artifacts"
          ]

          port {
            container_port = 5000
          }

          resources {
            limits = {
              cpu    = var.model_registry_cpu_limit
              memory = var.model_registry_memory_limit
            }
            requests = {
              cpu    = var.model_registry_cpu_request
              memory = var.model_registry_memory_request
            }
          }

          dynamic "volume_mount" {
            for_each = var.use_persistent_storage ? [1] : []
            content {
              name       = "mlflow-artifacts"
              mount_path = var.artifact_root_path
            }
          }
        }

        dynamic "volume" {
          for_each = var.use_persistent_storage ? [1] : []
          content {
            name = "mlflow-artifacts"
            persistent_volume_claim {
              claim_name = kubernetes_persistent_volume_claim.mlflow_artifacts[0].metadata[0].name
            }
          }
        }
        dynamic "volume" {
          for_each = var.use_persistent_storage ? [] : [1]
          content {
            name = "mlflow-artifacts"
            empty_dir {
              medium = "Memory"
            }
          }
        }
      }
    }
  }

  depends_on = [kubernetes_deployment.mlflow]
}

# MLflow Model Registry Service (Optional)
resource "kubernetes_service" "mlflow_model_registry" {
  count = var.enable_model_registry ? 1 : 0

  metadata {
    name      = "${var.environment}-${var.naming_prefix}-mlflow-model-registry"
    namespace = var.namespace
    labels = merge(var.tags, {
      app       = "mlflow-model-registry"
      component = "workflow"
    })
  }

  spec {
    selector = merge(var.tags, {
      app = "mlflow-model-registry"
    })

    port {
      name        = "http"
      port        = 5000
      target_port = 5000
      protocol    = "TCP"
    }

    type = var.model_registry_service_type
  }

  depends_on = [kubernetes_deployment.mlflow_model_registry]
}

resource "kubernetes_config_map" "mlflow_config" {
  metadata {
    name      = "${var.environment}-${var.naming_prefix}-mlflow-config"
    namespace = var.namespace
    labels = merge(var.tags, {
      app       = "mlflow"
      component = "workflow"
    })
  }

  data = {
    mlflow_version         = var.mlflow_version
    backend_store_type     = var.backend_store_type
    default_artifact_root  = var.default_artifact_root
    enable_tracking        = var.enable_tracking ? "true" : "false"
    enable_models          = var.enable_models ? "true" : "false"
    enable_projects        = var.enable_projects ? "true" : "false"
    storage_class          = var.storage_class
    storage_size           = var.storage_size
  }
}
