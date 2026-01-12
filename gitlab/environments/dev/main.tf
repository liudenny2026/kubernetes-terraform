# Configure the Kubernetes provider to use ~/.kube/config
provider "kubernetes" {
  config_path = "~/.kube/config"
}

# Configure the Helm provider to use ~/.kube/config
provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

# Use the GitLab module
module "gitlab" {
  source = "../../modules/gitlab"

  gitlab_version               = var.gitlab_version
  namespace                    = var.namespace
  storage_class                = var.storage_class
  pvc_size                     = var.pvc_size
  service_type                 = var.service_type
  gitlab_admin_password        = var.gitlab_admin_password
  gitlab_initial_root_password = var.gitlab_initial_root_password
  gitlab_replica_count         = var.gitlab_replica_count
  use_private_registry         = var.use_private_registry
  private_registry_url         = var.private_registry_url
}