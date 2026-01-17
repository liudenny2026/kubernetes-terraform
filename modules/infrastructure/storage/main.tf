# Local-Path-Provisioner模块主配置文�?
# 创建命名空间
resource "kubernetes_namespace_v1" "local_path_storage" {
  metadata {
    name = var.namespace
  }
}

# 创建ServiceAccount
resource "kubernetes_service_account_v1" "local_path_provisioner" {
  metadata {
    name      = "local-path-provisioner-service-account"
    namespace = kubernetes_namespace_v1.local_path_storage.metadata[0].name
  }
}

# 创建Role
resource "kubernetes_role_v1" "local_path_provisioner" {
  metadata {
    name      = "local-path-provisioner-role"
    namespace = kubernetes_namespace_v1.local_path_storage.metadata[0].name
  }

  rule {
    api_groups     = [""]
    resources      = ["pods"]
    verbs          = ["get", "list", "watch", "create", "patch", "update", "delete"]
  }
}

# 创建ClusterRole
resource "kubernetes_cluster_role_v1" "local_path_provisioner" {
  metadata {
    name = "local-path-provisioner-role"
  }

  rule {
    api_groups = [""]
    resources  = ["nodes", "persistentvolumeclaims", "configmaps", "pods"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = [""]
    resources  = ["pods/log"]
    verbs      = ["get", "list"]
  }

  rule {
    api_groups = [""]
    resources  = ["persistentvolumes"]
    verbs      = ["get", "list", "watch", "create", "patch", "update", "delete"]
  }

  rule {
    api_groups = [""]
    resources  = ["events"]
    verbs      = ["create", "patch"]
  }

  rule {
    api_groups = ["storage.k8s.io"]
    resources  = ["storageclasses"]
    verbs      = ["get", "list", "watch"]
  }
}

# 创建RoleBinding
resource "kubernetes_role_binding_v1" "local_path_provisioner" {
  metadata {
    name      = "local-path-provisioner-bind"
    namespace = kubernetes_namespace_v1.local_path_storage.metadata[0].name
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role_v1.local_path_provisioner.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account_v1.local_path_provisioner.metadata[0].name
    namespace = kubernetes_namespace_v1.local_path_storage.metadata[0].name
  }
}

# 创建ClusterRoleBinding
resource "kubernetes_cluster_role_binding_v1" "local_path_provisioner" {
  metadata {
    name = "local-path-provisioner-bind"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role_v1.local_path_provisioner.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account_v1.local_path_provisioner.metadata[0].name
    namespace = kubernetes_namespace_v1.local_path_storage.metadata[0].name
  }
}

# 创建Docker Registry Secret（用于私有镜像仓库）
resource "kubernetes_secret_v1" "docker_registry" {
  count = var.docker_registry_enabled ? 1 : 0

  metadata {
    name      = var.docker_registry_secret_name
    namespace = kubernetes_namespace_v1.local_path_storage.metadata[0].name
  }

  type = "kubernetes.io/dockerconfigjson"

  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        "${var.docker_registry_server}" = {
          username = var.docker_registry_username
          password = var.docker_registry_password
          auth     = base64encode("${var.docker_registry_username}:${var.docker_registry_password}")
        }
      }
    })
  }
}
