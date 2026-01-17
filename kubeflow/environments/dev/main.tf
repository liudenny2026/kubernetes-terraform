# Kubeflow Dev Environment
# This file calls the kubeflow module for dev environment

module "kubeflow" {
  source = "../../modules/kubeflow"

  kube_config_path     = var.kube_config_path
  kubeflow_version     = var.kubeflow_version

  training_operator_manifest = "../../manifests/training-operator.yaml"
  katib_manifest             = "../../manifests/katib-operator.yaml"
  kserve_manifest            = "../../manifests/kserve.yaml"
  kserve_runtimes_manifest   = "../../manifests/kserve-runtimes.yaml"
  kfp_manifest               = "../../manifests/kfp.yaml"
  model_registry_manifest    = "../../manifests/model-registry.yaml"
  dex_manifest               = "../../manifests/dex.yaml"
  centraldashboard_manifest  = "../../manifests/centraldashboard.yaml"
  jupyter_web_app_manifest   = "../../manifests/jupyter-web-app.yaml"
  profile_controller_manifest = "../../manifests/profile-controller.yaml"
}
