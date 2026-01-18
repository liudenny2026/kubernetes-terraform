# ============================================================================
# Production Environment - Main Configuration
# 三级架构: 基础设施层 - 组合模块的顶层配置
# 命名规范: prod-cloud-native-{component}-{resource-type}
# ============================================================================

# 基础设施组件 - 生产环境高可用部署
module "metallb" {
  source = "../../modules/base/metallb"

  # 基础配置
  namespace              = "metallb-system"
  metallb_version        = var.versions.metallb
  configure_kube_proxy   = true

  # 生产环境IP地址池配置
  ip_address_pools = [
    {
      name      = "metallb-prod-pool"
      addresses = var.metallb_ip_ranges
      auto_assign = true
    }
  ]

  # L2广告配置
  l2_advertisements = [
    {
      name                 = "metallb-prod-l2"
      ip_address_pools     = ["metallb-prod-pool"]
    }
  ]

  tags = var.tags
}
