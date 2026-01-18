# ServiceMonitors and PodMonitors for Prometheus

# Ceph Manager ServiceMonitor
resource "kubernetes_manifest" "ceph_mgr_servicemonitor" {
  depends_on = [helm_release.prometheus]

  manifest = {
    apiVersion = "monitoring.coreos.com/v1"
    kind       = "ServiceMonitor"
    metadata = {
      name      = "ceph-mgr"
      namespace = kubernetes_namespace.monitoring.metadata[0].name
      labels = {
        app = "ceph-mgr"
      }
    }
    spec = {
      selector = {
        matchLabels = {
          app = "rook-ceph-mgr"
        }
      }
      namespaceSelector = {
        matchNames = ["rook-ceph"]
      }
      endpoints = [
        {
          port   = "http-metrics"
          interval = "15s"
          path   = "/metrics"
        }
      ]
    }
  }
}

# Ceph Monitor ServiceMonitor
resource "kubernetes_manifest" "ceph_mon_servicemonitor" {
  depends_on = [helm_release.prometheus]

  manifest = {
    apiVersion = "monitoring.coreos.com/v1"
    kind       = "ServiceMonitor"
    metadata = {
      name      = "ceph-mon"
      namespace = kubernetes_namespace.monitoring.metadata[0].name
      labels = {
        app = "ceph-mon"
      }
    }
    spec = {
      selector = {
        matchLabels = {
          app = "rook-ceph-mon"
        }
      }
      namespaceSelector = {
        matchNames = ["rook-ceph"]
      }
      endpoints = [
        {
          port   = "mon-api-http"
          interval = "15s"
          path   = "/metrics"
        }
      ]
    }
  }
}

# Ceph OSD ServiceMonitor
resource "kubernetes_manifest" "ceph_osd_servicemonitor" {
  depends_on = [helm_release.prometheus]

  manifest = {
    apiVersion = "monitoring.coreos.com/v1"
    kind       = "ServiceMonitor"
    metadata = {
      name      = "ceph-osd"
      namespace = kubernetes_namespace.monitoring.metadata[0].name
      labels = {
        app = "ceph-osd"
      }
    }
    spec = {
      selector = {
        matchLabels = {
          app = "rook-ceph-osd"
        }
      }
      namespaceSelector = {
        matchNames = ["rook-ceph"]
      }
      endpoints = [
        {
          port   = "osd-metrics"
          interval = "15s"
          path   = "/metrics"
        }
      ]
    }
  }
}

# Istio Galley ServiceMonitor
resource "kubernetes_manifest" "istio_galley_servicemonitor" {
  depends_on = [helm_release.prometheus]

  manifest = {
    apiVersion = "monitoring.coreos.com/v1"
    kind       = "ServiceMonitor"
    metadata = {
      name      = "istio-galley"
      namespace = kubernetes_namespace.monitoring.metadata[0].name
      labels = {
        app = "istio-galley"
      }
    }
    spec = {
      selector = {
        matchLabels = {
          istio = "galley"
        }
      }
      namespaceSelector = {
        matchNames = ["istio-system"]
      }
      endpoints = [
        {
          port   = "http-monitoring"
          interval = "15s"
          path   = "/metrics"
        }
      ]
    }
  }
}

# Istio Pilot ServiceMonitor
resource "kubernetes_manifest" "istio_pilot_servicemonitor" {
  depends_on = [helm_release.prometheus]

  manifest = {
    apiVersion = "monitoring.coreos.com/v1"
    kind       = "ServiceMonitor"
    metadata = {
      name      = "istio-pilot"
      namespace = kubernetes_namespace.monitoring.metadata[0].name
      labels = {
        app = "istio-pilot"
      }
    }
    spec = {
      selector = {
        matchLabels = {
          istio = "pilot"
        }
      }
      namespaceSelector = {
        matchNames = ["istio-system"]
      }
      endpoints = [
        {
          port   = "http-monitoring"
          interval = "15s"
          path   = "/metrics"
        }
      ]
    }
  }
}

