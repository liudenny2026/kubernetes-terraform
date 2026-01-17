# Kubernetes Terraform 三级架构说明

## 架构概述

本项目严格遵循**三级架构设计原则**，将基础设施代码分为三个层次：

```
┌─────────────────────────────────────────────────────────────┐
│                    基础设施层 (Infrastructure Layer)          │
│  ├─ environments/prod/main.tf                              │
│  ├─ environments/stage/main.tf                             │
│  └─ environments/dev/main.tf                                │
│  组合各功能模块，定义最终的生产环境配置                      │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                      模块层 (Module Layer)                   │
│  ├─ modules/base/coredns/          (CoreDNS模块)            │
│  ├─ modules/infrastructure/istio/  (Istio模块)              │
│  ├─ modules/security/neuvector/     (NeuVector模块)        │
│  └─ modules/workflow/kubeflow/      (Kubeflow模块)          │
│  组合单个Kubernetes资源，形成功能模块                      │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                    资源层 (Resource Layer)                   │
│  ├─ resources/coredns/deployment/  (Deployment资源)        │
│  ├─ resources/coredns/service/      (Service资源)          │
│  ├─ resources/coredns/configmap/    (ConfigMap资源)        │
│  └─ resources/coredns/clusterrole/  (ClusterRole资源)      │
│  定义单个Kubernetes资源（最小可重用单元）                   │
└─────────────────────────────────────────────────────────────┘
```

## 各层级详细说明

### 1. 资源层 (Resource Layer)
**位置**: `terraform/resources/`

**职责**:
- 定义单个 Kubernetes 资源
- 每个资源是一个独立的可重用模块
- 包含 `main.tf` 和 `variables.tf`
- **不包含**业务逻辑组合

**示例结构**:
```
resources/
├── coredns/
│   ├── deployment/
│   │   ├── main.tf       # kubernetes_deployment 资源定义
│   │   └── variables.tf  # Deployment 变量定义
│   ├── service/
│   │   ├── main.tf       # kubernetes_service 资源定义
│   │   └── variables.tf  # Service 变量定义
│   └── configmap/
│       ├── main.tf
│       └── variables.tf
```

**命名规范**:
- 资源名称: `{name}` (由上层传入)
- 模块调用: `module "deployment" { source = "../resources/coredns/deployment" }`

### 2. 模块层 (Module Layer)
**位置**: `terraform/modules/`

**职责**:
- 组合多个资源层模块，形成完整的功能模块
- 定义资源间的依赖关系
- 应用安全标签和命名规范
- 不直接定义 Kubernetes 资源

**示例结构**:
```
modules/base/coredns/
├── main.tf        # 调用资源层模块
├── variables.tf   # 模块变量定义
├── outputs.tf     # 模块输出定义
└── versions.tf    # Terraform 版本约束
```

**main.tf 示例**:
```hcl
locals {
  standard_labels = merge(var.tags, {
    app       = "coredns"
    component = "dns"
    version   = var.coredns_version
  })
}

module "coredns_deployment" {
  source = "../../../resources/coredns/deployment"
  
  name      = "${var.environment}-${var.component}-coredns-deployment"
  namespace = var.namespace
  labels    = local.standard_labels
  # ...其他参数
}
```

**命名规范**:
- 资源名称: `{environment}-{component}-coredns-{resource-type}`
- 示例: `prod-cloud-native-coredns-deployment`

### 3. 基础设施层 (Infrastructure Layer)
**位置**: `terraform/environments/`

**职责**:
- 组合多个模块层模块
- 定义特定环境的生产配置
- 传递环境特定变量（密码、域名、存储等）
- 最终部署入口

**示例结构**:
```
environments/prod/
├── main.tf          # 调用所有模块
├── variables.tf     # 环境变量定义
├── outputs.tf       # 环境输出定义
├── terraform.tfvars # 生产环境变量值
├── providers.tf     # Provider 配置
└── versions.tf      # Terraform 版本约束
```

**main.tf 示例**:
```hcl
module "coredns" {
  source = "../../modules/base/coredns"
  
  environment      = var.environment  # prod
  component        = var.component    # cloud-native
  coredns_version  = var.versions.coredns
  
  tags = var.tags
}

module "istio" {
  source = "../../modules/infrastructure/istio"
  # ...
}
```

