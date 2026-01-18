# MetalLB 部署指南

## 概述

MetalLB 是一个用于裸机 Kubernetes 集群的负载均衡器实现。本指南介绍如何在开发或生产环境中部署 MetalLB。

## 目录结构

```
environments/
├── dev/                    # 开发环境
├── prod/                   # 生产环境
└── metallb-test/           # MetalLB 独立测试环境
    ├── main.tf            # 主配置文件
    ├── variables.tf       # 变量定义
    ├── versions.tf       # Provider 版本
    └── terraform.tfvars  # 变量值
```

## 部署方式

### 方式一：在独立测试环境中部署（推荐用于测试）

这是最简单的方式，仅部署 MetalLB 模块，适合快速测试。

#### 步骤 1：配置 kubeconfig 路径

编辑 `environments/metallb-test/terraform.tfvars`:

```hcl
# 集群连接配置
kubeconfig_path = "d:/文档/GitHub/kubernetes-terraform/config/dev-config"
config_context  = "kubernetes-admin@kubekey.kubernetes.dev"

# MetalLB 配置
metallb_namespace            = "metallb-system"
metallb_ip_address_pool_name = "metallb-test-pool"
metallb_ip_addresses         = ["192.168.40.170-192.168.40.180"]
metallb_version              = "v0.15.3"
```

#### 步骤 2：规划部署

```powershell
cd environments\metallb-test

# 规划（查看将要创建的资源）
terraform plan

# 或指定不同的 kubeconfig
terraform plan -var="kubeconfig_path=d:/文档/GitHub/kubernetes-terraform/config/dev-config"
```

#### 步骤 3：部署

```powershell
# 部署 MetalLB
terraform apply

# 或指定不同的 kubeconfig
terraform apply -var="kubeconfig_path=d:/文档/GitHub/kubernetes-terraform/config/dev-config"
```

#### 步骤 4：验证

```powershell
# 检查 MetalLB 命名空间
kubectl --kubeconfig="d:/文档/GitHub/kubernetes-terraform/config/dev-config" get ns metallb-system

# 检查 MetalLB Pods
kubectl --kubeconfig="d:/文档/GitHub/kubernetes-terraform/config/dev-config" get pods -n metallb-system

# 检查 MetalLB Speaker
kubectl --kubeconfig="d:/文档/GitHub/kubernetes-terraform/config/dev-config" get pods -n metallb-system -l app=metallb,component=speaker
```

---

### 方式二：在开发环境中部署

在完整的开发环境中部署 MetalLB。

#### 步骤 1：配置 kubeconfig

编辑 `environments/dev/terraform.tfvars`:

```hcl
# 集群连接配置
kubeconfig_path = "d:/文档/GitHub/kubernetes-terraform/config/dev-config"
config_context  = "kubernetes-admin@kubekey.kubernetes.dev"

# MetalLB 配置（在 main.tf 中已定义）
# IP 地址池: 192.168.40.150-192.168.40.160
```

#### 步骤 2：部署

```powershell
cd environments\dev
terraform init
terraform plan
terraform apply
```

#### 步骤 3：验证

```powershell
# 检查 MetalLB
kubectl get pods -n metallb-system

# 查看分配的 IP
kubectl get svc
```

---

### 方式三：在生产环境中部署

在生产环境中部署 MetalLB（使用生产配置）。

#### 步骤 1：配置 kubeconfig

编辑 `environments/prod/terraform.tfvars`:

```hcl
# 集群连接配置
kubeconfig_path = "d:/文档/GitHub/kubernetes-terraform/config/prod-config"
config_context  = "kubernetes-admin@kubekey.kubernetes.prod"

# MetalLB 配置
# IP 地址池: 192.168.40.200-192.168.40.250
```

#### 步骤 2：部署

```powershell
cd environments\prod
terraform init
terraform plan
terraform apply
```

---

## IP 地址池配置

### 开发环境
```hcl
ip_address_pools = [
  {
    name      = "metallb-dev-pool"
    addresses = ["192.168.40.150-192.168.40.160"]
  }
]
```

### 生产环境
```hcl
ip_address_pools = [
  {
    name      = "metallb-prod-pool"
    addresses = ["192.168.40.200-192.168.40.250"]
  }
]
```

### 测试环境
```hcl
ip_address_pools = [
  {
    name      = "metallb-test-pool"
    addresses = ["192.168.40.170-192.168.40.180"]
  }
]
```

---

## 使用 PowerShell 快捷函数

如果你已经运行了 `scripts/windows-setup.ps1`，可以使用以下快捷函数：

### 切换到开发环境
```powershell
kdev
```

### 切换到生产环境
```powershell
kprod
```

### 查看当前环境
```powershell
kcurrent
```

### 查看 MetalLB 状态
```powershell
# 切换到目标环境后
kdev
kubectl get pods -n metallb-system
kubectl get svc -A
```

