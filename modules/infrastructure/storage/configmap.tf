# Local-Path-Provisioner ConfigMap配置

# 创建ConfigMap
resource "kubernetes_config_map_v1" "local_path_config" {
  metadata {
    name      = "local-path-config"
    namespace = kubernetes_namespace_v1.local_path_storage.metadata[0].name
  }

  data = {
    "config.json" = jsonencode({
      nodePathMap = var.node_path_map
    })
    "setup" = <<EOF
#!/bin/sh
set -eu
mkdir -m 0777 -p "$VOL_DIR"
EOF
    "teardown" = <<EOF
#!/bin/sh
set -eu
rm -rf "$VOL_DIR"
EOF
    "helperPod.yaml" = yamlencode({
      apiVersion = "v1"
      kind       = "Pod"
      metadata   = {
        name = "helper-pod"
      }
      spec = {
        priorityClassName = "system-node-critical"
        tolerations = [
          {
            key      = "node.kubernetes.io/disk-pressure"
            operator = "Exists"
            effect   = "NoSchedule"
          }
        ]
        containers = [
          {
            name            = "helper-pod"
            image           = var.helper_pod_image
            imagePullPolicy = "IfNotPresent"
          }
        ]
        imagePullSecrets = var.docker_registry_enabled ? [{
          name = var.docker_registry_secret_name
        }] : null
      }
    })
  }
}
