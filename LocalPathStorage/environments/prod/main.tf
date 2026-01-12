# Local-Path-Provisioner根模块入口

module "local_path_storage" {
  source = "../../modules/local-path-storage"

  # 命名空间配置
  namespace = var.namespace

  # 存储类配置
  storage_class_name       = var.storage_class_name
  is_default_storage_class = var.is_default_storage_class

  # 镜像配置
  provisioner_image = var.provisioner_image
  helper_pod_image  = var.helper_pod_image

  # 路径配置
  default_path = var.default_path

  # 节点路径映射配置
  node_path_map = var.node_path_map

  # 部署配置
  replicas = var.replicas

  # 镜像拉取Secret配置
  image_pull_secrets = var.image_pull_secrets

  # Docker Registry Secret配置
  docker_registry_enabled     = var.docker_registry_enabled
  docker_registry_secret_name = var.docker_registry_secret_name
  docker_registry_server      = var.docker_registry_server
  docker_registry_username    = var.docker_registry_username
  docker_registry_password    = var.docker_registry_password
}