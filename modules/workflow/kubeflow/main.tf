# ============================================================================
# Kubeflow Module - Main Configuration
# 三级架构: 资源�?- Kubeflow Deployment/Service
# 命名规范: prod-cloud-native-kubeflow-{resource-type}
# ============================================================================

data "kubernetes_cluster_auth" "kubernetes" {
}

# ============================================================================# Kubeflow Module - Kubectl Manifests Deployment# ============================================================================

provider "kubectl" {
  kubernetes {
    host                   = data.kubernetes_cluster_auth.kubernetes.host
    token                  = data.kubernetes_cluster_auth.kubernetes.token
    cluster_ca_certificate = base64decode(data.kubernetes_cluster_auth.kubernetes.cluster_ca_certificate)
  }
}

resource "kubernetes_namespace" "kubeflow" {
  metadata {
    name = var.namespace
    labels = merge(var.tags, {
      app       = "kubeflow"
      component = "workflow"
    })
  }
}

resource "kubernetes_config_map" "kubeflow_config" {
  metadata {
    name      = "${var.environment}-${var.naming_prefix}-kubeflow-config"
    namespace = var.namespace
    labels = merge(var.tags, {
      app       = "kubeflow"
      component = "workflow"
    })
  }

  data = {
    kubeflow_version    = var.kubeflow_version
    domain_name         = var.domain_name
    enable_auth         = var.enable_auth ? "true" : "false"
    enable_monitoring   = var.enable_monitoring ? "true" : "false"
    storage_class       = var.storage_class
    storage_size        = var.storage_size
    mlflow_enabled      = var.mlflow_enabled ? "true" : "false"
  }
}

resource "kubernetes_persistent_volume_claim" "kubeflow" {
  metadata {
    name      = "${var.environment}-${var.naming_prefix}-kubeflow-pvc"
    namespace = var.namespace
    labels = merge(var.tags, {
      app       = "kubeflow"
      component = "workflow"
    })
  }

  spec {
    access_modes = ["ReadWriteMany"]
    storage_class_name = var.storage_class
    resources {
      requests = {
        storage = var.storage_size
      }
    }
  }

  depends_on = [kubernetes_namespace.kubeflow]
}

# -----------------------------------------------------------------------------# Spark Operator Deployment (Manifest)# -----------------------------------------------------------------------------data "kubectl_file_documents" "spark_operator" {
  content = file("${path.module}/spark-operator.yaml")
}

resource "kubectl_manifest" "spark_operator" {
  for_each  = data.kubectl_file_documents.spark_operator.documents
  yaml_body = each.value
  depends_on = [kubernetes_namespace.kubeflow]
}

# -----------------------------------------------------------------------------# Training Operator Deployment (Manifest)# -----------------------------------------------------------------------------data "kubectl_file_documents" "training_operator" {
  content = file("${path.module}/training-operator.yaml")
}

resource "kubectl_manifest" "training_operator" {
  for_each  = data.kubectl_file_documents.training_operator.documents
  yaml_body = each.value
  depends_on = [kubernetes_namespace.kubeflow]
}

# -----------------------------------------------------------------------------# Katib Deployment (Manifest)# -----------------------------------------------------------------------------data "kubectl_file_documents" "katib" {
  content = file("${path.module}/katib-operator.yaml")
}

resource "kubectl_manifest" "katib" {
  for_each  = data.kubectl_file_documents.katib.documents
  yaml_body = each.value
  depends_on = [kubernetes_namespace.kubeflow]
}

# -----------------------------------------------------------------------------# KServe Deployment (Manifest)# -----------------------------------------------------------------------------data "kubectl_file_documents" "kserve" {
  content = file("${path.module}/kserve.yaml")
}

resource "kubectl_manifest" "kserve" {
  for_each  = data.kubectl_file_documents.kserve.documents
  yaml_body = each.value
  depends_on = [kubernetes_namespace.kubeflow]
}

# -----------------------------------------------------------------------------# KServe Runtimes Deployment (Manifest)# -----------------------------------------------------------------------------data "kubectl_file_documents" "kserve_runtimes" {
  content = file("${path.module}/kserve-runtimes.yaml")
}

resource "kubectl_manifest" "kserve_runtimes" {
  for_each  = data.kubectl_file_documents.kserve_runtimes.documents
  yaml_body = each.value
  depends_on = [kubectl_manifest.kserve]
}

