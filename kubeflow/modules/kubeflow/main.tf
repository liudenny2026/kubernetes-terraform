# Kubeflow Module
# This module deploys all Kubeflow components

# Namespace for Kubeflow
resource "kubernetes_namespace_v1" "kubeflow" {
  metadata {
    name = "kubeflow"
  }
}

# -----------------------------------------------------------------------------
# 1. Cert Manager (Prerequisite)
# -----------------------------------------------------------------------------
resource "helm_release" "cert_manager" {
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  version          = var.cert_manager_version
  namespace        = "cert-manager"
  create_namespace = true
  timeout          = 600

  values = [
    yamlencode({
      installCRDs = true
    })
  ]
}

# -----------------------------------------------------------------------------
# 2. Istio (Prerequisite)
# -----------------------------------------------------------------------------
resource "helm_release" "istio_base" {
  count            = var.deploy_istio ? 1 : 0
  name             = "istio-base"
  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "base"
  version          = var.istio_version
  namespace        = "istio-system"
  create_namespace = true
  timeout          = 600
}

resource "helm_release" "istiod" {
  count      = var.deploy_istio ? 1 : 0
  name       = "istiod"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "istiod"
  version    = var.istio_version
  namespace  = "istio-system"
  depends_on = [helm_release.istio_base]
  timeout    = 600
}

resource "helm_release" "istio_ingress" {
  count      = var.deploy_istio ? 1 : 0
  name       = "istio-ingressgateway"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "gateway"
  version    = var.istio_version
  namespace  = "istio-system"
  depends_on = [helm_release.istiod]
  timeout    = 600
}

# -----------------------------------------------------------------------------
# 3. Kubeflow Spark Operator (Helm)
# -----------------------------------------------------------------------------
resource "helm_release" "spark_operator" {
  name             = "spark-operator"
  chart            = var.spark_operator_chart
  version          = "2.4.0"
  namespace        = "kubeflow"
  create_namespace = true
  timeout          = 600

  values = [
    yamlencode({
      sparkJobNamespace = "kubeflow"
    })
  ]

  depends_on = [kubernetes_namespace_v1.kubeflow]
}

# -----------------------------------------------------------------------------
# 4. Kubeflow Training Operator (Manifests)
# -----------------------------------------------------------------------------
data "kubectl_file_documents" "training_operator" {
  content = file(var.training_operator_manifest)
}

resource "kubectl_manifest" "training_operator" {
  for_each  = data.kubectl_file_documents.training_operator.manifests
  yaml_body = each.value
  depends_on = [kubernetes_namespace_v1.kubeflow]
}

# -----------------------------------------------------------------------------
# 5. Kubeflow Katib (Manifests)
# -----------------------------------------------------------------------------
data "kubectl_file_documents" "katib" {
  content = file(var.katib_manifest)
}

resource "kubectl_manifest" "katib" {
  for_each  = data.kubectl_file_documents.katib.manifests
  yaml_body = each.value
  depends_on = [kubernetes_namespace_v1.kubeflow]
}

# -----------------------------------------------------------------------------
# 6. KServe (Manifests)
# -----------------------------------------------------------------------------
data "kubectl_file_documents" "kserve" {
  content = file(var.kserve_manifest)
}

resource "kubectl_manifest" "kserve" {
  for_each  = data.kubectl_file_documents.kserve.manifests
  yaml_body = each.value

  depends_on = [
    helm_release.cert_manager,
  ]
}

data "kubectl_file_documents" "kserve_runtimes" {
  content = file(var.kserve_runtimes_manifest)
}

resource "kubectl_manifest" "kserve_runtimes" {
  for_each  = data.kubectl_file_documents.kserve_runtimes.manifests
  yaml_body = each.value
  depends_on = [kubectl_manifest.kserve]
}

# -----------------------------------------------------------------------------
# 7. Kubeflow Pipelines (Manifests)
# -----------------------------------------------------------------------------
data "kubectl_file_documents" "kfp" {
  content = file(var.kfp_manifest)
}

resource "kubectl_manifest" "kfp" {
  for_each  = data.kubectl_file_documents.kfp.manifests
  yaml_body = each.value
  force_new = false
  depends_on = [
    helm_release.cert_manager,
    kubernetes_namespace_v1.kubeflow
  ]
}

# -----------------------------------------------------------------------------
# 8. Kubeflow Model Registry (Manifests)
# -----------------------------------------------------------------------------
data "kubectl_file_documents" "model_registry" {
  content = file(var.model_registry_manifest)
}

resource "kubectl_manifest" "model_registry" {
  for_each  = data.kubectl_file_documents.model_registry.manifests
  yaml_body = each.value
  depends_on = [kubernetes_namespace_v1.kubeflow]
}
