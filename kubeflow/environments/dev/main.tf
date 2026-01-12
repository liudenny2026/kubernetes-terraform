# Kubeflow Dev Environment
# This file calls the kubeflow module for dev environment

module "kubeflow" {
  source = "../../modules/kubeflow"

  kube_config_path     = var.kube_config_path
  deploy_istio         = var.deploy_istio
  cert_manager_version = var.cert_manager_version
  istio_version        = var.istio_version
  kubeflow_version     = var.kubeflow_version

  spark_operator_chart      = "../../manifests/spark-operator.tgz"
  training_operator_manifest = "../../manifests/training-operator.yaml"
  katib_manifest             = "../../manifests/katib-operator.yaml"
  kserve_manifest            = "../../manifests/kserve.yaml"
  kserve_runtimes_manifest   = "../../manifests/kserve-runtimes.yaml"
  kfp_manifest               = "../../manifests/kfp.yaml"
  model_registry_manifest    = "../../manifests/model-registry.yaml"
}
