# MetalLB 模块使用示例

## 1. 基本使用（默认配置）

```hcl
module "metallb" {
  source = "../../modules/base/metallb"
}
```

## 2. 多IP地址池配置

```hcl
module "metallb" {
  source = "../../modules/base/metallb"

  ip_address_pools = [
    {
      name      = "metallb-pool-1"
      addresses = ["192.168.40.100-192.168.40.110"]
      auto_assign = true
    },
    {
      name      = "metallb-pool-2"
      addresses = ["192.168.40.120-192.168.40.130"]
      auto_assign = false
      avoid_buggy_ips = true
      block_size = 24
    },
    {
      name      = "metallb-pool-cidr"
      addresses = ["192.168.50.0/24"]
      auto_assign = true
    }
  ]
}
```

## 3. 高级L2广告配置

```hcl
module "metallb" {
  source = "../../modules/base/metallb"

  ip_address_pools = [
    {
      name      = "metallb-frontend-pool"
      addresses = ["192.168.40.100-192.168.40.110"]
    },
    {
      name      = "metallb-backend-pool"
      addresses = ["192.168.40.120-192.168.40.130"]
    }
  ]

  l2_advertisements = [
    {
      name                 = "frontend-l2-advert"
      ip_address_pools     = ["metallb-frontend-pool"]
      interfaces           = ["eth0"]
      node_selectors       = [
        {
          match_labels = {
            "node-role.kubernetes.io/worker" = "true"
            "network-role" = "frontend"
          }
        }
      ]
    },
    {
      name                 = "backend-l2-advert"
      ip_address_pools     = ["metallb-backend-pool"]
      interfaces           = ["eth1"]
      node_selectors       = [
        {
          match_labels = {
            "node-role.kubernetes.io/worker" = "true"
            "network-role" = "backend"
          },
          match_expressions = [
            {
              key      = "kubernetes.io/os"
              operator = "In"
              values   = ["linux"]
            }
          ]
        }
      ]
    }
  ]
}
```

## 4. BGP模式支持

```hcl
module "metallb" {
  source = "../../modules/base/metallb"

  ip_address_pools = [
    {
      name      = "metallb-bgp-pool"
      addresses = ["10.0.0.100-10.0.0.200"]
    }
  ]

  # BGP对等体配置
  bgp_peers = [
    {
      name           = "bgp-peer-1"
      my_asn         = 65000
      peer_asn       = 65001
      peer_address   = "192.168.1.1"
      peer_port      = 179
      hold_time      = "10s"
      keepalive_time = "30s"
      router_id      = "192.168.1.2"
      node_selectors = [
        {
          match_labels = {
            "node-role.kubernetes.io/control-plane" = "true"
          }
        }
      ]
    },
    {
      name           = "bgp-peer-2"
      my_asn         = 65000
      peer_asn       = 65002
      peer_address   = "192.168.1.2"
      password_secret = {
        name = "bgp-password"
        key  = "password"
      }
    }
  ]

  # BGP广告配置
  bgp_advertisements = [
    {
      name                    = "bgp-advert-1"
      ip_address_pools        = ["metallb-bgp-pool"]
      aggregation_length      = 24
      local_pref              = 100
      communities             = ["65000:100", "no-export"]
    }
  ]
}
```

## 5. 混合模式配置

```hcl
module "metallb" {
  source = "../../modules/base/metallb"

  ip_address_pools = [
    # L2模式IP池
    {
      name      = "metallb-l2-pool"
      addresses = ["192.168.40.100-192.168.40.110"]
    },
    # BGP模式IP池
    {
      name      = "metallb-bgp-pool"
      addresses = ["10.0.0.100-10.0.0.200"]
    }
  ]

  # L2广告配置
  l2_advertisements = [
    {
      name                 = "l2-advert"
      ip_address_pools     = ["metallb-l2-pool"]
      interfaces           = ["eth0"]
    }
  ]

  # BGP对等体配置
  bgp_peers = [
    {
      name           = "bgp-peer"
      my_asn         = 65000
      peer_asn       = 65001
      peer_address   = "192.168.1.1"
    }
  ]

  # BGP广告配置
  bgp_advertisements = [
    {
      name                    = "bgp-advert"
      ip_address_pools        = ["metallb-bgp-pool"]
    }
  ]
}
```

## 6. 禁用kube-proxy配置

```hcl
module "metallb" {
  source = "../../modules/base/metallb"

  configure_kube_proxy = false
}
```
