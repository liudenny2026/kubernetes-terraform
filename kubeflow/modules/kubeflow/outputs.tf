# Kubeflow Module Outputs

output "kubeflow_namespace" {
  description = "Kubeflow namespace"
  value       = kubernetes_namespace_v1.kubeflow.metadata[0].name
}

output "cert_manager_version" {
  description = "Deployed Cert-Manager version"
  value       = helm_release.cert_manager.version
}

output "istio_deployed" {
  description = "Whether Istio was deployed"
  value       = var.deploy_istio
}

output "spark_operator_version" {
  description = "Deployed Spark Operator version"
  value       = helm_release.spark_operator.version
}

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