# Istio Sidecar PodMonitor
resource "kubernetes_manifest" "istio_sidecar_podmonitor" {
  depends_on = [helm_release.prometheus]

  manifest = {
    apiVersion = "monitoring.coreos.com/v1"
    kind       = "PodMonitor"
    metadata = {
      name      = "istio-sidecar"
      namespace = kubernetes_namespace.monitoring.metadata[0].name
      labels = {
        app = "istio-sidecar"
      }
    }
    spec = {
      selector = {
        matchExpressions = [
          {
            key      = "app"
            operator = "In"
            values   = ["istio-proxy"]
          }
        ]
      }
      namespaceSelector = {
        any = true
      }
      podMetricsEndpoints = [
        {
          port     = "http-monitoring"
          interval = "15s"
          path     = "/stats/prometheus"
        }
      ]
    }
  }
}

# Kubeflow Katib ServiceMonitor
resource "kubernetes_manifest" "kubeflow_katib_servicemonitor" {
  depends_on = [helm_release.prometheus]

  manifest = {
    apiVersion = "monitoring.coreos.com/v1"
    kind       = "ServiceMonitor"
    metadata = {
      name      = "kubeflow-katib"
      namespace = kubernetes_namespace.monitoring.metadata[0].name
      labels = {
        app = "kubeflow-katib"
      }
    }
    spec = {
      selector = {
        matchLabels = {
          app = "katib-controller"
        }
      }
      namespaceSelector = {
        matchNames = ["kubeflow"]
      }
      endpoints = [
        {
          port   = "metrics"
          interval = "15s"
          path   = "/metrics"
        }
      ]
    }
  }
}

# Kubeflow Notebook ServiceMonitor
resource "kubernetes_manifest" "kubeflow_notebook_servicemonitor" {
  depends_on = [helm_release.prometheus]

  manifest = {
    apiVersion = "monitoring.coreos.com/v1"
    kind       = "ServiceMonitor"
    metadata = {
      name      = "kubeflow-notebook"
      namespace = kubernetes_namespace.monitoring.metadata[0].name
      labels = {
        app = "kubeflow-notebook"
      }
    }
    spec = {
      selector = {
        matchLabels = {
          app = "notebook-controller-deployment"
        }
      }
      namespaceSelector = {
        matchNames = ["kubeflow"]
      }
      endpoints = [
        {
          port   = "metrics"
          interval = "15s"
          path   = "/metrics"
        }
      ]
    }
  }
}

# Kubeflow Pipeline ServiceMonitor
resource "kubernetes_manifest" "kubeflow_pipeline_servicemonitor" {
  depends_on = [helm_release.prometheus]

  manifest = {
    apiVersion = "monitoring.coreos.com/v1"
    kind       = "ServiceMonitor"
    metadata = {
      name      = "kubeflow-pipeline"
      namespace = kubernetes_namespace.monitoring.metadata[0].name
      labels = {
        app = "kubeflow-pipeline"
      }
    }
    spec = {
      selector = {
        matchLabels = {
          app = "ml-pipeline"
        }
      }
      namespaceSelector = {
        matchNames = ["kubeflow"]
      }
      endpoints = [
        {
          port   = "http"
          interval = "15s"
          path   = "/metrics"
        }
      ]
    }
  }
}

# Kubeflow Training ServiceMonitor
resource "kubernetes_manifest" "kubeflow_training_servicemonitor" {
  depends_on = [helm_release.prometheus]

  manifest = {
    apiVersion = "monitoring.coreos.com/v1"
    kind       = "ServiceMonitor"
    metadata = {
      name      = "kubeflow-training"
      namespace = kubernetes_namespace.monitoring.metadata[0].name
      labels = {
        app = "kubeflow-training"
      }
    }
    spec = {
      selector = {
        matchLabels = {
          app = "training-operator"
        }
      }
      namespaceSelector = {
        matchNames = ["kubeflow"]
      }
      endpoints = [
        {
          port   = "metrics"
          interval = "15s"
          path   = "/metrics"
        }
      ]
    }
  }
}

# MetalLB Controller ServiceMonitor
resource "kubernetes_manifest" "metallb_controller_servicemonitor" {
  depends_on = [helm_release.prometheus]

  manifest = {
    apiVersion = "monitoring.coreos.com/v1"
    kind       = "ServiceMonitor"
    metadata = {
      name      = "metallb-controller"
      namespace = kubernetes_namespace.monitoring.metadata[0].name
      labels = {
        app = "metallb-controller"
      }
    }
    spec = {
      selector = {
        matchLabels = {
          app = "metallb-controller"
        }
      }
      namespaceSelector = {
        matchNames = ["metallb-system"]
      }
      endpoints = [
        {
          port   = "monitoring"
          interval = "15s"
          path   = "/metrics"
        }
      ]
    }
  }
}

