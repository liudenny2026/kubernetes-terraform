# Velero module - Backup and Restore for Kubernetes

terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.12.0"
    }
  }
}

locals {
  chart_name        = "velero"
  chart_repository = "https://vmware-tanzu.github.io/helm-charts"
  chart_version     = var.chart_version
  namespace         = var.namespace
}

resource "kubernetes_namespace" "velero" {
  count = var.create_namespace ? 1 : 0

  metadata {
    name = local.namespace

    labels = {
      name                           = local.namespace
      "app.kubernetes.io/managed-by"  = "terraform"
      "app.kubernetes.io/instance"   = var.instance_name
      "app.kubernetes.io/component"  = "velero"
    }
  }
}

resource "kubernetes_secret" "velero_s3_credentials" {
  count = var.cloud_provider == "aws" && var.create_s3_secret ? 1 : 0

  metadata {
    name      = var.s3_credentials_secret_name
    namespace = local.namespace

    labels = {
      "app.kubernetes.io/name"       = var.chart_name
      "app.kubernetes.io/instance"   = var.release_name
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }

  type = "Opaque"

  data = {
    "cloud" = templatefile("${path.module}/templates/s3-credentials.tpl", {
      access_key_id     = var.s3_access_key_id
      secret_access_key = var.s3_secret_access_key
    })
  }

  lifecycle {
    ignore_changes = [data]
  }
}

resource "kubernetes_secret" "velero_azure_credentials" {
  count = var.cloud_provider == "azure" && var.create_azure_secret ? 1 : 0

  metadata {
    name      = var.azure_credentials_secret_name
    namespace = local.namespace

    labels = {
      "app.kubernetes.io/name"       = var.chart_name
      "app.kubernetes.io/instance"   = var.release_name
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }

  type = "Opaque"

  data = {
    "cloud" = templatefile("${pathmodule}/templates/azure-credentials.tpl", {
      subscription_id = var.azure_subscription_id
      tenant_id       = var.azure_tenant_id
      client_id       = var.azure_client_id
      client_secret   = var.azure_client_secret
    })
  }

  lifecycle {
    ignore_changes = [data]
  }
}

resource "kubernetes_secret" "velero_gcs_credentials" {
  count = var.cloud_provider == "gcp" && var.create_gcs_secret ? 1 : 0

  metadata {
    name      = var.gcs_credentials_secret_name
    namespace = local.namespace

    labels = {
      "app.kubernetes.io/name"       = var.chart_name
      "app.kubernetes.io/instance"   = var.release_name
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }

  type = "Opaque"

  data = {
    "cloud" = templatefile("${path.module}/templates/gcs-credentials.tpl", {
      credentials = var.gcs_credentials
    })
  }

  lifecycle {
    ignore_changes = [data]
  }
}

resource "helm_release" "velero" {
  depends_on = [
    kubernetes_secret.velero_s3_credentials,
    kubernetes_secret.velero_azure_credentials,
    kubernetes_secret.velero_gcs_credentials
  ]

  name       = var.release_name
  repository = local.chart_repository
  chart      = local.chart_name
  version    = local.chart_version
  namespace  = local.namespace

  create_namespace = false

  set {
    name  = "configuration.provider"
    value = var.cloud_provider
  }

  set {
    name  = "configuration.backupStorageLocation.name"
    value = var.backup_storage_location_name
  }

  set {
    name  = "configuration.backupStorageLocation.bucket"
    value = var.backup_bucket_name
  }

  set {
    name  = "configuration.backupStorageLocation.prefix"
    value = var.backup_prefix
  }

  set {
    name  = "configuration.volumeSnapshotLocation.name"
    value = var.snapshot_location_name
  }

  set {
    name  = "configuration.volumeSnapshotLocation.bucket"
    value = var.snapshot_bucket_name
  }

  set {
    name  = "serviceAccount.server.create"
    value = var.create_service_account
  }

  set {
    name  = "serviceAccount.server.name"
    value = var.service_account_name
  }

  set {
    name  = "configuration.volumeSnapshotLocation.config.region"
    value = var.region
  }

  set {
    name  = "initContainers[0].name"
    value = "velero-plugin-for-aws"
  }

  set {
    name  = "initContainers[0].image"
    value = var.plugin_image_aws
  }

  set {
    name  = "initContainers[0].volumeMounts[0].mountPath"
    value = "/target"
  }

  set {
    name  = "initContainers[1].name"
    value = "velero-plugin-for-csi"
  }

  set {
    name  = "initContainers[1].image"
    value = var.plugin_image_csi
  }

  set {
    name  = "initContainers[1].volumeMounts[0].mountPath"
    value = "/target"
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
    name  = "upgradeCRDs"
    value = var.upgrade_crds
  }

  set {
    name  = "installCRDs"
    value = var.install_crds
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
    name  = "snapshotsEnabled"
    value = var.enable_snapshots
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
    name  = "schedules[0].name"
    value = var.schedule_name
  }

  set {
    name  = "schedules[0].schedule"
    value = var.schedule_cron
  }

  set {
    name  = "schedules[0].template.ttl"
    value = var.backup_ttl
  }

  set {
    name  = "schedules[0].template.includedNamespaces[0]"
    value = var.backup_included_namespaces[0]
  }

  set {
    name  = "useRestic"
    value = var.use_restic
  }

  set {
    name  = "restic.enabled"
    value = var.use_restic
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
