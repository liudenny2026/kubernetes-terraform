# Prometheus Monitoring Module

这是一个用于部署 Prometheus + Grafana 监控栈的 Terraform 模块。

## 模块功能

- 使用 Helm 部署 kube-prometheus-stack（官方推荐方式）
- 配置 Prometheus Operator
- 部署 Grafana 并预配置 Dashboard
- 集成 Alertmanager
- 支持 Istio 监控
- 支持 Ceph 监控
- 支持 MetalLB 监控
- 支持 Kubeflow 监控
- 支持 MLflow 监控
- 支持 MinIO 监控
- 支持国内镜像源加速

## 使用示例

```hcl
module "prometheus_monitoring" {
  source = "../../modules/prometheus"

  kubeconfig_path           = "~/.kube/config"
  namespace                 = "monitoring"
  enable_istio_monitoring   = true
  enable_ceph_monitoring    = true
  enable_metallb_monitoring = true
  enable_kubeflow_monitoring = true
  enable_mlflow_monitoring   = true
  enable_minio_monitoring    = true
  storage_class             = "standard"
  registry_mirror           = "docker.mirrors.ustc.edu.cn"
}
```

## 输入变量

| 变量名 | 描述 | 类型 | 默认值 |
|--------|------|------|--------|
| `kubeconfig_path` | kubeconfig 文件路径 | string | `~/.kube/config` |
| `namespace` | 监控组件命名空间 | string | `monitoring` |
| `enable_istio_monitoring` | 启用 Istio 监控 | bool | `true` |
| `enable_ceph_monitoring` | 启用 Ceph 监控 | bool | `true` |
| `enable_metallb_monitoring` | 启用 MetalLB 监控 | bool | `true` |
| `enable_kubeflow_monitoring` | 启用 Kubeflow 监控 | bool | `true` |
| `enable_mlflow_monitoring` | 启用 MLflow 监控 | bool | `true` |
| `enable_minio_monitoring` | 启用 MinIO 监控 | bool | `true` |
| `storage_class` | 存储类名称 | string | `standard` |
| `registry_mirror` | 镜像源地址 | string | `docker.mirrors.ustc.edu.cn` |

## 输出

| 输出名 | 描述 |
|--------|------|
| `namespace` | 监控命名空间 |
| `grafana_url` | Grafana 访问 URL |
| `grafana_username` | Grafana 管理员用户名 |
| `grafana_password` | Grafana 管理员密码 |
| `prometheus_url` | Prometheus 访问 URL |
| `alertmanager_url` | Alertmanager 访问 URL |

## 依赖要求

- Terraform >= 1.0
- Kubernetes 集群
- kubectl 配置文件
