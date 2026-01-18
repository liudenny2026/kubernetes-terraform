resource "helm_release" "this" {
  name       = var.release_name
  repository = var.repository
  chart      = var.chart
  version    = var.chart_version
  namespace  = var.namespace

  create_namespace = var.create_namespace

  values = [
    var.custom_values
  ]

  set {
    name  = "replicaCount"
    value = var.replica_count
  }

  set {
    name  = "persistence.enabled"
    value = var.persistence_enabled
  }

  set {
    name  = "persistence.size"
    value = var.persistence_size
  }

  set {
    name  = "service.type"
    value = var.service_type
  }

  set {
    name  = "adminUser"
    value = var.admin_user
  }

  set {
    name  = "adminPassword"
    value = var.admin_password
  }

  set {
    name  = "plugins"
    value = var.plugins
  }

  set {
    name  = "service.port"
    value = var.service_port
  }

  dynamic "set" {
    for_each = var.extra_settings
    content {
      name  = set.value.name
      value = set.value.value
    }
  }

  timeout = var.timeout

  depends_on = [
    kubernetes_secret.grafana_admin_secret
  ]
}

resource "kubernetes_namespace" "grafana" {
  count = var.create_namespace ? 1 : 0

  metadata {
    name = var.namespace
    labels = {
      name        = var.namespace
      environment = var.environment
      managed-by  = "terraform"
    }
  }
}

resource "random_password" "grafana_admin_password" {
  length           = 32
  special          = true
  override_special = "!@#$%&*()-_=+[]{}<>?"
}

resource "kubernetes_secret" "grafana_admin_secret" {
  metadata {
    name      = "grafana-admin-credentials"
    namespace = var.namespace
  }

  type = "Opaque"

  data = {
    username = var.admin_user
    password = var.admin_password != "" ? var.admin_password : random_password.grafana_admin_password.result
  }
}

data "helm_repository" "grafana" {
  name = "grafana"
  url  = var.repository
}

# Grafana Data Source for Prometheus
resource "helm_release" "grafana_datasource" {
  count = var.prometheus_datasource_enabled ? 1 : 0

  name       = "${var.release_name}-datasources"
  repository = var.repository
  chart      = "grafana"
  version    = var.chart_version
  namespace  = var.namespace

  values = [
    templatefile("${path.module}/datasources.yaml", {
      prometheus_url = var.prometheus_datasource_url
    })
  ]

  depends_on = [helm_release.this]
}
