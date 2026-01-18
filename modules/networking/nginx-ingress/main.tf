resource "helm_release" "this" {
  name       = var.release_name
  repository = var.repository
  chart      = var.chart
  version    = var.chart_version
  namespace  = var.namespace

  create_namespace = var.create_namespace

  values = [
    var.custom_values
  ]

  set {
    name  = "controller.replicaCount"
    value = var.replica_count
  }

  set {
    name  = "controller.service.type"
    value = var.service_type
  }

  set {
    name  = "controller.service.loadBalancerIP"
    value = var.load_balancer_ip
  }

  set {
    name  = "controller.ingressClassResource.name"
    value = var.ingress_class_name
  }

  set {
    name  = "controller.ingressClassResource.enabled"
    value = var.ingress_class_enabled
  }

  set {
    name  = "controller.ingressClassResource.default"
    value = var.ingress_class_default
  }

  set {
    name  = "controller.ingressClassResource.controllerValue"
    value = "k8s.io/ingress-${var.ingress_class_name}"
  }

  set {
    name  = "controller.metrics.enabled"
    value = var.metrics_enabled
  }

  set {
    name  = "controller.service.annotations"
    value = var.service_annotations
  }

  set {
    name  = "controller.admissionWebhooks.enabled"
    value = var.admission_webhooks_enabled
  }

  set {
    name  = "controller.resources.requests.cpu"
    value = var.resources_cpu_request
  }

  set {
    name  = "controller.resources.requests.memory"
    value = var.resources_memory_request
  }

  set {
    name  = "controller.resources.limits.cpu"
    value = var.resources_cpu_limit
  }

  set {
    name  = "controller.resources.limits.memory"
    value = var.resources_memory_limit
  }

  set {
    name  = "controller.nodeSelector"
    value = var.node_selector
  }

  set {
    name  = "controller.tolerations"
    value = var.tolerations
  }

  set {
    name  = "controller.affinity"
    value = var.affinity
  }

  dynamic "set" {
    for_each = var.extra_settings
    content {
      name  = set.value.name
      value = set.value.value
    }
  }

  timeout = var.timeout
}

resource "kubernetes_namespace" "nginx_ingress" {
  count = var.create_namespace ? 1 : 0

  metadata {
    name = var.namespace
    labels = {
      name        = var.namespace
      environment = var.environment
      managed-by  = "terraform"
    }
  }
}

data "helm_repository" "nginx_ingress" {
  name = "ingress-nginx"
  url  = var.repository
}

# Wait for NGINX Ingress to be ready
resource "time_sleep" "wait_for_ingress" {
  create_duration = var.wait_duration

  depends_on = [helm_release.this]
}
