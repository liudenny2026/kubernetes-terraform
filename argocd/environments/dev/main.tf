# 调用ArgoCD模块
module "argocd" {
  source = "../../modules/argocd"

  # 使用~/.kube/config文件访问K8s集群
  kube_config_path = var.kube_config_path

  # 可以覆盖默认的命名空间
  namespace = var.namespace

  # 可以指定Helm chart版本
  chart_version = var.chart_version

  # 使用国内镜像源
  image_repository = var.image_repository

  # 额外的Helm values配置
  values = var.values
}