# MetalLB Speaker ServiceMonitor
resource "kubernetes_manifest" "metallb_speaker_servicemonitor" {
  depends_on = [helm_release.prometheus]

  manifest = {
    apiVersion = "monitoring.coreos.com/v1"
    kind       = "ServiceMonitor"
    metadata = {
      name      = "metallb-speaker"
      namespace = kubernetes_namespace.monitoring.metadata[0].name
      labels = {
        app = "metallb-speaker"
      }
    }
    spec = {
      selector = {
        matchLabels = {
          app = "metallb-speaker"
        }
      }
      namespaceSelector = {
        matchNames = ["metallb-system"]
      }
      endpoints = [
        {
          port   = "monitoring"
          interval = "15s"
          path   = "/metrics"
        }
      ]
    }
  }
}

# MinIO Console ServiceMonitor
resource "kubernetes_manifest" "minio_console_servicemonitor" {
  depends_on = [helm_release.prometheus]

  manifest = {
    apiVersion = "monitoring.coreos.com/v1"
    kind       = "ServiceMonitor"
    metadata = {
      name      = "minio-console"
      namespace = kubernetes_namespace.monitoring.metadata[0].name
      labels = {
        app = "minio-console"
      }
    }
    spec = {
      selector = {
        matchLabels = {
          app = "minio-console"
        }
      }
      namespaceSelector = {
        matchNames = ["minio-operator", "minio-tenant", "minio"]
      }
      endpoints = [
        {
          port   = "http"
          interval = "15s"
          path   = "/minio/v2/metrics/console"
        }
      ]
    }
  }
}

# MinIO ServiceMonitor
resource "kubernetes_manifest" "minio_servicemonitor" {
  depends_on = [helm_release.prometheus]

  manifest = {
    apiVersion = "monitoring.coreos.com/v1"
    kind       = "ServiceMonitor"
    metadata = {
      name      = "minio"
      namespace = kubernetes_namespace.monitoring.metadata[0].name
      labels = {
        app = "minio"
      }
    }
    spec = {
      selector = {
        matchLabels = {
          app = "minio"
        }
      }
      namespaceSelector = {
        matchNames = ["minio-operator", "minio-tenant", "minio"]
      }
      endpoints = [
        {
          port   = "http"
          interval = "15s"
          path   = "/minio/v2/metrics/cluster"
        }
      ]
    }
  }
}

# MLflow Backend ServiceMonitor
resource "kubernetes_manifest" "mlflow_backend_servicemonitor" {
  depends_on = [helm_release.prometheus]

  manifest = {
    apiVersion = "monitoring.coreos.com/v1"
    kind       = "ServiceMonitor"
    metadata = {
      name      = "mlflow-backend"
      namespace = kubernetes_namespace.monitoring.metadata[0].name
      labels = {
        app = "mlflow-backend"
      }
    }
    spec = {
      selector = {
        matchLabels = {
          app = "mlflow-backend"
        }
      }
      namespaceSelector = {
        matchNames = ["mlflow"]
      }
      endpoints = [
        {
          port   = "http"
          interval = "15s"
          path   = "/metrics"
        }
      ]
    }
  }
}

# MLflow Server ServiceMonitor
resource "kubernetes_manifest" "mlflow_server_servicemonitor" {
  depends_on = [helm_release.prometheus]

  manifest = {
    apiVersion = "monitoring.coreos.com/v1"
    kind       = "ServiceMonitor"
    metadata = {
      name      = "mlflow-server"
      namespace = kubernetes_namespace.monitoring.metadata[0].name
      labels = {
        app = "mlflow-server"
      }
    }
    spec = {
      selector = {
        matchLabels = {
          app = "mlflow-server"
        }
      }
      namespaceSelector = {
        matchNames = ["mlflow"]
      }
      endpoints = [
        {
          port   = "http"
          interval = "15s"
          path   = "/metrics"
        }
      ]
    }
  }
}