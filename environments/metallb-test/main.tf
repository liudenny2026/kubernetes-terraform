# ============================================================================
# MetalLB Test Environment - Main Configuration
# 三级架构: 基础设施层 - 仅包含MetalLB模块的独立测试环境
# 命名规范: metallb-test-metallb-{resource-type}
# ============================================================================

provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

# MetalLB模块 - 独立测试配置
module "metallb" {
  source = "../../modules/base/metallb"

  # 基础配置
  namespace              = var.metallb_namespace
  ip_address_pool_name   = var.metallb_ip_address_pool_name
  ip_addresses           = var.metallb_ip_addresses
  l2_advertisement_name  = "metallb-test-l2"
  metallb_version        = var.metallb_version
  kube_proxy_strict_arp  = true
  configure_kube_proxy   = true

  # 标签配置
  tags = {
    Environment = "metallb-test"
    CostCenter  = "12345"
    Security    = "cloud-native"
    ManagedBy   = "terraform"
    Project     = "metallb-test"
  }
}

# 输出配置
output "metallb_namespace" {
  value = module.metallb.namespace
}

output "metallb_ip_pool" {
  value = module.metallb.ip_address_pool_name
}

output "metallb_ip_addresses" {
  value = module.metallb.ip_addresses
}
