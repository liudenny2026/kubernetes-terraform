provider "kubernetes" {
  config_path = var.kube_config_path != null ? var.kube_config_path : "~/.kube/config"
}

provider "kubectl" {
  config_path = var.kube_config_path != null ? var.kube_config_path : "~/.kube/config"
}
