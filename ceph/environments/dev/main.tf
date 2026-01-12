# Terraform configuration for deploying Ceph on Kubernetes

terraform {
  required_version = ">= 1.0"
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.0"
    }
  }
}

# Configure Kubernetes provider
provider "kubernetes" {
  config_path    = var.k8s_config_path
  config_context = var.k8s_context
}

# Configure Helm provider
provider "helm" {
  kubernetes = {
    config_path    = var.k8s_config_path
    config_context = var.k8s_context
  }
}

# Create namespace for Ceph
resource "kubernetes_namespace_v1" "ceph" {
  metadata {
    name = var.ceph_namespace
  }
}

# Deploy Rook Ceph operator via Helm
resource "helm_release" "rook_ceph_operator" {
  name       = "rook-ceph"
  repository = "https://charts.rook.io/release"
  chart      = "rook-ceph"
  version    = "v1.18.8"  # Latest stable version
  namespace  = var.ceph_namespace

  values = [
    yamlencode({
      "enableDiscoveryDaemon" = true,
      "image" = {
        "repository" = "192.168.40.248/library/rook/ceph",
        "tag" = "v1.18.8"
      },
      "csi" = {
        "rbd" = {
          "image" = "192.168.40.248/library/cephcsi/cephcsi:v3.15.0"
        },
        "cephfs" = {
          "image" = "192.168.40.248/library/cephcsi/cephcsi:v3.15.0"
        },
        "provisionerImage" = "192.168.40.248/library/sig-storage/csi-provisioner:v5.2.0",
        "resizerImage" = "192.168.40.248/library/sig-storage/csi-resizer:v1.13.2",
        "attacherImage" = "192.168.40.248/library/sig-storage/csi-attacher:v4.8.1",
        "snapshotterImage" = "192.168.40.248/library/sig-storage/csi-snapshotter:v8.2.1",
        "registrarImage" = "192.168.40.248/sig-storage/csi-node-driver-registrar:v2.13.0"
      }
    })
  ]
}

# Deploy Ceph cluster using the module
module "ceph_cluster" {
  source = "../../modules/ceph"

  namespace           = var.ceph_namespace
  cluster_name        = var.ceph_cluster_name
  node_names          = var.node_names
  storage_devices     = var.storage_devices
  storage_size        = var.storage_size
  monitor_count       = var.monitor_count
  enable_dashboard    = var.enable_dashboard
  ingress_enabled     = var.dashboard_ingress_enabled
  ingress_host        = var.dashboard_ingress_host

  depends_on = [
    kubernetes_namespace_v1.ceph,
    helm_release.rook_ceph_operator
  ]
}