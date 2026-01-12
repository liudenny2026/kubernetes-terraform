# MetalLB 根模块入口
module "metallb" {
  source = "../../modules/metallb"

  # 命名空间配置
  namespace = var.namespace

  # IP地址池配置
  ip_address_pool_name = var.ip_address_pool_name
  ip_addresses         = var.ip_addresses

  # L2Advertisement配置
  l2_advertisement_name = var.l2_advertisement_name

  # kube-proxy strictARP配置
  kube_proxy_strict_arp = var.kube_proxy_strict_arp


  # MetalLB版本
  metallb_version = var.metallb_version
}
