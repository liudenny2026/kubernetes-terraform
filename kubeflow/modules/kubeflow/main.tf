# Kubeflow Module
# This module deploys all Kubeflow components

# Namespace for Kubeflow
resource "kubernetes_namespace_v1" "kubeflow" {
  metadata {
    name = "kubeflow"
  }
}

# -----------------------------------------------------------------------------
# Note: Helm deployments (cert-manager, istio) have been removed.
# These components should be deployed separately using official manifests
# if needed. Refer to official Kubeflow documentation for manual installation.
# -----------------------------------------------------------------------------


# -----------------------------------------------------------------------------
# 3. Kubeflow Spark Operator (Manifest)
# -----------------------------------------------------------------------------
data "kubectl_file_documents" "spark_operator" {
  content = file("${path.module}/../../manifests/spark-operator.yaml")
}

resource "kubectl_manifest" "spark_operator" {
  for_each  = data.kubectl_file_documents.spark_operator.documents
  yaml_body = each.value
  depends_on = [kubernetes_namespace_v1.kubeflow]
}

# -----------------------------------------------------------------------------
# 4. Spark Operator CRDs
# -----------------------------------------------------------------------------
resource "kubectl_manifest" "spark_operator_crds" {
  yaml_body = <<-EOF
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  name: sparkapplications.sparkoperator.k8s.io
spec:
  group: sparkoperator.k8s.io
  versions:
  - name: v1beta2
    served: true
    storage: true
    schema:
      openAPIV3Schema:
        type: object
        properties:
          spec:
            type: object
            properties:
              type:
                type: string
              sparkVersion:
                type: string
              mode:
                type: string
              image:
                type: string
              restartPolicy:
                type: object
              volumes:
                type: array
              driver:
                type: object
              executor:
                type: object
          status:
            type: object
    subresources:
      status: {}
  scope: Namespaced
  names:
    plural: sparkapplications
    singular: sparkapplication
    kind: SparkApplication
    shortNames:
    - sparkapp
EOF
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
    kubernetes_namespace_v1.kubeflow
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

# -----------------------------------------------------------------------------
# 9. Dex Authentication (Manifests)
# -----------------------------------------------------------------------------
data "kubectl_file_documents" "dex" {
  content = file(var.dex_manifest)
}

resource "kubectl_manifest" "dex" {
  for_each  = data.kubectl_file_documents.dex.manifests
  yaml_body = each.value
  depends_on = [kubernetes_namespace_v1.kubeflow]
}

# -----------------------------------------------------------------------------
# 10. Central Dashboard (Manifests)
# -----------------------------------------------------------------------------
data "kubectl_file_documents" "centraldashboard" {
  content = file(var.centraldashboard_manifest)
}

resource "kubectl_manifest" "centraldashboard" {
  for_each  = data.kubectl_file_documents.centraldashboard.manifests
  yaml_body = each.value
  depends_on = [kubernetes_namespace_v1.kubeflow]
}

# -----------------------------------------------------------------------------# 11. Jupyter Web App (Manifests)# -----------------------------------------------------------------------------
data "kubectl_file_documents" "jupyter_web_app" {
  content = file(var.jupyter_web_app_manifest)
}

resource "kubectl_manifest" "jupyter_web_app" {
  for_each  = data.kubectl_file_documents.jupyter_web_app.manifests
  yaml_body = each.value
  depends_on = [
    kubernetes_namespace_v1.kubeflow,
    kubectl_manifest.centraldashboard
  ]
}

# -----------------------------------------------------------------------------# 12. Profile Controller (Manifests)# -----------------------------------------------------------------------------
data "kubectl_file_documents" "profile_controller" {
  content = file(var.profile_controller_manifest)
}

resource "kubectl_manifest" "profile_controller" {
  for_each  = data.kubectl_file_documents.profile_controller.manifests
  yaml_body = each.value
  depends_on = [kubernetes_namespace_v1.kubeflow]
}