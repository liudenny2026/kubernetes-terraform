# Cert-Manager module

terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.12.0"
    }
  }
}

locals {
  chart_name        = "cert-manager"
  chart_repository = "https://charts.jetstack.io"
  chart_version     = var.chart_version
  namespace         = var.namespace
}

resource "kubernetes_namespace" "cert_manager" {
  count = var.create_namespace ? 1 : 0

  metadata {
    name = local.namespace

    labels = {
      name                                 = local.namespace
      "app.kubernetes.io/managed-by"       = "terraform"
      "app.kubernetes.io/instance"        = var.instance_name
      "app.kubernetes.io/component"       = "cert-manager"
      "cert-manager.io/disable-validation" = "false"
    }

    annotations = {
      "cert-manager.io/disable-validation" = "false"
    }
  }
}

# Install cert-manager CRDs
resource "kubectl_manifest" "cert_manager_crds" {
  for_each = [
    "https://github.com/cert-manager/cert-manager/releases/download/v${var.chart_version}/cert-manager.crds.yaml"
  ]

  yaml_body = templatefile("${path.module}/templates/crds.yaml.tpl", {
    crd_url = each.value
  })
}

# Wait for CRDs to be ready
resource "time_sleep" "wait_for_crds" {
  depends_on = [
    kubectl_manifest.cert_manager_crds
  ]
  create_duration = "30s"
}

# Install cert-manager
resource "helm_release" "cert_manager" {
  depends_on = [
    time_sleep.wait_for_crds
  ]

  name       = var.release_name
  repository = local.chart_repository
  chart      = local.chart_name
  version    = local.chart_version
  namespace  = local.namespace

  create_namespace = false

  set {
    name  = "installCRDs"
    value = "false"
  }

  set {
    name  = "replicaCount"
    value = var.replica_count
  }

  set {
    name  = "image.repository"
    value = var.image_repository
  }

  set {
    name  = "image.tag"
    value = var.image_tag
  }

  set {
    name  = "serviceAccount.create"
    value = var.create_service_account
  }

  set {
    name  = "serviceAccount.name"
    value = var.service_account_name
  }

  set {
    name  = "global.leaderElection.namespace"
    value = local.namespace
  }

  set {
    name  = "prometheus.enabled"
    value = var.enable_prometheus_monitoring
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

  lifecycle {
    ignore_changes = [
      # Ignore changes to managed fields that Helm may add
      metadata,
    ]
  }
}

# Create ClusterIssuer for Let's Encrypt (if enabled)
resource "kubectl_manifest" "letsencrypt_staging" {
  count = var.create_letsencrypt_issuer ? 1 : 0

  depends_on = [
    helm_release.cert_manager
  ]

  yaml_body = templatefile("${path.module}/templates/clusterissuer.yaml.tpl", {
    name        = "${var.letsencrypt_issuer_name}-staging"
    namespace   = local.namespace
    email       = var.letsencrypt_email
    server      = "https://acme-staging-v02.api.letsencrypt.org/directory"
    solvers     = var.letsencrypt_solvers
    create_mode = "true"
  }
}

resource "kubectl_manifest" "letsencrypt_production" {
  count = var.create_letsencrypt_issuer ? 1 : 0

  depends_on = [
    helm_release.cert_manager
  ]

  yaml_body = templatefile("${path.module}/templates/clusterissuer.yaml.tpl", {
    name        = "${var.letsencrypt_issuer_name}-production"
    namespace   = local.namespace
    email       = var.letsencrypt_email
    server      = "https://acme-v02.api.letsencrypt.org/directory"
    solvers     = var.letsencrypt_solvers
    create_mode = "true"
  })
}

# Create default Issuer (if enabled)
resource "kubectl_manifest" "selfsigned_issuer" {
  count = var.create_selfsigned_issuer ? 1 : 0

  depends_on = [
    helm_release.cert_manager
  ]

  yaml_body = templatefile("${path.module}/templates/issuer.yaml.tpl", {
    name      = var.selfsigned_issuer_name
    namespace = local.namespace
  })
}
