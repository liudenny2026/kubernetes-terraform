# ============================================================================
# OPA Gatekeeper Module - Main Configuration
# 三级架构: 资源�?- OPA Gatekeeper Deployment/Service
# 命名规范: prod-cloud-native-opa-{resource-type}
# ============================================================================

resource "kubernetes_namespace" "gatekeeper" {
  metadata {
    name = var.namespace
    labels = merge(var.tags, {
      app       = "gatekeeper"
      component = "security"
    })
  }
}

resource "helm_release" "gatekeeper" {
  name       = "${var.environment}-${var.naming_prefix}-gatekeeper"
  repository = "oci://ghcr.io/open-policy-agent"
  chart      = "gatekeeper"
  namespace  = var.namespace
  version    = var.gatekeeper_version

  set {
    name  = "replicaCount"
    value = var.replicas
  }

  set {
    name  = "auditInterval"
    value = var.audit_interval
  }

  set {
    name  = "constraintViolationsLimit"
    value = 20
  }

  set {
    name  = "auditMatchKindOnly"
    value = true
  }

  set {
    name  = "disableValidatingWebhook"
    value = false
  }

  set {
    name  = "disableMutationWebhook"
    value = !var.enable_mutation
  }

  set {
    name  = "logLevel"
    value = var.log_level
  }

  set {
    name  = "externalData.enabled"
    value = var.enable_external_data
  }

  set {
    name  = "enableDeleteOperations"
    value = true
  }

  set {
    name  = "whitelistedNamespaces"
    value = join(",", var.whitelisted_namespaces)
  }

  set {
    name  = "controllerManager.livenessProbe.httpGet.path"
    value = "/healthz"
  }

  set {
    name  = "controllerManager.livenessProbe.httpGet.port"
    value = 9090
  }

  set {
    name  = "controllerManager.readinessProbe.httpGet.path"
    value = "/readyz"
  }

  set {
    name  = "controllerManager.readinessProbe.httpGet.port"
    value = 9090
  }

  set {
    name  = "audit.livenessProbe.httpGet.path"
    value = "/healthz"
  }

  set {
    name  = "audit.livenessProbe.httpGet.port"
    value = 9090
  }

  set {
    name  = "audit.readinessProbe.httpGet.path"
    value = "/readyz"
  }

  set {
    name  = "audit.readinessProbe.httpGet.port"
    value = 9090
  }

  set {
    name  = "controllerManager.resources.requests.cpu"
    value = "500m"
  }

  set {
    name  = "controllerManager.resources.requests.memory"
    value = "512Mi"
  }

  set {
    name  = "controllerManager.resources.limits.cpu"
    value = "2000m"
  }

  set {
    name  = "controllerManager.resources.limits.memory"
    value = "2Gi"
  }

  set {
    name  = "audit.resources.requests.cpu"
    value = "500m"
  }

  set {
    name  = "audit.resources.requests.memory"
    value = "512Mi"
  }

  set {
    name  = "audit.resources.limits.cpu"
    value = "2000m"
  }

  set {
    name  = "audit.resources.limits.memory"
    value = "2Gi"
  }

  depends_on = [kubernetes_namespace.gatekeeper]
}

resource "kubernetes_config_map" "gatekeeper_config" {
  metadata {
    name      = "${var.environment}-${var.naming_prefix}-gatekeeper-config"
    namespace = var.namespace
    labels = merge(var.tags, {
      app       = "gatekeeper"
      component = "security"
    })
  }

  data = {
    constraint_enforcement_action = var.constraint_enforcement_action
    audit_interval               = var.audit_interval
    enable_mutation              = var.enable_mutation ? "true" : "false"
    whitelisted_namespaces      = join(",", var.whitelisted_namespaces)
  }
}
