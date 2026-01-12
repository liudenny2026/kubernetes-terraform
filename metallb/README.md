# MetalLB Terraform 部署

使用 Terraform 将 MetalLB 部署到 Kubernetes 集群。

## 目录结构

```
metallb/
├── environments/
│   └── dev/                    # 开发环境配置
│       ├── main.tf            # 主入口文件
│       ├── provider.tf        # Provider配置
│       ├── variables.tf       # 变量定义
│       ├── outputs.tf         # 输出定义
│       ├── terraform.tfvars   # 变量值
│       └── versions.tf        # Terraform版本约束
├── modules/
│   └── metallb/               # MetalLB模块
│       ├── main.tf            # 主配置文件
│       ├── variables.tf       # 变量定义
│       ├── outputs.tf         # 输出定义
│       └── versions.tf        # Terraform版本约束
└── .gitignore
```

## 前置要求

1. 已安装 Terraform >= 1.6
2. Kubernetes集群已配置 ~/.kube/config
3. Kubernetes集群有管理员权限
4. kubectl 可用（用于配置 kube-proxy）

## 快速开始

### 1. 部署 MetalLB

```bash
cd environments/dev
terraform init
terraform apply
```

### 2. 验证部署

```bash
# 查看 MetalLB Pod 状态
kubectl get pods -n metallb-system

# 查看 IP 地址池
kubectl get ipaddresspool -n metallb-system

# 查看 L2Advertisement
kubectl get l2advertisement -n metallb-system
```

## 变量说明

| 变量名 | 描述 | 默认值 |
|--------|------|--------|
| namespace | Kubernetes命名空间 | metallb-system |
| ip_address_pool_name | IPAddressPool名称 | metallb-pool |
| ip_addresses | IP地址池 | ["192.168.40.100-192.168.40.110"] |
| l2_advertisement_name | L2Advertisement名称 | metallb-l2 |
| kube_proxy_strict_arp | kube-proxy strictARP配置（L2模式必需） | true |
| enable_ip_address_pool | 是否创建IPAddressPool | true |
| enable_l2_advertisement | 是否创建L2Advertisement | true |

## kube-proxy 配置

MetalLB L2 模式要求 kube-proxy 开启 strictARP 参数。Terraform 会自动配置：

```bash
kubectl get configmap kube-proxy -n kube-system -o yaml | grep -A 5 config.conf
```

**注意事项：**
- strictARP 是 MetalLB L2 模式的必需配置
- 修改 kube-proxy ConfigMap 后，kube-proxy Pod 会自动重启
- 确保 kube-proxy 使用 IPVS 模式

## 使用 LoadBalancer Service

部署完成后，创建 LoadBalancer 类型的 Service：

```yaml
apiVersion: v1
kind: Service
metadata:
  name: example-service
spec:
  type: LoadBalancer
  selector:
    app: example
  ports:
  - port: 80
    targetPort: 8080
```

MetalLB 将自动从配置的 IP 地址池中分配一个 IP 地址。

## 清理部署

```bash
terraform destroy
```
