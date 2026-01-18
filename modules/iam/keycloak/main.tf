# Keycloak module - Identity and Access Management

terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.12.0"
    }
  }
}

locals {
  chart_name        = "keycloak"
  chart_repository = "https://charts.bitnami.com/bitnami"
  chart_version     = var.chart_version
  namespace         = var.namespace
}

resource "kubernetes_namespace" "keycloak" {
  count = var.create_namespace ? 1 : 0

  metadata {
    name = local.namespace

    labels = {
      name                           = local.namespace
      "app.kubernetes.io/managed-by"  = "terraform"
      "app.kubernetes.io/instance"   = var.instance_name
      "app.kubernetes.io/component"  = "keycloak"
    }
  }
}

resource "kubernetes_secret" "keycloak_admin_password" {
  count = var.create_admin_secret ? 1 : 0

  metadata {
    name      = "${var.release_name}-admin"
    namespace = local.namespace

    labels = {
      "app.kubernetes.io/name"       = var.chart_name
      "app.kubernetes.io/instance"   = var.release_name
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }

  type = "Opaque"

  data = {
    password = var.admin_password
  }

  lifecycle {
    ignore_changes = [data]
  }
}

resource "random_password" "keycloak_db_password" {
  count = var.create_database ? 1 : 0

  length  = 32
  special = false
}

resource "kubernetes_secret" "keycloak_db_password" {
  count = var.create_database && var.create_db_secret ? 1 : 0

  metadata {
    name      = "${var.release_name}-postgresql"
    namespace = local.namespace

    labels = {
      "app.kubernetes.io/name"       = var.chart_name
      "app.kubernetes.io/instance"   = var.release_name
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }

  type = "Opaque"

  data = {
    postgres-password = random_password.keycloak_db_password[0].result
    password         = random_password.keycloak_db_password[0].result
  }
}

resource "helm_release" "keycloak" {
  depends_on = [
    kubernetes_secret.keycloak_admin_password,
    kubernetes_secret.keycloak_db_password
  ]

  name       = var.release_name
  repository = local.chart_repository
  chart      = local.chart_name
  version    = local.chart_version
  namespace  = local.namespace

  create_namespace = false

  set {
    name  = "auth.adminUser"
    value = var.admin_user
  }

  set {
    name  = "auth.adminPassword"
    value = var.admin_password
  }

  set {
    name  = "auth.createAdminUser"
    value = var.create_admin_user
  }

  set {
    name  = "replicaCount"
    value = var.replica_count
  }

  set {
    name  = "image.tag"
    value = var.image_tag
  }

  set {
    name  = "service.type"
    value = var.service_type
  }

  set {
    name  = "service.ports.http"
    value = var.http_port
  }

  set {
    name  = "service.ports.https"
    value = var.https_port
  }

  set {
    name  = "ingress.enabled"
    value = var.ingress_enabled
  }

  set {
    name  = "ingress.hostname"
    value = var.ingress_hostname
  }

  set {
    name  = "ingress.className"
    value = var.ingress_class_name
  }

  set {
    name  = "ingress.tls"
    value = var.ingress_tls
  }

  set {
    name  = "ingress.selfSigned"
    value = var.ingress_self_signed
  }

  set {
    name  = "ingress.annotations"
    value = join(",", [for k, v in var.ingress_annotations : "${k}=${v}"])
  }

  set {
    name  = "proxy.address"
    value = var.proxy_address
  }

  set {
    name  = "proxy.hostname"
    value = var.proxy_hostname
  }

  set {
    name  = "proxy.ports.http"
    value = var.http_port
  }

  set {
    name  = "proxy.ports.https"
    value = var.https_port
  }

  set {
    name  = "proxy.nodePorts.http"
    value = var.http_node_port
  }

  set {
    name  = "proxy.nodePorts.https"
    value = var.https_node_port
  }

  set {
    name  = "database.vendor"
    value = var.database_vendor
  }

  set {
    name  = "postgresql.enabled"
    value = var.create_database
  }

  dynamic "set" {
    for_each = var.create_database ? [{
      name  = "postgresql.auth.password"
      value = random_password.keycloak_db_password[0].result
    }] : []
    content {
      name  = set.value.name
      value = set.value.value
    }
  }

  set {
    name  = "metrics.enabled"
    value = var.enable_metrics
  }

  set {
    name  = "metrics.serviceMonitor.enabled"
    value = var.enable_service_monitor
  }

  set {
    name  = "production"
    value = var.production_mode
  }

  set {
    name  = "postgresql.primary.persistence.enabled"
    value = var.db_persistence_enabled
  }

  set {
    name  = "postgresql.primary.persistence.size"
    value = var.db_storage_size
  }

  set {
    name  = "postgresql.primary.resources.requests.memory"
    value = var.db_memory_request
  }

  set {
    name  = "postgresql.primary.resources.requests.cpu"
    value = var.db_cpu_request
  }

  set {
    name  = "resources.requests.memory"
    value = var.memory_request
  }

  set {
    name  = "resources.requests.cpu"
    value = var.cpu_request
  }

  set {
    name  = "resources.limits.memory"
    value = var.memory_limit
  }

  set {
    name  = "resources.limits.cpu"
    value = var.cpu_limit
  }

  dynamic "set" {
    for_each = var.extra_sets
    content {
      name  = set.value.name
      value = set.value.value
      type  = lookup(set.value, "type", null)
    }
  }

  dynamic "set_list" {
    for_each = var.set_list
    content {
      name  = set_list.value.name
      value = set_list.value.value
    }
  }

  dynamic "set_sensitive" {
    for_each = var.set_sensitive
    content {
      name  = set_sensitive.value.name
      value = set_sensitive.value.value
    }
  }

  timeout = var.timeout

  lifecycle {
    ignore_changes = [
      metadata
    ]
  }
}

# Wait for Keycloak to be ready
resource "time_sleep" "wait_for_keycloak" {
  depends_on = [
    helm_release.keycloak
  ]

  create_duration = "60s"
}

# Create Keycloak realm (if enabled)
resource "keycloak_realm" "main" {
  count = var.create_realm ? 1 : 0

  depends_on = [
    time_sleep.wait_for_keycloak
  ]

  realm   = var.realm_name
  enabled = true

  display_name = var.realm_display_name
  login_theme  = var.realm_theme

  ssl_required = var.realm_ssl_required
}
