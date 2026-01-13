provider "kubernetes" {
  config_path = var.kube_config_path
}

# Helm provider uses the same Kubernetes configuration

# Create namespace if it doesn't exist
resource "kubernetes_namespace_v1" "argocd" {
  metadata {
    name = var.namespace
  }
  lifecycle {
    ignore_changes = [
      metadata[0].labels,
    ]
  }
}

# Deploy ArgoCD using Helm command
resource "null_resource" "argocd_deployment" {
  provisioner "local-exec" {
    command = <<-EOF
helm upgrade --install argocd ../../charts/argo-cd-${var.chart_version}.tgz -n ${kubernetes_namespace_v1.argocd.metadata[0].name}\
  --set global.image.repository=m.daocloud.io/quay.io/argoproj\
  --set server.image.repository=m.daocloud.io/quay.io/argoproj/argocd-server\
  --set repoServer.image.repository=m.daocloud.io/quay.io/argoproj/argocd-repo-server\
  --set dex.image.repository=m.daocloud.io/quay.io/argoproj/dex\
  --set redis.image.repository=m.daocloud.io/library/redis\
  --set redis.haproxy.image.repository=m.daocloud.io/library/haproxy\
  --set applicationSet.controller.image.repository=m.daocloud.io/quay.io/argoproj/argocd-applicationset-controller\
  --set notifications.controller.image.repository=m.daocloud.io/quay.io/argoproj/argocd-notifications-controller\
  --set server.service.type=LoadBalancer\
  --set applicationSet.controller.resources.limits.cpu=400m\
  --set applicationSet.controller.resources.limits.memory=512Mi\
  --set applicationSet.controller.resources.requests.cpu=200m\
  --set applicationSet.controller.resources.requests.memory=256Mi\
  --set dex.resources.limits.cpu=400m\
  --set dex.resources.limits.memory=512Mi\
  --set dex.resources.requests.cpu=200m\
  --set dex.resources.requests.memory=256Mi\
  --set notifications.controller.resources.limits.cpu=400m\
  --set notifications.controller.resources.limits.memory=512Mi\
  --set notifications.controller.resources.requests.cpu=200m\
  --set notifications.controller.resources.requests.memory=256Mi\
  --set redis.haproxy.resources.limits.cpu=400m\
  --set redis.haproxy.resources.limits.memory=256Mi\
  --set redis.haproxy.resources.requests.cpu=200m\
  --set redis.haproxy.resources.requests.memory=128Mi\
  --set redis.resources.limits.cpu=400m\
  --set redis.resources.limits.memory=512Mi\
  --set redis.resources.requests.cpu=200m\
  --set redis.resources.requests.memory=256Mi\
  --set repoServer.resources.limits.cpu=1000m\
  --set repoServer.resources.limits.memory=2Gi\
  --set repoServer.resources.requests.cpu=500m\
  --set repoServer.resources.requests.memory=1Gi\
  --set server.resources.limits.cpu=1000m\
  --set server.resources.limits.memory=1Gi\
  --set server.resources.requests.cpu=500m\
  --set server.resources.requests.memory=512Mi
EOF
  }

  depends_on = [
    kubernetes_namespace_v1.argocd,
  ]

  # Force recreation if values change
  triggers = {
    values = yamlencode(var.values)
    chart_version = var.chart_version
  }
}