# -----------------------------------------------------------------------------# Kubeflow Pipelines Deployment (Manifest)# -----------------------------------------------------------------------------data "kubectl_file_documents" "kfp" {
  content = file("${path.module}/kfp.yaml")
}

resource "kubectl_manifest" "kfp" {
  for_each  = data.kubectl_file_documents.kfp.documents
  yaml_body = each.value
  depends_on = [kubernetes_namespace.kubeflow]
}

# -----------------------------------------------------------------------------# Model Registry Deployment (Manifest)# -----------------------------------------------------------------------------data "kubectl_file_documents" "model_registry" {
  content = file("${path.module}/model-registry.yaml")
}

resource "kubectl_manifest" "model_registry" {
  for_each  = data.kubectl_file_documents.model_registry.documents
  yaml_body = each.value
  depends_on = [kubernetes_namespace.kubeflow]
}

# -----------------------------------------------------------------------------# Dex Authentication Deployment (Manifest)# -----------------------------------------------------------------------------data "kubectl_file_documents" "dex" {
  content = file("${path.module}/dex.yaml")
}

resource "kubectl_manifest" "dex" {
  for_each  = data.kubectl_file_documents.dex.documents
  yaml_body = each.value
  depends_on = [kubernetes_namespace.kubeflow]
}

# -----------------------------------------------------------------------------# Central Dashboard Deployment (Manifest)# -----------------------------------------------------------------------------data "kubectl_file_documents" "centraldashboard" {
  content = file("${path.module}/centraldashboard.yaml")
}

resource "kubectl_manifest" "centraldashboard" {
  for_each  = data.kubectl_file_documents.centraldashboard.documents
  yaml_body = each.value
  depends_on = [kubernetes_namespace.kubeflow]
}

# -----------------------------------------------------------------------------# Jupyter Web App Deployment (Manifest)# -----------------------------------------------------------------------------data "kubectl_file_documents" "jupyter_web_app" {
  content = file("${path.module}/jupyter-web-app.yaml")
}

resource "kubectl_manifest" "jupyter_web_app" {
  for_each  = data.kubectl_file_documents.jupyter_web_app.documents
  yaml_body = each.value
  depends_on = [kubernetes_namespace.kubeflow, kubectl_manifest.centraldashboard]
}

# -----------------------------------------------------------------------------# Profile Controller Deployment (Manifest)# -----------------------------------------------------------------------------data "kubectl_file_documents" "profile_controller" {
  content = file("${path.module}/profile-controller.yaml")
}

resource "kubectl_manifest" "profile_controller" {
  for_each  = data.kubectl_file_documents.profile_controller.documents
  yaml_body = each.value
  depends_on = [kubernetes_namespace.kubeflow]
}

# -----------------------------------------------------------------------------# Ingress Deployment (Manifest)# -----------------------------------------------------------------------------data "kubectl_file_documents" "ingress" {
  content = file("${path.module}/ingress.yaml")
}

resource "kubectl_manifest" "ingress" {
  for_each  = data.kubectl_file_documents.ingress.documents
  yaml_body = each.value
  depends_on = [kubernetes_namespace.kubeflow]
}

resource "kubernetes_deployment" "kubeflow_pipelines" {
  count = contains(var.custom_components, "pipelines") ? 1 : 0

  metadata {
    name      = "${var.environment}-${var.naming_prefix}-kubeflow-pipelines-deployment"
    namespace = var.namespace
    labels = merge(var.tags, {
      app       = "kubeflow-pipelines"
      component = "workflow"
    })
  }

  spec {
    replicas = var.pipelines_replicas

    selector {
      match_labels = merge(var.tags, {
        app = "kubeflow-pipelines"
      })
    }

    template {
      metadata {
        labels = merge(var.tags, {
          app       = "kubeflow-pipelines"
          component = "workflow"
        })
      }

      spec {
        service_account_name = "${var.environment}-${var.naming_prefix}-kubeflow-pipelines-sa"

        container {
          name  = "ml-pipelines-frontend"
          image = "gcr.io/ml-pipeline/frontend:${var.kubeflow_version}"

          port {
            name           = "http"
            container_port = 3000
            protocol       = "TCP"
          }

          resources {
            requests = {
              cpu    = var.kubeflow_cpu_request
              memory = var.kubeflow_memory_request
            }
            limits = {
              cpu    = var.kubeflow_cpu_limit
              memory = var.kubeflow_memory_limit
            }
          }
        }

        container {
          name  = "ml-pipelines-api-server"
          image = "gcr.io/ml-pipeline/api-server:${var.kubeflow_version}"

          env {
            name  = "OBJECTSTORE_SERVICE"
            value = "minio-service.kubeflow"
          }

          port {
            name           = "http"
            container_port = 8888
            protocol       = "TCP"
          }

          resources {
            requests = {
              cpu    = var.kubeflow_cpu_request
              memory = var.kubeflow_memory_request
            }
            limits = {
              cpu    = var.kubeflow_cpu_limit
              memory = var.kubeflow_memory_limit
            }
          }

          volume_mount {
            name       = "data"
            mount_path = "/opt/mlpipeline"
          }
        }

        volume {
          name = "data"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.kubeflow.metadata[0].name
          }
        }
      }
    }
  }

  depends_on = [kubernetes_namespace.kubeflow]
}