## 命名规范

### 统一命名格式
```
{environment}-{component}-{module}-{resource-type}
```

### 参数说明
- `environment`: 环境标识（dev/stage/prod）
- `component`: 组件标识（cloud-native/mlops/security等）
- `module`: 模块名称（coredns/istio/neuvector等）
- `resource-type`: 资源类型（deployment/service/configmap等）

### 命名示例
| 环境 | 组件 | 模块 | 资源类型 | 完整名称 |
|------|------|------|----------|----------|
| prod | cloud-native | coredns | deployment | `prod-cloud-native-coredns-deployment` |
| prod | cloud-native | istio | service | `prod-cloud-native-istio-service` |
| stage | mlops | kubeflow | deployment | `stage-mlops-kubeflow-deployment` |

## 安全标签标准

所有资源必须应用以下安全标签：

```hcl
{
  Environment  = "prod|stage|dev"
  CostCenter   = "12345"
  Security     = "cloud-native"
  ManagedBy    = "terraform"
  Project      = "kubernetes-infra"
}
```

## 目录结构完整示例

```
terraform/
├── resources/                      # 资源层
│   ├── coredns/
│   │   ├── deployment/
│   │   │   ├── main.tf
│   │   │   └── variables.tf
│   │   ├── service/
│   │   │   ├── main.tf
│   │   │   └── variables.tf
│   │   ├── configmap/
│   │   │   ├── main.tf
│   │   │   └── variables.tf
│   │   │   └── templates/
│   │   │       └── Corefile.tpl
│   │   ├── serviceaccount/
│   │   │   ├── main.tf
│   │   │   └── variables.tf
│   │   ├── clusterrole/
│   │   │   ├── main.tf
│   │   │   └── variables.tf
│   │   └── clusterrolebinding/
│   │       ├── main.tf
│   │       └── variables.tf
│   └── istio/
│       ├── namespace/
│       ├── deployment/
│       └── service/
│
├── modules/                        # 模块层
│   ├── base/
│   │   └── coredns/
│   │       ├── main.tf
│   │       ├── variables.tf
│   │       ├── outputs.tf
│   │       └── versions.tf
│   ├── infrastructure/
│   │   ├── istio/
│   │   ├── rook-ceph/
│   │   ├── minio/
│   │   └── harbor/
│   ├── security/
│   │   ├── neuvector/
│   │   ├── falco/
│   │   ├── opa/
│   │   └── kyverno/
│   └── workflow/
│       ├── kubeflow/
│       ├── mlflow/
│       ├── gitlab/
│       └── argocd/
│
├── environments/                   # 基础设施层
│   ├── prod/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   ├── terraform.tfvars
│   │   ├── providers.tf
│   │   └── versions.tf
│   ├── stage/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── terraform.tfvars
│   └── dev/
│       ├── main.tf
│       ├── variables.tf
│       └── terraform.tfvars
│
└── variables/                      # 全局变量
    ├── global.tfvars
    └── prod.tfvars
```

## 变量传递流程

```
environments/prod/terraform.tfvars
    ↓ (环境特定值)
environments/prod/main.tf
    ↓ (调用模块)
modules/base/coredns/main.tf
    ↓ (组合资源)
resources/coredns/deployment/main.tf
    ↓ (定义资源)
kubernetes_deployment 资源
```

## 关键原则

1. **单向依赖**: 上层依赖下层，下层不依赖上层
2. **最小耦合**: 资源层完全独立，可在任何模块中复用
3. **变量驱动**: 所有配置通过变量传递，禁止硬编码
4. **命名规范**: 严格遵循 `{env}-{component}-{module}-{resource-type}`
5. **安全标签**: 所有资源必须应用标准安全标签
6. **避免重复**: 相同资源只能定义一次

## 部署流程

```bash
# 1. 进入目标环境
cd terraform/environments/prod

# 2. 修改配置文件
# 编辑 terraform.tfvars，设置域名、密码等

# 3. 初始化
terraform init

# 4. 查看变更
terraform plan

# 5. 应用变更
terraform apply
```
