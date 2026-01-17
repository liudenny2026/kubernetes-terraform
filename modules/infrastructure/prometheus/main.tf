# ============================================================================
# Prometheus & Grafana Module - Main Configuration
# 三级架构: 资源�?- Monitoring Deployment/Service
# 命名规范: ${var.environment}-${var.naming_prefix}-infra-prometheus-{resource-type}
# ============================================================================

# Create monitoring namespace
resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = var.namespace
    labels = merge(
      var.tags,
      {
        "name"                          = var.namespace
        "prod-cloud-native-component"  = "prometheus"
        "prod-cloud-native-resource"   = "namespace"
      }
    )
  }
}

# Deploy Prometheus Operator using local chart (国内最佳实�?
resource "helm_release" "prometheus" {
  name       = "${var.environment}-${var.naming_prefix}-infra-prometheus"
  repository = var.prometheus_repository
  chart      = var.prometheus_chart_name
  version    = var.prometheus_chart_version
  namespace  = kubernetes_namespace.monitoring.metadata[0].name
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
    value = var.prometheus_storage_size
  }

  set {
    name  = "prometheus.prometheusSpec.resources.requests.cpu"
    value = var.prometheus_cpu_request
  }

  set {
    name  = "prometheus.prometheusSpec.resources.requests.memory"
    value = var.prometheus_memory_request
  }

  set {
    name  = "prometheus.prometheusSpec.resources.limits.cpu"
    value = var.prometheus_cpu_limit
  }

  set {
    name  = "prometheus.prometheusSpec.resources.limits.memory"
    value = var.prometheus_memory_limit
  }

  set {
    name  = "grafana.persistence.storageClass"
    value = var.storage_class
  }

  set {
    name  = "grafana.persistence.size"
    value = var.grafana_storage_size
  }

  set {
    name  = "grafana.adminUser"
    value = var.grafana_admin_user
  }

  set {
    name  = "grafana.adminPassword"
    value = var.grafana_admin_password
  }

  set {
    name  = "grafana.service.type"
    value = var.grafana_service_type
  }

  set {
    name  = "alertmanager.alertmanagerSpec.storageSpec.storageClass"
    value = var.storage_class
  }

  set {
    name  = "alertmanager.alertmanagerSpec.storageSpec.volumeClaimTemplate.spec.storage"
    value = var.alertmanager_storage_size
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

  depends_on = [kubernetes_namespace.monitoring]
}
