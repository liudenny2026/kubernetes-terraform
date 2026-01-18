# Local-Path-Provisioner模块变量定义

variable "namespace" {
  description = "Kubernetes命名空间"
  type        = string
  default     = "local-path-storage"
}

variable "storage_class_name" {
  description = "StorageClass名称"
  type        = string
  default     = "local-path"
}

variable "provisioner_image" {
  description = "Local-Path-Provisioner镜像地址"
  type        = string
  default     = "rancher/local-path-provisioner:v0.0.34"
}

variable "helper_pod_image" {
  description = "Helper Pod镜像地址"
  type        = string
  default     = "busybox:1.36"
}

variable "default_path" {
  description = "默认存储路径"
  type        = string
  default     = "/data/local-path-Storage"
}

variable "is_default_storage_class" {
  description = "是否设为默认StorageClass"
  type        = bool
  default     = false
}

variable "replicas" {
  description = "Local-Path-Provisioner副本数量"
  type        = number
  default     = 1
}

variable "node_path_map" {
  description = "节点路径映射配置"
  type        = list(object({
    node  = string
    paths = list(string)
  }))
  default = [{
    node  = "DEFAULT_PATH_FOR_NON_LISTED_NODES"
    paths = ["/data/local-path-Storage"]
  }]
}

variable "image_pull_secrets" {
  description = "镜像拉取Secret列表（用于私有镜像仓库）"
  type        = list(string)
  default     = []
}

variable "docker_registry_enabled" {
  description = "是否创建Docker Registry Secret"
  type        = bool
  default     = true
}

variable "docker_registry_secret_name" {
  description = "Docker Registry Secret名称"
  type        = string
  default     = "harbor-secret"
}

variable "docker_registry_server" {
  description = "Docker Registry服务器地址"
  type        = string
  default     = "192.168.40.248"
}

variable "docker_registry_username" {
  description = "Docker Registry用户�?
  type        = string
  default     = "admin"
  sensitive   = true
}

variable "docker_registry_password" {
  description = "Docker Registry密码"
  type        = string
  default     = "Harbor12345"
  sensitive   = true
}