resource "kubernetes_service" "kubeflow_pipelines" {
  metadata {
    name      = "${var.environment}-${var.naming_prefix}-kubeflow-pipelines-service"
    namespace = var.namespace
    labels = merge(var.tags, {
      app       = "kubeflow"
      component = "workflow"
    })
  }

  spec {
    type = "ClusterIP"

    selector = merge(var.tags, {
      app = "kubeflow-pipelines"
    })

    port {
      name       = "http"
      port       = 80
      target_port = 3000
      protocol   = "TCP"
    }

    port {
      name       = "api"
      port       = 8888
      target_port = 8888
      protocol   = "TCP"
    }
  }
}

resource "kubernetes_deployment" "jupyter_notebook" {
  count = contains(var.custom_components, "notebooks") ? 1 : 0

  metadata {
    name      = "${var.environment}-${var.naming_prefix}-jupyter-notebook-deployment"
    namespace = var.namespace
    labels = merge(var.tags, {
      app       = "jupyter-notebook"
      component = "workflow"
    })
  }

  spec {
    replicas = var.notebook_replicas

    selector {
      match_labels = merge(var.tags, {
        app = "jupyter-notebook"
      })
    }

    template {
      metadata {
        labels = merge(var.tags, {
          app       = "jupyter-notebook"
          component = "workflow"
        })
      }

      spec {
        service_account_name = "${var.environment}-${var.naming_prefix}-jupyter-notebook-sa"

        container {
          name  = "jupyter-notebook"
          image = "kubeflownotebookswg/jupyter-scipy:v1.5"

          env {
            name  = "JUPYTER_ENABLE_LAB"
            value = "yes"
          }

          port {
            name           = "http"
            container_port = 8888
            protocol       = "TCP"
          }

          resources {
            requests = {
              cpu    = var.kubeflow_cpu_request
              memory = var.kubeflow_memory_request
            }
            limits = {
              cpu    = var.kubeflow_cpu_limit
              memory = var.kubeflow_memory_limit
            }
          }

          volume_mount {
            name       = "data"
            mount_path = "/home/jovyan/work"
          }
        }

        volume {
          name = "data"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.kubeflow.metadata[0].name
          }
        }
      }
    }
  }

  depends_on = [kubernetes_namespace.kubeflow]
}

resource "kubernetes_service" "jupyter_notebook" {
  metadata {
    name      = "${var.environment}-${var.naming_prefix}-jupyter-notebook-service"
    namespace = var.namespace
    labels = merge(var.tags, {
      app       = "jupyter"
      component = "workflow"
    })
  }

  spec {
    type = "ClusterIP"

    selector = merge(var.tags, {
      app = "jupyter-notebook"
    })

    port {
      name       = "http"
      port       = 80
      target_port = 8888
      protocol   = "TCP"
    }
  }
}

# ---------------------------------------------------------------------------
# Spark Operator Configuration
# ---------------------------------------------------------------------------
resource "kubernetes_deployment" "spark_operator" {
  count = contains(var.custom_components, "spark-operator") ? 1 : 0

  metadata {
    name      = "${var.environment}-${var.naming_prefix}-spark-operator"
    namespace = var.namespace
    labels = merge(var.tags, {
      app       = "spark-operator"
      component = "workflow"
    })
  }

  spec {
    replicas = var.spark_operator_replicas

    selector {
      match_labels = merge(var.tags, {
        app = "spark-operator"
      })
    }

    template {
      metadata {
        labels = merge(var.tags, {
          app       = "spark-operator"
          component = "workflow"
        })
      }

      spec {
        service_account_name = "${var.environment}-${var.naming_prefix}-spark-operator-sa"

        container {
          name  = "spark-operator"
          image = "ghcr.io/spark-operator/spark-operator:${var.spark_operator_version}"

          args = [
            "--enable-metrics",
            "--metrics-port=10254",
            "--resources-namespace=${var.namespace}"
          ]

          resources {
            requests = {
              cpu    = var.spark_operator_cpu_request
              memory = var.spark_operator_memory_request
            }
            limits = {
              cpu    = var.spark_operator_cpu_limit
              memory = var.spark_operator_memory_limit
            }
          }
        }
      }
    }
  }

  depends_on = [kubernetes_namespace.kubeflow]
}

