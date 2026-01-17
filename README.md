# ============================================================================
# Kubernetes Cloud-Native Infrastructure - Terraform
# ============================================================================

## 三级架构目录结构

```
/
├── modules/
│   ├── base/
│   │   ├── calico/
│   │   │   ├── main.tf
│   │   │   ├── outputs.tf
│   │   │   ├── variables.tf
│   │   │   └── versions.tf
│   │   ├── coredns/
│   │   │   ├── main.tf
│   │   │   ├── outputs.tf
│   │   │   ├── variables.tf
│   │   │   └── versions.tf
│   │   └── metallb/
│   │       ├── main.tf
│   │       ├── outputs.tf
│   │       ├── variables.tf
│   │       └── versions.tf
│   ├── infrastructure/
│   │   ├── fluentd/
│   │   ├── harbor/
│   │   ├── istio/
│   │   ├── minio/
│   │   ├── prometheus/
│   │   ├── rook-ceph/
│   │   └── storage/
│   ├── security/
│   │   ├── aqua-security/
│   │   ├── falco/
│   │   ├── gatekeeper/
│   │   ├── kube-bench/
│   │   ├── kube-hunter/
│   │   ├── kyverno/
│   │   ├── neuvector/
│   │   ├── opa/
│   │   ├── portainer/
│   │   ├── trivy/
│   │   └── wazuh/
│   └── workflow/
│       ├── argocd/
│       ├── flux/
│       ├── gitlab/
│       ├── helm/
│       ├── jenkins/
│       ├── kubeflow/
│       ├── kustomize/
│       ├── mlflow/
│       ├── spinnaker/
│       └── tekton/
├── environments/
│   ├── dev/
│   │   ├── main.tf
│   │   ├── terraform.tfvars
│   │   └── variables.tf
│   ├── prod/
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   ├── providers.tf
│   │   ├── terraform.tfvars
│   │   ├── variables.tf
│   │   └── versions.tf
│   └── stage/
│       ├── main.tf
│       ├── terraform.tfvars
│       └── variables.tf
├── variables/
│   ├── global.tfvars
│   └── prod.tfvars
└── docs/
    └── ARCHITECTURE.md
```

## 命名规范

### 标准命名格式
- **格式**: `{env}-{component}-{resource-type}`
- **示例**: `prod-cloud-native-istio-deployment`, `stage-cloud-native-neuvector-service`

### 安全标签标准
所有资源必须包含以下标签：
```hcl
{
  Environment  = "prod"
  CostCenter   = "12345"
  Security     = "cloud-native"
  ManagedBy    = "terraform"
  Project      = "cloud-native-infrastructure"
}
```

## 快速开始

### 生产环境部署

```bash
cd terraform/environments/prod

# 初始化
terraform init

# 规划
terraform plan -out=tfplan

# 应用
terraform apply tfplan
```

### Stage环境部署

```bash
cd terraform/environments/stage

terraform init
terraform apply
```

### 开发环境部署

```bash
cd terraform/environments/dev

terraform init
terraform apply
```

## 模块说明

### Base Modules
- **Calico**: 网络策略和网络插件
- **CoreDNS**: 集群DNS服务
- **MetalLB**: 负载均衡器

### Infrastructure Modules
- **Fluentd**: 日志收集
- **Harbor**: 容器镜像仓库
- **Istio**: 服务网格
- **MinIO**: 对象存储
- **Prometheus**: 监控系统
- **Rook-Ceph**: 分布式存储
- **Storage**: 本地路径存储

### Security Modules
- **Aqua Security**: 容器安全平台
- **Falco**: 运行时安全监控
- **Gatekeeper**: OPA策略执行
- **Kube-bench**: CIS基准测试
- **Kube-hunter**: 漏洞扫描
- **Kyverno**: Kubernetes原生策略管理
- **NeuVector**: 容器安全平台
- **OPA**: 策略即代码
- **Portainer**: 容器管理界面
- **Trivy**: 漏洞扫描
- **Wazuh**: 安全监控

### Workflow Modules
- **ArgoCD**: GitOps持续交付
- **Flux**: GitOps工具
- **GitLab**: DevOps平台
- **Helm**: 包管理
- **Jenkins**: CI/CD平台
- **Kubeflow**: 机器学习平台
- **Kustomize**: 配置管理
- **MLflow**: 实验跟踪
- **Spinnaker**: 多环境部署
- **Tekton**: 云原生CI/CD

## 安全配置

### 避免的安全组规则
- ❌ `0.0.0.0/0` 安全组规则
- ✅ 使用明确的CIDR范围
- ✅ 使用命名端口和协议

### 变量管理
所有敏感信息通过变量传递：
- 密码、密钥、证书等
- 使用 `sensitive = true` 标记
- 不要在代码中硬编码

## 环境差异

| 组件 | Prod | Stage | Dev |
|------|------|-------|-----|
| Istio mTLS | ✅ | ✅ | ❌ |
| Rook-Ceph | ✅ 3 OSD | ✅ 2 OSD | ❌ |
| NeuVector DLP | ✅ | ❌ | ❌ |
| 副本数 | 3 | 2 | 1 |

## 维护说明

### 更新组件版本
编辑对应环境的 `terraform.tfvars` 文件

### 添加新模块
1. 在 `modules/` 创建新模块
2. 在环境 `main.tf` 中引用
3. 更新 `variables.tf` 和 `outputs.tf`

## 输出信息

部署完成后，Terraform会输出以下信息：
- 服务URL
- 命名空间
- 凭证（敏感信息）
- 端点地址

## 故障排除

### 资源创建失败
```bash
terraform plan -detailed-exitcode
terraform taint <resource>
terraform apply
```

### 状态文件损坏
```bash
terraform refresh
terraform plan
```
