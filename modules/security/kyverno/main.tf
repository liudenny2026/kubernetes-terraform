# ============================================================================
# Kyverno Module - Main Configuration
# 三级架构: 资源�?- Kyverno Deployment/Service
# 命名规范: prod-cloud-native-kyverno-{resource-type}
# ============================================================================

resource "kubernetes_namespace" "kyverno" {
  metadata {
    name = var.namespace
    labels = merge(var.tags, {
      app       = "kyverno"
      component = "security"
    })
  }
}

resource "helm_release" "kyverno" {
  name       = "${var.environment}-${var.naming_prefix}-kyverno"
  repository = "https://kyverno.github.io/kyverno"
  chart      = "kyverno"
  namespace  = var.namespace
  version    = var.kyverno_version

  set {
    name  = "replicaCount"
    value = var.replicas
  }

  set {
    name  = "createSelfSignedCert"
    value = var.create_self_signed_cert
  }

  set {
    name  = "initContainer.resources.requests.cpu"
    value = "100m"
  }

  set {
    name  = "initContainer.resources.requests.memory"
    value = "256Mi"
  }

  set {
    name  = "initContainer.resources.limits.cpu"
    value = "500m"
  }

  set {
    name  = "initContainer.resources.limits.memory"
    value = "512Mi"
  }

  set {
    name  = "resources.requests.cpu"
    value = "500m"
  }

  set {
    name  = "resources.requests.memory"
    value = "1Gi"
  }

  set {
    name  = "resources.limits.cpu"
    value = "2000m"
  }

  set {
    name  = "resources.limits.memory"
    value = "2Gi"
  }

  set {
    name  = "reporting.resources.requests.cpu"
    value = "500m"
  }

  set {
    name  = "reporting.resources.requests.memory"
    value = "512Mi"
  }

  set {
    name  = "reporting.resources.limits.cpu"
    value = "2000m"
  }

  set {
    name  = "reporting.resources.limits.memory"
    value = "2Gi"
  }

  set {
    name  = "backgroundScan.enabled"
    value = var.background_scan_enabled
  }

  set {
    name  = "backgroundScan.interval"
    value = "${var.background_scan_interval}h"
  }

  set {
    name  = "policyReports.enabled"
    value = var.enable_policy_reporting
  }

  set {
    name  = "admissionReports.enabled"
    value = var.enable_admission_reports
  }

  set {
    name  = "excludeNamespaces"
    value = join(",", var.exclude_namespaces)
  }

  set {
    name  = "logLevel"
    value = var.log_level
  }

  set {
    name  = "webhookTimeout"
    value = 30
  }

  depends_on = [kubernetes_namespace.kyverno]
}

resource "kubernetes_config_map" "kyverno_config" {
  metadata {
    name      = "${var.environment}-${var.naming_prefix}-kyverno-config"
    namespace = var.namespace
    labels = merge(var.tags, {
      app       = "kyverno"
      component = "security"
    })
  }

  data = {
    replicas                  = var.replicas
    background_scan_enabled   = var.background_scan_enabled ? "true" : "false"
    background_scan_interval = "${var.background_scan_interval}h"
    policy_reporting         = var.enable_policy_reporting ? "true" : "false"
    admission_reports         = var.enable_admission_reports ? "true" : "false"
    exclude_namespaces       = join(",", var.exclude_namespaces)
  }
}
