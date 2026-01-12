# Terraform configuration for Harbor deployment using Helm
# 最佳实践：使用 Terraform 管理 Helm Chart 的部署
terraform {
  required_version = ">= 1.0"
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.16"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.0"
    }
  }
}

# Kubernetes provider configuration
provider "kubernetes" {
  config_path = var.kube_config_path != "" ? var.kube_config_path : "~/.kube/config"
}

# Helm provider configuration
provider "helm" {
  kubernetes {
    config_path = var.kube_config_path != "" ? var.kube_config_path : "~/.kube/config"
  }
}

# Local Path Provisioner ConfigMap
# 注意：local-path-provisioner 的 ConfigMap 通常由集群自动管理
# 如果需要自定义配置，请先检查是否已存在
# 下面是可选的 ConfigMap 创建（如果已存在会报错，可注释掉）
# resource "kubernetes_config_map_v1" "local_path_config" {
#   metadata {
#     name      = "local-path-config"
#     namespace = "local-path-storage"
#   }
#   data = {
#     "config.json" = jsonencode({
#       nodePathMap = [{
#         node  = "DEFAULT_PATH_FOR_NON_LISTED_NODES",
#         paths = ["/opt/local-path-provisioner"]
#       }]
#     })
#     "helperPod.yaml" = yamlencode({
#       apiVersion = "v1"
#       kind       = "Pod"
#       metadata = {
#         name = "helper-pod"
#       }
#       spec = {
#         containers = [{
#           name            = "helper-pod",
#           image           = "busybox:1.36.1",
#           imagePullPolicy = "IfNotPresent"
#         }]
#         priorityClassName = "system-node-critical"
#         tolerations = [{
#           effect   = "NoSchedule",
#           key      = "node.kubernetes.io/disk-pressure",
#           operator = "Exists"
#         }]
#       }
#     })
#     "setup"    = <<EOF
# #!/bin/sh
# set -eu
# mkdir -m 0777 -p "$VOL_DIR"
# EOF
#     "teardown" = <<EOF
# #!/bin/sh
# set -eu
# rm -rf "$VOL_DIR"
# EOF
#   }
# }

# Random password for Harbor admin (sensitive)
resource "random_password" "harbor_admin_password" {
  length           = 16
  special          = true
  min_numeric      = 1
  min_special      = 1
  override_special = "!@#$%"
}

# Generate Harbor values file from template
locals {
  harbor_values_yaml = templatefile("${path.module}/values.tftpl", {
    harbor_admin_password = random_password.harbor_admin_password.result
    storage_class         = var.storage_class
  })
}

# Harbor Helm Release
resource "helm_release" "harbor" {
  name       = "harbor"
  repository = "https://helm.goharbor.io"
  chart      = "harbor"
  version    = "1.18.1"
  namespace  = "harbor"

  create_namespace = true

  timeout = 600

  # Use rendered values file
  values = [local.harbor_values_yaml]
}
