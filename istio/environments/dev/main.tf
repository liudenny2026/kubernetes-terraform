# ==============================================================================
# Dev Environment - Istio部署配置
# ==============================================================================

module "istio" {
  source = "../../modules/istio"

  # Istio版本配置
  istio_version = "1.28.0"

  # 命名空间配置
  istio_namespace = var.istio_namespace

  # 镜像仓库配置
  registry_mirror = var.registry_mirror

  # Helm Chart配置
  use_local_charts = true

  # 组件开关
  enable_istiod  = var.enable_istiod
  enable_ingress = var.enable_ingress
  enable_egress  = var.enable_egress

  # 副本数配置
  istiod_replicas  = var.istiod_replicas
  ingress_replicas = var.ingress_replicas

  # Ingress Gateway配置
  ingress_service_type = var.ingress_service_type

  # 自动扩缩容
  enable_autoscaling = var.enable_autoscaling

  # 资源配置
  resources = var.resources
}
