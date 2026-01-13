# Prometheus + Grafana on Kubernetes - Terraform 部署方案

使用 Terraform 在 Kubernetes 集群上部署完整的 Prometheus + Grafana 监控栈，支持监控 K8s、Istio、Ceph、MetalLB、Kubeflow、MLflow、MinIO 等组件。

## 项目结构

```
.
├── modules/
│   └── prometheus/           # Prometheus 监控模块
│       ├── main.tf           # 主配置文件
│       ├── variables.tf      # 变量定义
│       ├── outputs.tf        # 输出定义
│       ├── versions.tf       # Terraform 和 Provider 版本
│       ├── provider.tf       # Provider 配置
│       ├── manifests/        # Kubernetes 清单文件
│       │   ├── istio-servicemonitor.yaml
│       │   ├── ceph-servicemonitor.yaml
│       │   ├── metallb-servicemonitor.yaml
│       │   ├── kubeflow-servicemonitor.yaml
│       │   ├── mlflow-servicemonitor.yaml
│       │   └── minio-servicemonitor.yaml
│       └── dashboards/       # Grafana Dashboard 配置
│           ├── istio-*.json
│           ├── ceph-*.json
│           ├── metallb-dashboard.json
│           ├── kubeflow-dashboard.json
│           ├── mlflow-dashboard.json
│           └── minio-dashboard.json
└── environments/
    └── dev/                  # 开发环境配置
        ├── main.tf           # 调用模块
        ├── variables.tf      # 环境变量
        ├── terraform.tfvars  # 环境特定配置
        ├── outputs.tf        # 环境输出
        └── README.md         # 环境说明
```

## 技术栈

- **Terraform**: 基础设施即代码工具
- **Helm**: Kubernetes 包管理器
- **Prometheus Operator**: Prometheus 官方推荐部署方式
- **kube-prometheus-stack**: 包含 Prometheus、Grafana、Alertmanager 等的完整监控栈

## 前置要求

1. Kubernetes 集群 (v1.20+)
2. kubectl 已配置，可访问集群
3. Terraform v1.0+
4. Helm CLI

## 快速开始

### 1. 克隆项目

```bash
git clone <repository-url>
cd Prometheus_Grafana
```

### 2. 配置 kubeconfig

确保你的 `~/.kube/config` 文件可以访问 Kubernetes 集群。如果不是默认路径，请修改 `environments/dev/terraform.tfvars` 中的 `kubeconfig_path`。

### 3. 初始化 Terraform

```bash
cd environments/dev
terraform init
```

### 4. 查看部署计划

```bash
terraform plan
```

### 5. 部署监控栈

```bash
terraform apply
```

输入 `yes` 确认部署。

### 6. 获取访问信息

```bash
terraform output
```

这将显示：
- Grafana URL
- Prometheus URL
- Alertmanager URL
- Grafana 用户名和密码

### 7. 访问 Grafana

使用上面输出的 Grafana URL 访问 Grafana：

默认凭证：
- 用户名: `admin`
- 密码: `prom-operator`

首次登录后建议修改密码。

## 配置说明

### 国内镜像源

默认使用中国科学技术大学镜像源加速镜像下载：

```hcl
registry_mirror = "docker.mirrors.ustc.edu.cn"
```

如需使用其他镜像源，可在 `environments/dev/terraform.tfvars` 中修改：

```hcl
registry_mirror = "registry.cn-hangzhou.aliyuncs.com"
```

### 启用/禁用监控组件

在 `terraform.tfvars` 中配置：

```hcl
# 启用 Istio 监控
enable_istio_monitoring = true

# 启用 Ceph 监控
enable_ceph_monitoring = true

# 启用 MetalLB 监控
enable_metallb_monitoring = true

# 启用 Kubeflow 监控
enable_kubeflow_monitoring = true

# 启用 MLflow 监控
enable_mlflow_monitoring = true

# 启用 MinIO 监控
enable_minio_monitoring = true
```

### 存储配置

默认使用 `standard` 存储类，可在 `terraform.tfvars` 中修改：

```hcl
storage_class = "fast-ssd"  # 使用 SSD 存储类
```

## Dashboard 说明

部署完成后，Grafana 会自动加载以下 Dashboard：

### Kubernetes 监控
- Kubernetes / Compute Resources / Pod
- Kubernetes / Compute Resources / Namespace
- Kubernetes / Compute Resources / Node
- Kubernetes / API Server
- Kubernetes / Controller Manager
- Kubernetes / Scheduler

