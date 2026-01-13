module "prometheus_monitoring" {
  source = "../../modules/prometheus"

  kubeconfig_path            = var.kubeconfig_path
  namespace                  = var.namespace
  enable_istio_monitoring    = var.enable_istio_monitoring
  enable_ceph_monitoring     = var.enable_ceph_monitoring
  enable_metallb_monitoring  = var.enable_metallb_monitoring
  enable_kubeflow_monitoring = var.enable_kubeflow_monitoring
  enable_mlflow_monitoring   = var.enable_mlflow_monitoring
  enable_minio_monitoring    = var.enable_minio_monitoring
  storage_class              = var.storage_class
  registry_mirror            = var.registry_mirror
}
