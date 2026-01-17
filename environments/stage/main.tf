# ============================================================================
# Stage Environment - Main Configuration
# 三级架构: 基础设施层 - 组合模块的顶层配置
# 命名规范: stage-cloud-native-{component}-{resource-type}
# ============================================================================

module "coredns" {
  source = "../../modules/base/coredns"

  environment     = var.environment
  naming_prefix   = var.naming_prefix
  namespace       = "kube-system"
  coredns_version = var.versions.coredns
  coredns_replicas = 1

  tags = var.tags
}

module "istio" {
  source = "../../modules/infrastructure/istio"

  environment       = var.environment
  naming_prefix     = var.naming_prefix
  namespace         = "istio-system"
  istio_version     = var.versions.istio
  istiod_replicas   = 2
  istio_ingressgateway_replicas = 2
  istio_egressgateway_replicas  = 1
  enable_mtls       = true
  enable_auto_injection = true

  tags = var.tags
}

module "rook_ceph" {
  source = "../../modules/infrastructure/rook-ceph"

  environment             = var.environment
  naming_prefix           = var.naming_prefix
  rook_namespace          = "rook-ceph"
  ceph_cluster_namespace  = "rook-ceph"
  rook_version            = "v1.14.0"
  ceph_version            = "v18.2.0"
  osd_count               = 2
  osd_disk_size           = "50Gi"
  mon_count               = 2
  mgr_count               = 1
  enable_ceph_fs          = true
  enable_rbd              = true
  ceph_fs_pool_size       = 2
  rbd_pool_size           = 2
  enable_dashboard        = true
  enable_monitoring       = true

  tags = var.tags
}

module "minio" {
  source = "../../modules/infrastructure/minio"

  environment        = var.environment
  naming_prefix      = var.naming_prefix
  namespace          = "minio-system"
  minio_version      = "RELEASE.2024-01-16T16-07-38Z"
  minio_replicas     = 2
  storage_size       = "200Gi"
  storage_class      = "ceph-rbd"
  access_key         = "minioadmin"
  secret_key         = var.minio_secret_key
  console_enabled    = true
  service_type       = "ClusterIP"
  enable_tls         = false

  tags = var.tags
}

module "harbor" {
  source = "../../modules/infrastructure/harbor"

  environment            = var.environment
  naming_prefix          = var.naming_prefix
  namespace              = "harbor-system"
  harbor_version         = "1.15.0"
  harbor_domain          = "harbor.stage.example.com"
  expose_type            = "ingress"
  storage_size           = "50Gi"
  storage_class          = "ceph-rbd"
  harbor_admin_password  = var.harbor_password
  enable_tls             = true
  enable_trivy           = true
  enable_notary          = false
  replicas               = 1

  tags = var.tags
}

module "neuvector" {
  source = "../../modules/security/neuvector"

  environment            = var.environment
  naming_prefix          = var.naming_prefix
  namespace              = "neuvector"
  neuvector_version      = "5.2.0"
  controller_replicas    = 2
  enable_admission_control = true
  enable_waf             = true
  enable_dlp             = false
  admin_password         = var.neuvector_password
  cve_scan_enabled       = true
  scan_frequency         = 24

  tags = var.tags
}

module "falco" {
  source = "../../modules/security/falco"

  environment        = var.environment
  naming_prefix      = var.naming_prefix
  namespace          = "falco"
  falco_version      = "0.38.0"
  enable_auditd      = true
  enable_stdout     = true
  log_level          = "info"

  tags = var.tags
}

module "opa" {
  source = "../../modules/security/opa"

  environment                  = var.environment
  naming_prefix                = var.naming_prefix
  namespace                    = "gatekeeper-system"
  gatekeeper_version           = "3.16.0"
  replicas                    = 2
  audit_interval               = 300
  constraint_enforcement_action = "warn"
  enable_mutation              = false
  whitelisted_namespaces      = ["kube-system", "gatekeeper-system", "neuvector"]
  log_level                    = "INFO"

  tags = var.tags
}

module "kyverno" {
  source = "../../modules/security/kyverno"

  environment               = var.environment
  naming_prefix             = var.naming_prefix
  namespace                 = "kyverno"
  kyverno_version           = "v1.12.0"
  replicas                  = 2
  create_self_signed_cert   = true
  enable_policy_reporting   = true
  enable_admission_reports  = true
  background_scan_enabled  = false
  background_scan_interval  = 24
  exclude_namespaces        = ["kube-system", "kyverno", "neuvector"]
  log_level                 = "info"

  tags = var.tags
}

module "kubeflow" {
  source = "../../modules/workflow/kubeflow"

  environment              = var.environment
  naming_prefix            = var.naming_prefix
  namespace                = "kubeflow"
  kubeflow_version         = "1.8.0"
  pipelines_replicas       = 2
  notebook_replicas        = 1
  storage_size             = "50Gi"
  storage_class            = "ceph-rbd"
  domain_name              = "kubeflow.stage.example.com"
  enable_auth              = true
  enable_monitoring        = true
  custom_components        = ["pipelines", "notebooks"]
  mlflow_enabled           = false

  tags = var.tags
}

module "mlflow" {
  source = "../../modules/workflow/mlflow"

  environment                = var.environment
  naming_prefix              = var.naming_prefix
  namespace                  = "mlflow"
  mlflow_version             = "2.10.0"
  replicas                   = 1
  backend_store_type         = "sqlite"
  default_artifact_root      = "s3://mlflow-artifacts"
  storage_size               = "50Gi"
  storage_class              = "ceph-rbd"
  domain_name                = "mlflow.stage.example.com"
  enable_tracking            = true
  enable_models              = true
  enable_projects            = true
  postgresql_password        = var.mlflow_password
  service_type               = "ClusterIP"

  tags = var.tags
}

module "gitlab" {
  source = "../../modules/workflow/gitlab"

  environment              = var.environment
  naming_prefix            = var.naming_prefix
  namespace                = "gitlab"
  gitlab_version           = "7.10.0"
  gitlab_domain            = "gitlab.stage.example.com"
  registry_domain          = "registry.stage.example.com"
  replicas                 = 1
  storage_size             = "20Gi"
  storage_class            = "ceph-rbd"
  gitlab_root_password     = var.gitlab_password
  enable_https             = true
  enable_registry          = true
  enable_runner            = false
  smtp_enabled             = false

  tags = var.tags
}

module "argocd" {
  source = "../../modules/workflow/argocd"

  environment              = var.environment
  naming_prefix            = var.naming_prefix
  namespace                = "argocd"
  argocd_version           = "5.33.0"
  replicas                 = 2
  redis_replicas           = 1
  redis_ha_enabled         = false
  domain_name              = "argocd.stage.example.com"
  enable_tls               = true
  argocd_admin_password    = var.argocd_password
  sync_interval            = 120
  self_heal_enabled        = true
  auto_prune_enabled       = true

  tags = var.tags
}
