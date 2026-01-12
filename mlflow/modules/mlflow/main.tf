# MLflow Unified Module - Supports both basic and advanced configurations
# This module provides a complete MLflow deployment with optional advanced features

locals {
  mlflow_namespace       = var.mlflow_namespace
  mlflow_image          = "${var.mlflow_image_repository}:${var.mlflow_version}"
  postgres_image        = "${var.postgres_image_repository}:${var.postgres_image_tag}"
  
  # Use common database connection parameters if advanced database config is enabled
  db_hostname = var.use_advanced_db_config ? var.db_hostname : "mlflow-postgres"
  db_port     = var.use_advanced_db_config ? var.db_port : "5432"
  db_username = var.use_advanced_db_config ? var.db_username : var.postgres_user
  db_password = var.use_advanced_db_config ? var.db_password : var.postgres_password
  db_name     = var.use_advanced_db_config ? var.db_name : var.postgres_db
}

# Create MLflow namespace
resource "kubernetes_namespace_v1" "mlflow" {
  count = var.create_namespace ? 1 : 0
  
  metadata {
    name = local.mlflow_namespace
    labels = {
      app       = "mlflow"
      managed-by = "terraform"
    }
  }
}

# MLflow PostgreSQL Secret
resource "kubernetes_secret_v1" "mlflow_db" {
  metadata {
    name      = "mlflow-db-secret"
    namespace = local.mlflow_namespace
  }

  data = {
    postgres-password = var.postgres_password
    postgres-user     = var.postgres_user
    postgres-db       = var.postgres_db
  }

  type = "Opaque"

  depends_on = [kubernetes_namespace_v1.mlflow]
}

