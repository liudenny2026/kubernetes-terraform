provider "kubernetes" {
  config_path    = var.kubeconfig_path
  config_context = null  # Use current context from kubeconfig
}

provider "helm" {
  kubernetes {
    config_path    = var.kubeconfig_path
    config_context = null  # Use current context from kubeconfig
  }
}