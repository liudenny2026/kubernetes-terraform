# ============================================================================
# Development Environment - Main Configuration
# 三级架构: 基础设施层 - 组合模块的顶层配置
# 命名规范: dev-cloud-native-{component}-{resource-type}
# ============================================================================

# ----------------------------------------------------------------------------
# 核心网络组件 - 生产环境已部署，dev环境仅作引用，不实际部署
# 确保这些组件不会被意外修改
# ----------------------------------------------------------------------------

# CoreDNS - 已在集群中部署，dev环境仅作引用
# 注释掉模块定义，避免Terraform检查配置语法
/*
module "coredns" {
  count = 0
  source = "../../modules/base/coredns"

  environment     = var.environment
  component       = var.naming_prefix
  namespace       = "kube-system"
  coredns_version = var.versions.coredns
  coredns_replicas = 1

  tags = var.tags
}
*/

# Calico - 已在集群中部署，dev环境仅作引用
# 注释掉模块定义，避免Terraform检查配置语法
/*
module "calico" {
  count = 0
  source = "../../modules/base/calico"

  environment     = var.environment
  naming_prefix   = var.naming_prefix
  namespace       = "kube-system"
  calico_version  = var.versions.calico

  tags = var.tags
}
*/

# ----------------------------------------------------------------------------
# 开发阶段第一个模块：MetalLB
# 作为开发阶段的第一个部署模块
# ----------------------------------------------------------------------------

module "metallb" {
  source = "../../modules/base/metallb"

  # 基础配置
  namespace              = "metallb-system"
  metallb_version        = var.versions.metallb
  configure_kube_proxy   = true

  # IP地址池配置
  ip_address_pools = [
    {
      name      = "metallb-dev-pool"
      addresses = ["192.168.40.150-192.168.40.160"]
      auto_assign = true
    }
  ]

  # L2广告配置
  l2_advertisements = [
    {
      name                 = "metallb-dev-l2"
      ip_address_pools     = ["metallb-dev-pool"]
    }
  ]

  tags = var.tags
}

# ----------------------------------------------------------------------------
# 其他模块 - 开发阶段暂不部署，如需启用请取消注释并调整配置
# ----------------------------------------------------------------------------

# module "istio" {
#   source = "../../modules/infrastructure/istio"
# 
#   environment       = var.environment
#   naming_prefix     = var.naming_prefix
#   namespace         = "istio-system"
#   istio_version     = var.versions.istio
#   istiod_replicas   = 1
#   istio_ingressgateway_replicas = 1
#   istio_egressgateway_replicas  = 1
#   enable_mtls       = false
#   enable_auto_injection = true
# 
#   tags = var.tags
# }

# module "minio" {
#   source = "../../modules/infrastructure/minio"
# 
#   environment        = var.environment
#   naming_prefix      = var.naming_prefix
#   namespace          = "minio-system"
#   minio_version      = "RELEASE.2024-01-16T16-07-38Z"
#   minio_replicas     = 1
#   storage_size       = "50Gi"
#   storage_class      = "standard"
#   access_key         = "minioadmin"
#   secret_key         = var.minio_secret_key
#   console_enabled    = true
#   service_type       = "ClusterIP"
#   enable_tls         = false
# 
#   tags = var.tags
# }

# module "falco" {
#   source = "../../modules/security/falco"
# 
#   environment        = var.environment
#   naming_prefix      = var.naming_prefix
#   namespace          = "falco"
#   falco_version      = "0.38.0"
#   enable_auditd      = true
#   enable_stdout     = true
#   log_level          = "info"
# 
#   tags = var.tags
# }

# module "kyverno" {
#   source = "../../modules/security/kyverno"
# 
#   environment               = var.environment
#   naming_prefix             = var.naming_prefix
#   namespace                 = "kyverno"
#   kyverno_version           = "v1.12.0"
#   replicas                  = 1
#   create_self_signed_cert   = true
#   enable_policy_reporting   = false
#   enable_admission_reports  = false
#   background_scan_enabled  = false
#   background_scan_interval  = 24
#   exclude_namespaces        = ["kube-system", "kyverno", "neuvector"]
#   log_level                 = "debug"
# 
#   tags = var.tags
# }

# module "mlflow" {
#   source = "../../modules/workflow/mlflow"
# 
#   environment                = var.environment
#   naming_prefix              = var.naming_prefix
#   namespace                  = "mlflow"
#   mlflow_version             = "2.10.0"
#   replicas                   = 1
#   backend_store_type         = "sqlite"
#   default_artifact_root      = "/mlflow-artifacts"
#   storage_size               = "20Gi"
#   storage_class              = "standard"
#   domain_name                = "mlflow.dev.example.com"
#   enable_tracking            = true
#   enable_models              = false
#   enable_projects            = true
#   postgresql_password        = var.mlflow_password
#   service_type               = "ClusterIP"
# 
#   tags = var.tags
# }

# module "argocd" {
#   source = "../../modules/workflow/argocd"
# 
#   environment              = var.environment
#   naming_prefix            = var.naming_prefix
#   namespace                = "argocd"
#   argocd_version           = "5.33.0"
#   replicas                 = 1
#   redis_replicas           = 1
#   redis_ha_enabled         = false
#   domain_name              = "argocd.dev.example.com"
#   enable_tls               = false
#   argocd_admin_password    = var.argocd_password
#   sync_interval            = 180
#   self_heal_enabled        = false
#   auto_prune_enabled       = false
# 
#   tags = var.tags
# }
