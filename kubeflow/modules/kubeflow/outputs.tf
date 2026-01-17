# Kubeflow Module Outputs

output "kubeflow_namespace" {
  description = "Kubeflow namespace"
  value       = kubernetes_namespace_v1.kubeflow.metadata[0].name
}

# Outputs for removed components (Cert-Manager, Istio, Helm-based Spark Operator)
# These components should be deployed and managed separately if needed

output "training_operator_manifests" {
  description = "Training Operator manifests"
  value       = kubectl_manifest.training_operator
}

output "kserve_manifests" {
  description = "KServe manifests"
  value       = kubectl_manifest.kserve
}

output "kfp_manifests" {
  description = "Kubeflow Pipelines manifests"
  value       = kubectl_manifest.kfp
}