---

## 指定不同的 kubeconfig

### 方式一：在 terraform.tfvars 中指定（推荐）

编辑对应的 `terraform.tfvars` 文件：

```hcl
# 使用开发集群
kubeconfig_path = "d:/文档/GitHub/kubernetes-terraform/config/dev-config"

# 使用生产集群
kubeconfig_path = "d:/文档/GitHub/kubernetes-terraform/config/prod-config"
```

### 方式二：使用命令行变量

```powershell
# 部署到开发集群
terraform apply -var="kubeconfig_path=d:/文档/GitHub/kubernetes-terraform/config/dev-config"

# 部署到生产集群
terraform apply -var="kubeconfig_path=d:/文档/GitHub/kubernetes-terraform/config/prod-config"
```

### 方式三：使用环境变量

```powershell
# 临时设置
$env:KUBECONFIG = "d:/文档/GitHub/kubernetes-terraform/config/dev-config"
terraform apply
```

---

## 验证 MetalLB 部署

### 1. 检查控制器
```powershell
kubectl get deployment -n metallb-system controller
```

期望输出：
```
NAME         READY   UP-TO-DATE   AVAILABLE   AGE
controller   1/1     1            1           2m
```

### 2. 检查 Speaker
```powershell
kubectl get daemonset -n metallb-system speaker
```

期望输出：
```
NAME      DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR   AGE
speaker   2         2         2       2            2           <none>          2m
```

### 3. 检查 IP 地址池
```powershell
kubectl get IPAddressPool -n metallb-system
```

期望输出：
```
NAME              AUTO ALLOCATE
metallb-test-pool true
```

### 4. 检查 L2 广告
```powershell
kubectl get L2Advertisement -n metallb-system
```

期望输出：
```
NAME                 IPADDRESSPOOLS
metallb-test-l2      ["metallb-test-pool"]
```

---

## 测试 MetalLB

### 创建测试服务

```yaml
# test-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-test
  namespace: default
spec:
  selector:
    app: nginx
  ports:
  - port: 80
    targetPort: 80
  type: LoadBalancer
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx
  namespace: default
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:latest
        ports:
        - containerPort: 80
```

```powershell
# 应用测试服务
kubectl apply -f test-service.yaml

# 等待 IP 分配
kubectl get svc nginx-test -w

# 访问服务
kubectl get svc nginx-test
# 记录 EXTERNAL-IP
curl http://<EXTERNAL-IP>
```

---

## 故障排除

### 问题 1：Pod 无法启动
```powershell
# 查看 Pod 日志
kubectl logs -n metallb-system <pod-name> -c controller

# 查看 Speaker 日志
kubectl logs -n metallb-system <pod-name> -c speaker
```

### 问题 2：IP 未分配
```powershell
# 检查 IP 地址池
kubectl describe IPAddressPool metallb-test-pool -n metallb-system

# 检查事件
kubectl get events -n metallb-system
```

### 问题 3：kube-proxy strict ARP 问题

确保在 `main.tf` 中启用了 `configure_kube_proxy`：

```hcl
module "metallb" {
  configure_kube_proxy   = true
  kube_proxy_strict_arp  = true
}
```

---

## 清理资源

```powershell
# 删除测试服务
kubectl delete -f test-service.yaml

# 销毁 MetalLB（使用 Terraform）
cd environments\metallb-test
terraform destroy

# 或删除特定环境
terraform destroy -var="kubeconfig_path=d:/文档/GitHub/kubernetes-terraform/config/dev-config"
```

---

## 快速命令参考

### 开发环境
```powershell
cd environments\dev
terraform init
terraform plan
terraform apply
```

### 测试环境（推荐）
```powershell
cd environments\metallb-test
terraform init
terraform plan
terraform apply
```

### 生产环境
```powershell
cd environments\prod
terraform init
terraform plan
terraform apply
```

### 使用不同的 kubeconfig
```powershell
# 方式一：编辑 terraform.tfvars
kubeconfig_path = "d:/文档/GitHub/kubernetes-terraform/config/dev-config"

# 方式二：命令行变量
terraform apply -var="kubeconfig_path=d:/文档/GitHub/kubernetes-terraform/config/dev-config"
```

---

## 配置文件路径总结

| 环境 | kubeconfig 路径 | 上下文 |
|------|----------------|--------|
| 开发 | `d:/文档/GitHub/kubernetes-terraform/config/dev-config` | `kubernetes-admin@kubekey.kubernetes.dev` |
| 生产 | `d:/文档/GitHub/kubernetes-terraform/config/prod-config` | `kubernetes-admin@kubekey.kubernetes.prod` |
| 测试 | `d:/文档/GitHub/kubernetes-terraform/config/dev-config` | `kubernetes-admin@kubekey.kubernetes.dev` |
