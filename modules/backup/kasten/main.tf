# Kasten K10 enterprise backup solution module

terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.12.0"
    }
  }
}

locals {
  chart_name        = "k10"
  chart_repository = "https://charts.kasten.io"
  chart_version     = var.chart_version
  namespace         = var.namespace
}

resource "kubernetes_namespace" "k10" {
  count = var.create_namespace ? 1 : 0

  metadata {
    name = local.namespace

    labels = {
      name                           = local.namespace
      "app.kubernetes.io/managed-by"  = "terraform"
      "app.kubernetes.io/instance"   = var.instance_name
      "app.kubernetes.io/component"  = "k10"
    }
  }
}

resource "random_password" "k10_password" {
  length  = 32
  special = false
}

resource "helm_release" "k10" {
  name       = var.release_name
  repository = local.chart_repository
  chart      = local.chart_name
  version    = local.chart_version
  namespace  = local.namespace

  create_namespace = false

  set {
    name  = "replicaCount"
    value = var.replica_count
  }

  set {
    name  = "image.tag"
    value = var.image_tag
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

  set {
    name  = "metrics.enabled"
    value = var.enable_metrics
  }

  set {
    name  = "metrics.serviceMonitor.enabled"
    value = var.enable_service_monitor
  }

  dynamic "set" {
    for_each = var.extra_sets
    content {
      name  = set.value.name
      value = set.value.value
      type  = lookup(set.value, "type", null)
    }
  }

  timeout = var.timeout

  lifecycle {
    ignore_changes = [metadata]
  }
}
