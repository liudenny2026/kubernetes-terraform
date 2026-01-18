# RabbitMQ module - Message Broker

terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.12.0"
    }
  }
}

locals {
  chart_name        = "rabbitmq"
  chart_repository = "https://charts.bitnami.com/bitnami"
  chart_version     = var.chart_version
  namespace         = var.namespace
}

resource "kubernetes_namespace" "rabbitmq" {
  count = var.create_namespace ? 1 : 0

  metadata {
    name = local.namespace

    labels = {
      name                           = local.namespace
      "app.kubernetes.io/managed-by"  = "terraform"
      "app.kubernetes.io/instance"   = var.instance_name
      "app.kubernetes.io/component"  = "rabbitmq"
    }
  }
}

resource "random_password" "rabbitmq_password" {
  length  = 32
  special = false
}

resource "kubernetes_secret" "rabbitmq" {
  count = var.create_secret ? 1 : 0

  metadata {
    name      = var.rabbitmq_secret_name
    namespace = local.namespace

    labels = {
      "app.kubernetes.io/name"       = var.chart_name
      "app.kubernetes.io/instance"   = var.release_name
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }

  type = "Opaque"

  data = {
    rabbitmq-password = random_password.rabbitmq_password.result
    erlang-cookie     = random_password.rabbitmq_password.result
  }

  lifecycle {
    ignore_changes = [data]
  }
}

resource "helm_release" "rabbitmq" {
  depends_on = [
    kubernetes_secret.rabbitmq
  ]

  name       = var.release_name
  repository = local.chart_repository
  chart      = local.chart_name
  version    = local.chart_version
  namespace  = local.namespace

  create_namespace = false

  set {
    name  = "auth.username"
    value = var.rabbitmq_username
  }

  set {
    name  = "auth.password"
    value = random_password.rabbitmq_password.result
  }

  set {
    name  = "auth.existingPasswordSecret"
    value = var.create_secret ? var.rabbitmq_secret_name : ""
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
    name  = "persistence.enabled"
    value = var.persistence_enabled
  }

  set {
    name  = "persistence.size"
    value = var.persistence_size
  }

  set {
    name  = "persistence.storageClass"
    value = var.storage_class
  }

  set {
    name  = "service.type"
    value = var.service_type
  }

  set {
    name  = "service.ports.amqp"
    value = var.amqp_port
  }

  set {
    name  = "service.ports.management"
    value = var.management_port
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
    name  = "topologySpreadConstraints.enabled"
    value = var.topology_spread_constraints_enabled
  }

  set {
    name  = "topologySpreadConstraints.maxSkew"
    value = var.topology_spread_max_skew
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
    name  = "ingress.tls"
    value = var.ingress_tls
  }

  set {
    name  = "ingress.certManager"
    value = var.cert_manager_enabled
  }

  set {
    name  = "loadBalancer.enabled"
    value = var.load_balancer_enabled
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