# ---------------------------------------------------------------------------
# Training Operator Configuration
# ---------------------------------------------------------------------------
resource "kubernetes_deployment" "training_operator" {
  count = contains(var.custom_components, "training-operator") ? 1 : 0

  metadata {
    name      = "${var.environment}-${var.naming_prefix}-training-operator"
    namespace = var.namespace
    labels = merge(var.tags, {
      app       = "training-operator"
      component = "workflow"
    })
  }

  spec {
    replicas = var.training_operator_replicas

    selector {
      match_labels = merge(var.tags, {
        app = "training-operator"
      })
    }

    template {
      metadata {
        labels = merge(var.tags, {
          app       = "training-operator"
          component = "workflow"
        })
      }

      spec {
        service_account_name = "${var.environment}-${var.naming_prefix}-training-operator-sa"

        container {
          name  = "training-operator"
          image = "kubeflow/training-operator:${var.training_operator_version}"

          resources {
            requests = {
              cpu    = var.training_operator_cpu_request
              memory = var.training_operator_memory_request
            }
            limits = {
              cpu    = var.training_operator_cpu_limit
              memory = var.training_operator_memory_limit
            }
          }
        }
      }
    }
  }

  depends_on = [kubernetes_namespace.kubeflow]
}

# ---------------------------------------------------------------------------
# Katib Configuration
# ---------------------------------------------------------------------------
resource "kubernetes_deployment" "katib" {
  count = contains(var.custom_components, "katib") ? 1 : 0

  metadata {
    name      = "${var.environment}-${var.naming_prefix}-katib-controller"
    namespace = var.namespace
    labels = merge(var.tags, {
      app       = "katib-controller"
      component = "workflow"
    })
  }

  spec {
    replicas = var.katib_replicas

    selector {
      match_labels = merge(var.tags, {
        app = "katib-controller"
      })
    }

    template {
      metadata {
        labels = merge(var.tags, {
          app       = "katib-controller"
          component = "workflow"
        })
      }

      spec {
        service_account_name = "${var.environment}-${var.naming_prefix}-katib-sa"

        container {
          name  = "katib-controller"
          image = "docker.io/kubeflowkatib/katib-controller:${var.katib_version}"

          resources {
            requests = {
              cpu    = var.katib_cpu_request
              memory = var.katib_memory_request
            }
            limits = {
              cpu    = var.katib_cpu_limit
              memory = var.katib_memory_limit
            }
          }
        }
      }
    }
  }

  depends_on = [kubernetes_namespace.kubeflow]
}

# ---------------------------------------------------------------------------
# KServe Configuration
# ---------------------------------------------------------------------------
resource "kubernetes_deployment" "kserve" {
  count = contains(var.custom_components, "kserve") ? 1 : 0

  metadata {
    name      = "${var.environment}-${var.naming_prefix}-kserve-controller"
    namespace = var.namespace
    labels = merge(var.tags, {
      app       = "kserve-controller"
      component = "workflow"
    })
  }

  spec {
    replicas = var.kserve_replicas

    selector {
      match_labels = merge(var.tags, {
        app = "kserve-controller"
      })
    }

    template {
      metadata {
        labels = merge(var.tags, {
          app       = "kserve-controller"
          component = "workflow"
        })
      }

      spec {
        service_account_name = "${var.environment}-${var.naming_prefix}-kserve-sa"

        container {
          name  = "kserve-controller"
          image = "docker.io/kserve/kserve-controller:${var.kserve_version}"

          resources {
            requests = {
              cpu    = var.kserve_cpu_request
              memory = var.kserve_memory_request
            }
            limits = {
              cpu    = var.kserve_cpu_limit
              memory = var.kserve_memory_limit
            }
          }
        }
      }
    }
  }

  depends_on = [kubernetes_namespace.kubeflow]
}
