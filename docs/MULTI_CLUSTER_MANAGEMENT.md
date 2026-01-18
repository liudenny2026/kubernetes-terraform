# 多集群管理配置指南

## 概述

本项目支持通过配置文件管理多个 Kubernetes 集群，实现开发环境和生产环境的分离部署。

## 集群配置架构

```
environments/
├── dev/
│   ├── providers.tf          # 开发集群连接配置
│   ├── main.tf               # 开发环境模块引用
│   ├── variables.tf          # 开发环境变量定义
│   └── terraform.tfvars      # 开发环境变量值
├── prod/
│   ├── providers.tf          # 生产集群连接配置
│   ├── main.tf               # 生产环境模块引用
│   ├── variables.tf          # 生产环境变量定义
│   └── terraform.tfvars      # 生产环境变量值
└── stage/
    └── (同上)
```

## 配置方式

### 1. kubeconfig 文件管理

#### 方式一：共享 kubeconfig 文件（推荐）

在 `~/.kube/config` 中配置多个集群上下文：

```yaml
apiVersion: v1
kind: Config
clusters:
  - name: prod.kubernetes.cluster
    cluster:
      server: https://prod-k8s-api.example.com:6443
      certificate-authority-data: LS0tLS1CRUdJTi...

  - name: dev.kubernetes.cluster
    cluster:
      server: https://dev-k8s-api.example.com:6443
      certificate-authority-data: LS0tLS1CRUdJTi...

contexts:
  - name: prod.kubernetes.cluster
    context:
      cluster: prod.kubernetes.cluster
      user: prod-admin

  - name: dev.kubernetes.cluster
    context:
      cluster: dev.kubernetes.cluster
      user: dev-admin

users:
  - name: prod-admin
    user:
      client-certificate-data: LS0tLS1CRUdJTi...
      client-key-data: LS0tLS1CRUdJTi...

  - name: dev-admin
    user:
      client-certificate-data: LS0tLS1CRUdJTi...
      client-key-data: LS0tLS1CRUdJTi...

current-context: dev.kubernetes.cluster
```

#### 方式二：独立 kubeconfig 文件

为每个环境使用独立的 kubeconfig 文件：

```bash
# 生产环境
~/.kube/prod-config

# 开发环境
~/.kube/dev-config
```

### 2. Provider 配置

#### 开发环境 (environments/dev/providers.tf)

```hcl
provider "kubernetes" {
  config_path    = var.kubeconfig_path
  config_context = var.config_context
}

# 通过变量指定
# kubeconfig_path = "~/.kube/config"
# config_context  = "dev.kubernetes.cluster"
```

#### 生产环境 (environments/prod/providers.tf)

```hcl
provider "kubernetes" {
  config_path    = var.kubeconfig_path
  config_context = var.config_context
}

# 通过变量指定
# kubeconfig_path = "~/.kube/config"
# config_context  = "prod.kubernetes.cluster"
```

### 3. 变量配置

#### 方式一：使用 terraform.tfvars

**开发环境** (environments/dev/terraform.tfvars):

```hcl
# 集群连接配置
kubeconfig_path = "~/.kube/config"
config_context  = "dev.kubernetes.cluster"

# 环境标识
environment    = "dev"
naming_prefix  = "cloud-native"

# MetalLB IP 池
metallb_ip_ranges = ["192.168.40.150-192.168.40.160"]

# 其他配置...
```

**生产环境** (environments/prod/terraform.tfvars):

```hcl
# 集群连接配置
kubeconfig_path = "~/.kube/config"
config_context  = "prod.kubernetes.cluster"

# 环境标识
environment    = "prod"
component      = "cloud-native"

# MetalLB IP 池
metallb_ip_ranges = ["192.168.40.200-192.168.40.250"]

# 其他配置...
```

#### 方式二：使用命令行变量

```bash
# 开发环境
cd environments/dev
terraform apply \
  -var="kubeconfig_path=~/.kube/config" \
  -var="config_context=dev.kubernetes.cluster"

# 生产环境
cd environments/prod
terraform apply \
  -var="kubeconfig_path=~/.kube/config" \
  -var="config_context=prod.kubernetes.cluster"
```

#### 方式三：使用环境变量

```bash
# 设置环境变量
export KUBE_CONFIG_PATH=~/.kube/config
export KUBE_CONTEXT=prod.kubernetes.cluster

# 应用配置
terraform apply \
  -var="kubeconfig_path=$KUBE_CONFIG_PATH" \
  -var="config_context=$KUBE_CONTEXT"
```

## 部署流程

### 开发环境部署

```bash
# 切换到开发环境目录
cd environments/dev

# 初始化
terraform init

# 规划变更（查看将要部署到哪个集群）
terraform plan -var="kubeconfig_path=~/.kube/config" -var="config_context=dev.kubernetes.cluster"

# 应用配置
terraform apply -var="kubeconfig_path=~/.kube/config" -var="config_context=dev.kubernetes.cluster"
```

### 生产环境部署

```bash
# 切换到生产环境目录
cd environments/prod

# 初始化
terraform init

# 规划变更（确认将部署到生产集群）
terraform plan -var="kubeconfig_path=~/.kube/config" -var="config_context=prod.kubernetes.cluster"

# 应用配置
terraform apply -var="kubeconfig_path=~/.kube/config" -var="config_context=prod.kubernetes.cluster"
```