### Istio 监控 (如果启用)
- Istio Mesh Dashboard
- Istio Service Dashboard
- Istio Workload Dashboard

### Ceph 监控 (如果启用)
- Ceph Cluster Dashboard
- Ceph OSD Dashboard
- Ceph Pool Dashboard

### MetalLB 监控 (如果启用)
- MetalLB Dashboard
  - Speaker Addresses
  - Announced Prefixes
  - ARP Requests
  - BGP Sessions

### Kubeflow 监控 (如果启用)
- Kubeflow Dashboard
  - Pipeline Runs
  - Notebooks
  - Training Jobs
  - Katib Experiments
  - Pipeline Duration
  - Resource Usage

### MLflow 监控 (如果启用)
- MLflow Dashboard
  - Requests
  - Response Time
  - Active Runs
  - Experiments
  - Registered Models
  - Resource Usage

### MinIO 监控 (如果启用)
- MinIO Dashboard
  - Storage Usage
  - Objects Count
  - Requests
  - Throughput
  - Errors
  - Health Status

## 自定义配置

### 修改 Grafana 密码

在 `modules/prometheus/main.tf` 中修改：

```hcl
set {
  name  = "grafana.adminPassword"
  value = "your-secure-password"
}
```

### 修改资源限制

在 `modules/prometheus/main.tf` 中调整资源配置：

```hcl
# Prometheus 资源限制
set {
  name  = "prometheus.prometheusSpec.resources.requests.cpu"
  value = "1000m"  # 1 CPU
}
set {
  name  = "prometheus.prometheusSpec.resources.requests.memory"
  value = "4Gi"    # 4GB 内存
}
```

### 修改存储大小

在 `modules/prometheus/main.tf` 中修改：

```hcl
# Prometheus 存储
set {
  name  = "prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.storage"
  value = "100Gi"  # 修改为 100GB
}

# Grafana 存储
set {
  name  = "grafana.persistence.size"
  value = "20Gi"   # 修改为 20GB
}
```

## 故障排查

### 1. 检查 Pod 状态

```bash
kubectl get pods -n monitoring
```

### 2. 查看 Pod 日志

```bash
# Prometheus 日志
kubectl logs -n monitoring -l app.kubernetes.io/name=prometheus

# Grafana 日志
kubectl logs -n monitoring -l app.kubernetes.io/name=grafana
```

### 3. 检查 Service 和 Ingress

```bash
kubectl get svc -n monitoring
kubectl get ingress -n monitoring
```

### 4. 重新部署

如果遇到问题，可以重新部署：

```bash
terraform destroy
terraform apply
```

## 清理资源

删除所有部署的资源：

```bash
cd environments/dev
terraform destroy
```

## 模块复用

此模块设计为可复用，可以在其他环境中使用：

```hcl
module "production_monitoring" {
  source = "../../modules/prometheus"

  kubeconfig_path         = "~/.kube/config"
  namespace              = "monitoring-prod"
  enable_istio_monitoring = true
  enable_ceph_monitoring  = true
  storage_class           = "fast-ssd"
  registry_mirror         = "registry.cn-hangzhou.aliyuncs.com"
}
```

## 版本信息

- Terraform: >= 1.0
- Helm Provider: >= 2.10.0
- Kubernetes Provider: >= 2.20.0
- kube-prometheus-stack: 25.6.0
- Grafana Chart: 7.3.9

## 参考资源

- [Prometheus Operator](https://prometheus-operator.dev/)
- [kube-prometheus-stack](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack)
- [Grafana](https://grafana.com/)
- [Terraform Kubernetes Provider](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs)
- [Terraform Helm Provider](https://registry.terraform.io/providers/hashicorp/helm/latest/docs)

## 最佳实践

1. **使用模块化设计**: 将 Prometheus 监控栈封装为可复用的模块
2. **使用变量覆盖**: 通过变量实现不同环境的配置差异
3. **使用官方 Helm Chart**: 使用 kube-prometheus-stack 官方推荐的部署方式
4. **使用 ServiceMonitor**: 通过 ServiceMonitor 实现服务自动发现
5. **配置持久化存储**: 为 Prometheus 和 Grafana 配置持久化存储
6. **配置资源限制**: 为组件配置合理的资源限制
7. **使用国内镜像源**: 在国内环境下使用镜像加速下载

## License

MIT
