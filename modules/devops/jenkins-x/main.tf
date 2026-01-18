# Jenkins X Cloud Native CI/CD Module - Main Configuration
# Naming convention: ${var.environment}-${var.naming_prefix}-wf-jx-{resource-type}

# Create Jenkins X namespace
resource "kubernetes_namespace" "jenkins_x" {
  metadata {
    name = var.namespace
    labels = merge(
      var.tags,
      {
        "name"                          = var.namespace
        "prod-cloud-native-component"  = "jenkins-x"
        "prod-cloud-native-resource"   = "namespace"
      }
    )
  }
}

# Deploy Jenkins X using Helm Chart
resource "helm_release" "jenkins_x" {
  name       = "${var.environment}-${var.naming_prefix}-wf-jx"
  repository = var.jenkins_x_repository
  chart      = var.jenkins_x_chart_name
  version    = var.jenkins_x_chart_version
  namespace  = kubernetes_namespace.jenkins_x.metadata[0].name
  timeout    = 1200

  set {
    name  = "workload.app.git.owner"
    value = var.git_owner
  }

  set {
    name  = "workload.app.git.repository"
    value = "environment-${var.cluster_name}-dev"
  }

  set {
    name  = "cluster.registry"
    value = "docker.io"
  }

  set {
    name  = "cluster.provider"
    value = var.provider
  }

  set {
    name  = "cluster.projectId"
    value = var.cluster_name
  }

  set {
    name  = "cluster.zone"
    value = "us-central1-a"
  }

  set {
    name  = "cluster.clusterName"
    value = var.cluster_name
  }

  set {
    name  = "cluster.envCluster"
    value = "false"
  }

  set {
    name  = "cluster.namespace"
    value = var.namespace
  }

  set {
    name  = "cluster.helmfileRef"
    value = "git::https://github.com/jenkins-x/jxr-openshift3/blob/master/helmfile.yaml"
  }

  set {
    name  = "cluster.versionStreamRef"
    value = var.version_stream_ref
  }

  set {
    name  = "ingress.domain"
    value = var.domain
  }

  set {
    name  = "ingress.tls.production"
    value = "false"
  }

  set {
    name  = "ingress.tls.email"
    value = var.tls_email
  }

  set {
    name  = "preview.ingress.domain"
    value = var.domain
  }

  set {
    name  = "resources.requests.cpu"
    value = var.cpu_request
  }

  set {
    name  = "resources.requests.memory"
    value = var.memory_request
  }

  set {
    name  = "resources.limits.cpu"
    value = var.cpu_limit
  }

  set {
    name  = "resources.limits.memory"
    value = var.memory_limit
  }

  set {
    name  = "ingress.ingressClass"
    value = var.ingress_class
  }

  set {
    name  = "pipelineUser.username"
    value = "jenkins-x-bot"
  }

  set {
    name  = "pipelineUser.email"
    value = var.tls_email
  }

  set {
    name  = "pipelineUser.token"
    value = var.git_token
  }

  depends_on = [kubernetes_namespace.jenkins_x]
}