### 验证连接

```bash
# 验证开发集群连接
cd environments/dev
terraform plan -var="config_context=dev.kubernetes.cluster"
# 查看输出中显示的集群信息

# 验证生产集群连接
cd environments/prod
terraform plan -var="config_context=prod.kubernetes.cluster"
# 查看输出中显示的集群信息
```

## 跨集群操作

如果需要在同一个 Terraform 配置中管理多个集群，可以使用 provider alias：

```hcl
# 开发集群
provider "kubernetes" {
  alias = "dev"
  config_path    = "~/.kube/config"
  config_context = "dev.kubernetes.cluster"
}

# 生产集群
provider "kubernetes" {
  alias = "prod"
  config_path    = "~/.kube/config"
  config_context = "prod.kubernetes.cluster"
}

# 跨集群资源
module "dev_resource" {
  source = "../../modules/example"
  providers = {
    kubernetes = kubernetes.dev
  }
}

module "prod_resource" {
  source = "../../modules/example"
  providers = {
    kubernetes = kubernetes.prod
  }
}
```

## 安全最佳实践

### 1. 密码和密钥管理

使用 `sensitive = true` 标记敏感变量：

```hcl
variable "kubeconfig_path" {
  description = "Path to kubeconfig file"
  type        = string
  sensitive   = false  # 路径非敏感
}

variable "config_context" {
  description = "Kubernetes context name"
  type        = string
  sensitive   = false  # 上下文名称非敏感
}
```

### 2. 环境隔离

- 生产环境使用独立的 kubeconfig 或上下文
- 使用不同的命名空间
- 使用不同的资源标签

### 3. 访问控制

```yaml
# 生产环境 RBAC 权限
# 仅授予必要的权限
- kind: ClusterRole
  name: terraform-prod
  rules:
  - apiGroups: ["*"]
    resources: ["deployments", "services", "configmaps", "secrets"]
    verbs: ["get", "list", "create", "update", "delete"]
```

## 故障排除

### 问题1: 无法连接到集群

```bash
# 检查 kubeconfig 文件
kubectl config view

# 验证上下文
kubectl config get-contexts

# 测试连接
kubectl --context=prod.kubernetes.cluster get nodes
```

### 问题2: Terraform 状态文件混乱

```bash
# 为每个环境使用独立的 backend
# environments/dev/backend.tf
terraform {
  backend "kubernetes" {
    secret_suffix     = "terraform-state"
    namespace         = "terraform"
    in_cluster_config = true
  }
}
```

### 问题3: 跨集群状态同步

```bash
# 使用 Terraform Workspace 管理
terraform workspace new dev
terraform workspace new prod
```

## 推荐工作流

```bash
# 1. 配置 kubeconfig
kubectl config use-context dev.kubernetes.cluster

# 2. 更新 terraform.tfvars
cd environments/dev
echo 'config_context = "dev.kubernetes.cluster"' >> terraform.tfvars

# 3. 初始化和部署
terraform init
terraform plan
terraform apply

# 4. 切换到生产环境
cd ../prod
kubectl config use-context prod.kubernetes.cluster

# 5. 更新 terraform.tfvars
echo 'config_context = "prod.kubernetes.cluster"' >> terraform.tfvars

# 6. 初始化和部署
terraform init
terraform plan
terraform apply
```

## 环境差异配置

| 配置项 | 开发环境 | 生产环境 |
|--------|---------|---------|
| kubeconfig_path | ~/.kube/config | ~/.kube/config |
| config_context | dev.kubernetes.cluster | prod.kubernetes.cluster |
| MetalLB IP范围 | 192.168.40.150-160 | 192.168.40.200-250 |
| 副本数 | 1 | 2-3 |
| 存储大小 | 20-50Gi | 100-200Gi |
| mTLS | 禁用 | 启用 |

## 附录：完整示例

### dev/terraform.tfvars

```hcl
environment    = "dev"
naming_prefix  = "cloud-native"

# 集群连接
kubeconfig_path = "~/.kube/config"
config_context  = "dev.kubernetes.cluster"

# MetalLB
metallb_ip_ranges = ["192.168.40.150-192.168.40.160"]

# 密码（开发环境使用弱密码）
minio_secret_key   = "minioadmin"
mlflow_password    = "mlflow-password"
argocd_password    = "argocd-password"

# 域名
argocd_domain      = "argocd.dev.example.com"
mlflow_domain      = "mlflow.dev.example.com"
```

### prod/terraform.tfvars

```hcl
environment    = "prod"
component      = "cloud-native"

# 集群连接
kubeconfig_path = "~/.kube/config"
config_context  = "prod.kubernetes.cluster"

# MetalLB
metallb_ip_ranges = ["192.168.40.200-192.168.40.250"]

# 密码（生产环境使用强密码）
harbor_password     = "HarborAdmin123!"
minio_secret_key    = "MinIO-Secret-Key-1234!"
mlflow_password     = "MLflowDBPassword123!"
argocd_password     = "ArgoCDAdminPassword123!"

# 域名
harbor_domain       = "harbor.example.com"
kubeflow_domain     = "kubeflow.example.com"
mlflow_domain       = "mlflow.example.com"
gitlab_domain       = "gitlab.example.com"
argocd_domain       = "argocd.example.com"
```
