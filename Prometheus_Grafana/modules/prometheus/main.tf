# Create monitoring namespace
resource "kubernetes_namespace_v1" "monitoring" {
  metadata {
    name = var.namespace
    labels = {
      name = "monitoring"
    }
  }
}

# Deploy Prometheus Operator using local chart (国内最佳实践)
resource "helm_release" "prometheus" {
  name       = "kube-prometheus-stack"
  repository = var.prometheus_repository
  chart      = var.prometheus_chart_name
  version    = var.prometheus_chart_version
  namespace  = kubernetes_namespace_v1.monitoring.metadata[0].name
  timeout    = 1200

  set {
    name  = "namespaceOverride"
    value = var.namespace
  }

  set {
    name  = "global.imageRegistry"
    value = var.registry_mirror
  }

  set {
    name  = "prometheus.prometheusSpec.storageSpec.storageClass"
    value = var.storage_class
  }

  set {
    name  = "prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.storage"
    value = "50Gi"
  }

  set {
    name  = "prometheus.prometheusSpec.resources.requests.cpu"
    value = "500m"
  }

  set {
    name  = "prometheus.prometheusSpec.resources.requests.memory"
    value = "2Gi"
  }

  set {
    name  = "prometheus.prometheusSpec.resources.limits.cpu"
    value = "1000m"
  }

  set {
    name  = "prometheus.prometheusSpec.resources.limits.memory"
    value = "4Gi"
  }

  set {
    name  = "grafana.persistence.storageClass"
    value = var.storage_class
  }

  set {
    name  = "grafana.persistence.size"
    value = "10Gi"
  }

  set {
    name  = "grafana.adminUser"
    value = "admin"
  }

  set {
    name  = "grafana.adminPassword"
    value = "prom-operator"
  }

  set {
    name  = "grafana.service.type"
    value = "LoadBalancer"
  }

  set {
    name  = "alertmanager.alertmanagerSpec.storageSpec.storageClass"
        value = var.storage_class
  }

  set {
    name  = "alertmanager.alertmanagerSpec.storageSpec.volumeClaimTemplate.spec.storage"
        value = "10Gi"
  }

  set {
    name  = "prometheusOperator.image.registry"
        value = var.registry_mirror
  }

  set {
    name  = "kubeStateMetrics.image.registry"
        value = var.registry_mirror
  }

  set {
    name  = "nodeExporter.image.registry"
        value = var.registry_mirror
  }

  set {
    name  = "prometheus.prometheusSpec.serviceMonitorSelectorNilUsesHelmValues"
        value = "false"
  }

  set {
    name  = "prometheus.prometheusSpec.serviceMonitorNamespaceSelector"
        value = "{}"
  }

  set {
    name  = "prometheus.prometheusSpec.serviceMonitorSelector"
        value = "{}"
  }

  set {
    name  = "prometheus.prometheusSpec.podMonitorSelectorNilUsesHelmValues"
        value = "false"
  }

  set {
    name  = "prometheus.prometheusSpec.podMonitorNamespaceSelector"
        value = "{}"
  }

  set {
    name  = "prometheus.prometheusSpec.podMonitorSelector"
        value = "{}"
  }

  depends_on = [kubernetes_namespace_v1.monitoring]
}

# Output deployment information
output "instructions" {
  description = "Deployment instructions"
  value = "Kube Prometheus Stack deployed. Apply ServiceMonitors manually or use auto-discovery."
}