# Deploy PostgreSQL database (only if internal DB is enabled)
resource "kubernetes_deployment_v1" "mlflow_postgres" {
  count = var.enable_internal_postgres ? 1 : 0

  metadata {
    name      = "mlflow-postgres"
    namespace = local.mlflow_namespace
    annotations = {
      "deployment.kubernetes.io/revision" = "1"
    }
    labels = {
      app = "mlflow-postgres"
    }
  }

  spec {
    replicas = var.postgres_replicas

    selector {
      match_labels = {
        app = "mlflow-postgres"
      }
    }

    template {
      metadata {
        labels = {
          app = "mlflow-postgres"
        }
      }

      spec {
        container {
          name  = "postgres"
          image = local.postgres_image
          image_pull_policy = "Always"

          port {
            container_port = 5432
          }

          env {
            name = "POSTGRES_PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret_v1.mlflow_db.metadata[0].name
                key  = "postgres-password"
              }
            }
          }

          env {
            name = "POSTGRES_USER"
            value_from {
              secret_key_ref {
                name = kubernetes_secret_v1.mlflow_db.metadata[0].name
                key  = "postgres-user"
              }
            }
          }

          env {
            name = "POSTGRES_DB"
            value_from {
              secret_key_ref {
                name = kubernetes_secret_v1.mlflow_db.metadata[0].name
                key  = "postgres-db"
              }
            }
          }

          env {
            name  = "PGDATA"
            value = "/var/lib/postgresql/data/pgdata"
          }

          resources {
            limits = {
              cpu    = var.postgres_cpu_limit
              memory = var.postgres_memory_limit
            }
            requests = {
              cpu    = var.postgres_cpu_request
              memory = var.postgres_memory_request
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
              claim_name = kubernetes_persistent_volume_claim_v1.postgres_storage[0].metadata[0].name
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

  lifecycle {
    ignore_changes = [
      spec[0].template[0].spec[0].container[0].resources,
      spec[0].template[0].spec[0].container[0].env,
      metadata[0].annotations,
      metadata[0].labels,
      spec[0].selector,
      spec[0].strategy,
      spec[0].template[0].spec[0].termination_grace_period_seconds
    ]
  }

  timeouts {
    create = "30m"
    update = "30m"
    delete = "30m"
  }

  depends_on = [kubernetes_secret_v1.mlflow_db]
}

# PostgreSQL Persistent Volume Claim
resource "kubernetes_persistent_volume_claim_v1" "postgres_storage" {
  count = var.enable_internal_postgres && var.use_persistent_storage ? 1 : 0
  
  metadata {
    name      = "mlflow-postgres-storage"
    namespace = local.mlflow_namespace
  }

  spec {
    access_modes = ["ReadWriteOnce"]
    storage_class_name = var.postgres_storage_class != "" ? var.postgres_storage_class : null

    resources {
      requests = {
        storage = var.postgres_storage_size
      }
    }
  }

  lifecycle {
    ignore_changes = [
      spec[0].resources
    ]
  }

  timeouts {
    create = "60m"
  }
}

# PostgreSQL Service
resource "kubernetes_service_v1" "mlflow_postgres" {
  count = var.enable_internal_postgres ? 1 : 0
  
  metadata {
    name      = "mlflow-postgres"
    namespace = local.mlflow_namespace
    labels = {
      app = "mlflow-postgres"
    }
  }

  spec {
    selector = {
      app = "mlflow-postgres"
    }

    port {
      port        = 5432
      target_port = 5432
    }

    type = var.postgres_service_type
  }

  depends_on = [kubernetes_deployment_v1.mlflow_postgres]
}

# MLflow Server ConfigMap
resource "kubernetes_config_map_v1" "mlflow_config" {
  metadata {
    name      = "mlflow-config"
    namespace = local.mlflow_namespace
  }

  data = {
    backend-store-uri = "postgresql://${local.db_username}:${local.db_password}@${local.db_hostname}:${local.db_port}/${local.db_name}"
    default-artifact-root = var.default_artifact_root
  }

  depends_on = [kubernetes_service_v1.mlflow_postgres]
}

# MLflow Server Deployment
resource "kubernetes_deployment_v1" "mlflow_server" {

  metadata {
    name      = "mlflow-server"
    namespace = local.mlflow_namespace
    annotations = {
      "deployment.kubernetes.io/revision" = "1"
    }
    labels = {
      app = "mlflow-server"
    }
  }

  spec {
    replicas = var.mlflow_replicas

    selector {
      match_labels = {
        app = "mlflow-server"
      }
    }

    template {
      metadata {
        labels = {
          app = "mlflow-server"
        }
      }

      spec {
        container {
          name  = "mlflow-server"
          image = local.mlflow_image
          image_pull_policy = "Always"

          command = [
            "mlflow",
            "server",
            "--backend-store-uri",
            "postgresql://${local.db_username}:${local.db_password}@${local.db_hostname}:${local.db_port}/${local.db_name}",
            "--default-artifact-root",
            var.default_artifact_root,
            "--host",
            "0.0.0.0",
            "--port",
            "5000"
          ]

          port {
            container_port = 5000
          }

          env {
            name = "MLFLOW_TRACKING_URI"
            value = "http://0.0.0.0:5000"
          }

          resources {
            limits = {
              cpu    = var.mlflow_server_cpu_limit
              memory = var.mlflow_server_memory_limit
            }
            requests = {
              cpu    = var.mlflow_server_cpu_request
              memory = var.mlflow_server_memory_request
            }
          }

          volume_mount {
            name       = "mlflow-artifacts"
            mount_path = var.default_artifact_root
          }
        }

        dynamic "volume" {
          for_each = var.use_persistent_storage ? [1] : []
          content {
            name = "mlflow-artifacts"
            persistent_volume_claim {
              claim_name = var.use_persistent_storage ? kubernetes_persistent_volume_claim_v1.mlflow_artifacts[0].metadata[0].name : null
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

  lifecycle {
    ignore_changes = [
      spec[0].template[0].spec[0].container[0].resources,
      spec[0].template[0].spec[0].container[0].env,
      metadata[0].annotations,
      metadata[0].labels,
      spec[0].selector,
      spec[0].strategy,
      spec[0].template[0].spec[0].termination_grace_period_seconds
    ]
  }

  timeouts {
    create = "30m"
    update = "30m"
    delete = "30m"
  }

  depends_on = [kubernetes_deployment_v1.mlflow_postgres]
}

# MLflow Artifacts Persistent Volume Claim
resource "kubernetes_persistent_volume_claim_v1" "mlflow_artifacts" {
  count = var.use_persistent_storage ? 1 : 0

  metadata {
    name      = "mlflow-artifacts-storage"
    namespace = local.mlflow_namespace
  }

  spec {
    access_modes = ["ReadWriteOnce"]
    storage_class_name = var.artifact_storage_class != "" ? var.artifact_storage_class : null

    resources {
      requests = {
        storage = var.artifact_storage_size
      }
    }
  }

  lifecycle {
    ignore_changes = [
      spec[0].resources
    ]
  }

  timeouts {
    create = "60m"
  }
}

# MLflow Server Service
resource "kubernetes_service_v1" "mlflow_server" {
  metadata {
    name      = "mlflow-server"
    namespace = local.mlflow_namespace
    labels = {
      app = "mlflow-server"
    }
  }

  spec {
    selector = {
      app = "mlflow-server"
    }

    port {
      name        = "http"
      port        = 5000
      target_port = 5000
      protocol    = "TCP"
    }

    type = var.service_type
  }

  depends_on = [kubernetes_deployment_v1.mlflow_server]
}

# MLflow Model Registry Service (Optional)
resource "kubernetes_service_v1" "mlflow_model_registry" {
  count = var.enable_model_registry ? 1 : 0

  metadata {
    name      = "mlflow-model-registry"
    namespace = local.mlflow_namespace
    labels = {
      app = "mlflow-model-registry"
    }
  }

  spec {
    selector = {
      app = "mlflow-model-registry"
    }

    port {
      name        = "http"
      port        = 5000
      target_port = 5000
      protocol    = "TCP"
    }

    type = var.model_registry_service_type
  }

  lifecycle {
    ignore_changes = [
      spec[0].selector,
      spec[0].port
    ]
  }
}

# MLflow Model Registry Deployment (Optional)
resource "kubernetes_deployment_v1" "mlflow_model_registry" {
  count = var.enable_model_registry ? 1 : 0

  metadata {
    name      = "mlflow-model-registry"
    namespace = local.mlflow_namespace
    annotations = {
      "deployment.kubernetes.io/revision" = "1"
    }
    labels = {
      app = "mlflow-model-registry"
    }
  }

  spec {
    replicas = var.model_registry_replicas

    selector {
      match_labels = {
        app = "mlflow-model-registry"
      }
    }

    template {
      metadata {
        labels = {
          app = "mlflow-model-registry"
        }
      }

      spec {
        container {
          name  = "mlflow-model-registry"
          image = local.mlflow_image
          image_pull_policy = "Always"

          command = [
            "mlflow",
            "server",
            "--backend-store-uri",
            "postgresql://${local.db_username}:${local.db_password}@${local.db_hostname}:${local.db_port}/${local.db_name}",
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

          volume_mount {
            name       = "mlflow-artifacts"
            mount_path = var.artifact_root_path
          }
        }

        dynamic "volume" {
          for_each = var.use_persistent_storage ? [1] : []
          content {
            name = "mlflow-artifacts"
            persistent_volume_claim {
              claim_name = var.use_persistent_storage ? kubernetes_persistent_volume_claim_v1.mlflow_artifacts[0].metadata[0].name : null
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

  lifecycle {
    ignore_changes = [
      spec[0].template[0].spec[0].container[0].resources,
      spec[0].template[0].spec[0].container[0].env,
      metadata[0].annotations,
      metadata[0].labels,
      spec[0].selector,
      spec[0].strategy,
      spec[0].template[0].spec[0].termination_grace_period_seconds
    ]
  }

  timeouts {
    create = "30m"
    update = "30m"
    delete = "30m"
  }

  depends_on = [kubernetes_deployment_v1.mlflow_server]
}

# Kubeflow Pipelines integration service (Optional)
resource "kubernetes_service_v1" "mlflow_kubeflow_integration" {
  count = var.enable_kubeflow_integration ? 1 : 0

  metadata {
    name      = "mlflow-kubeflow-integration"
    namespace = local.mlflow_namespace
    labels = {
      app = "mlflow-kubeflow-integration"
    }
  }

  spec {
    selector = {
      app = "mlflow-kubeflow-integration"
    }

    port {
      name        = "http"
      port        = 8888
      target_port = 8888
      protocol    = "TCP"
    }

    type = var.kubeflow_integration_service_type
  }
}