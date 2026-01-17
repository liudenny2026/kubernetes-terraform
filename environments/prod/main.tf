# 三级架构 - 基础设施层
# 组合模块的顶层配置

provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

provider "random" {
  version = "~> 3.5"
}

# 导入变量
variable "environment" {
  type = string
  default = "prod"
}

variable "component_prefix" {
  type = string
  default = "cloud-native"
}

variable "global_tags" {
  type = map(string)
  default = {
    Environment = "prod"
    CostCenter  = "12345"
    Security    = "cloud-native"
    ManagedBy   = "terraform"
    Project     = "kubernetes-infra"
  }
}

# 基础组件 - 在K8s集群已存在，仅作为模块引用
module "etcd" {
  source       = "../../modules/base/etcd"
  environment  = var.environment
  component    = var.component_prefix
  tags         = var.global_tags
}

module "api_server" {
  source       = "../../modules/base/api-server"
  environment  = var.environment
  component    = var.component_prefix
  tags         = var.global_tags
}

module "controller_manager" {
  source       = "../../modules/base/controller-manager"
  environment  = var.environment
  component    = var.component_prefix
  tags         = var.global_tags
}

module "scheduler" {
  source       = "../../modules/base/scheduler"
  environment  = var.environment
  component    = var.component_prefix
  tags         = var.global_tags
}

module "cloud_controller_manager" {
  source       = "../../modules/base/cloud-controller-manager"
  environment  = var.environment
  component    = var.component_prefix
  tags         = var.global_tags
}

# 基础设施组件
module "istio" {
  source       = "../../modules/infrastructure/istio"
  environment  = var.environment
  component    = var.component_prefix
  tags         = var.global_tags
  namespace    = "istio-system"
  version      = var.istio_version
}

module "rook" {
  source       = "../../modules/infrastructure/rook"
  environment  = var.environment
  component    = var.component_prefix
  tags         = var.global_tags
  namespace    = "rook-ceph"
  version      = var.rook_version
}

module "minio" {
  source       = "../../modules/infrastructure/minio"
  environment  = var.environment
  component    = var.component_prefix
  tags         = var.global_tags
  namespace    = "minio"
  version      = var.minio_version
  storage_size = var.minio_storage_size
}

module "harbor" {
  source       = "../../modules/infrastructure/harbor"
  environment  = var.environment
  component    = var.component_prefix
  tags         = var.global_tags
  namespace    = "harbor"
  version      = var.harbor_version
  domain       = var.harbor_domain
}

# 安全组件
module "neuvector" {
  source       = "../../modules/security/neuvector"
  environment  = var.environment
  component    = var.component_prefix
  tags         = var.global_tags
  namespace    = "neuvector"
  version      = var.neuvector_version
}

module "falco" {
  source       = "../../modules/security/falco"
  environment  = var.environment
  component    = var.component_prefix
  tags         = var.global_tags
  namespace    = "falco"
  version      = var.falco_version
}

module "opa" {
  source       = "../../modules/security/opa"
  environment  = var.environment
  component    = var.component_prefix
  tags         = var.global_tags
  namespace    = "opa"
  version      = var.opa_version
}

module "kyverno" {
  source       = "../../modules/security/kyverno"
  environment  = var.environment
  component    = var.component_prefix
  tags         = var.global_tags
  namespace    = "kyverno"
  version      = var.kyverno_version
}

# 工作流组件
module "kubeflow" {
  source       = "../../modules/workflow/kubeflow"
  environment  = var.environment
  component    = var.component_prefix
  tags         = var.global_tags
  namespace    = "kubeflow"
  version      = var.kubeflow_version
}

module "mlflow" {
  source       = "../../modules/workflow/mlflow"
  environment  = var.environment
  component    = var.component_prefix
  tags         = var.global_tags
  namespace    = "mlflow"
  version      = var.mlflow_version
}

module "gitlab" {
  source       = "../../modules/workflow/gitlab"
  environment  = var.environment
  component    = var.component_prefix
  tags         = var.global_tags
  namespace    = "gitlab"
  version      = var.gitlab_version
  domain       = var.gitlab_domain
}

module "argocd" {
  source       = "../../modules/workflow/argocd"
  environment  = var.environment
  component    = var.component_prefix
  tags         = var.global_tags
  namespace    = "argocd"
  version      = var.argocd_version
  domain       = var.argocd_domain
}

