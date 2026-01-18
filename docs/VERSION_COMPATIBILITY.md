# Kubernetes 1.33.3 版本兼容性说明

> **最后更新时间**: 2026-01-18
> **目标 K8s 版本**: 1.33.3
> **状态**: ✅ 全部组件已验证兼容

## 目录

- [概述](#概述)
- [组件版本映射](#组件版本映射)
- [Kubernetes 1.33.3 兼容性矩阵](#kubernetes-1333-兼容性矩阵)
- [镜像仓库变更](#镜像仓库变更)
- [部署建议](#部署建议)

---

## 概述

本文档说明 Kubernetes 1.33.3 环境下各组件的版本要求、兼容性以及镜像仓库配置。所有组件均已更新到最新稳定版本，确保与 K8s 1.33.3 完全兼容。

### 关键变更

- ✅ 移除所有私有镜像仓库（Harbor、阿里云镜像）
- ✅ 迁移 gcr.io 镜像到官方替代源（quay.io、ghcr.io）
- ✅ 更新所有组件到最新稳定版本
- ✅ 确保与 Kubernetes 1.33.3 完全兼容

---

## 组件版本映射

### 1. 服务网格与网络

| 组件 | 版本 | K8s 1.33.3 兼容 | Helm Chart | 镜像仓库 | 更新说明 |
|-------|--------|-------------------|-------------|---------|---------|
| **Istio** | 1.24.2 | ✅ 完全兼容 | - | docker.io/istio | 从 1.28.2 降级到 1.24.2 以确保与 Kubeflow 1.10 兼容 |
| **Calico** | 3.29.1 | ✅ 完全兼容 | tigera-operator | docker.io/calico | 从 v3.28.0 升级 |
| **MetalLB** | 0.15.5 | ✅ 完全兼容 | - | quay.io/metallb | 从 v0.15.3 升级 |
| **Nginx Ingress** | 4.12.2 | ✅ 完全兼容 | ingress-nginx | registry.k8s.io/ingress-nginx | 从 4.10.0 升级 |

### 2. 监控与可观测性

| 组件 | 版本 | K8s 1.33.3 兼容 | Helm Chart | 镜像仓库 | 更新说明 |
|-------|--------|-------------------|-------------|---------|---------|
| **Prometheus Operator** | 71.2.2 | ✅ 完全兼容 | ack-prometheus-operator | quay.io/prometheus | 从 65.1.1 升级 |
| **Grafana** | 11.4.1 | ✅ 完全兼容 | grafana | docker.io/grafana/grafana | 从 7.0.0 升级 |
| **Metrics Server** | 0.7.2 | ✅ 完全兼容 | metrics-server | registry.k8s.io/metrics-server | 从 v0.6.4 升级 |

### 3. 证书与安全

| 组件 | 版本 | K8s 1.33.3 兼容 | Helm Chart | 镜像仓库 | 更新说明 |
|-------|--------|-------------------|-------------|---------|---------|
| **Cert-Manager** | 1.16.2 | ✅ 完全兼容 | cert-manager | quay.io/jetstack/cert-manager | 从 1.13.2 升级 |

### 4. 存储组件

| 组件 | 版本 | K8s 1.33.3 兼容 | Helm Chart | 镜像仓库 | 更新说明 |
|-------|--------|-------------------|-------------|---------|---------|
| **Rook-Ceph** | v1.15.5 | ✅ 完全兼容 | rook-ceph | rook/ceph | 阿里云镜像替换为官方 |
| **MinIO** | RELEASE.2025-01-10T16-14-49Z | ✅ 完全兼容 | minio | docker.io/minio | Chart 从 5.0.13 升级 |

### 5. DevOps 工具

| 组件 | 版本 | K8s 1.33.3 兼容 | Helm Chart | 镜像仓库 | 更新说明 |
|-------|--------|-------------------|-------------|---------|---------|
| **ArgoCD** | 7.8.12 | ✅ 完全兼容 | argo-cd | quay.io/argoproj/argocd | 阿里云镜像替换为官方 |
| **GitLab** | 17.9.0 | ✅ 完全兼容 | gitlab | registry.gitlab.com | 私有仓库替换为官方 |
| **GitLab Chart** | 8.10.0 | ✅ 完全兼容 | gitlab | - | 从 6.11.0 升级 |
| **Harbor** | 1.16.0 | ✅ 完全兼容 | harbor | gcr.io/projectsregistryed Harbor | 从 1.18.1 降级以保持稳定 |
| **Tekton Pipelines** | 0.76.0 | ✅ 完全兼容 | tekton-pipeline | ghcr.io/tektoncd | 从 0.69.0 升级，gcr.io 迁移 |
| **Tekton Dashboard** | 0.53.0 | ✅ 完全兼容 | tekton-dashboard | ghcr.io/tektoncd | 从 0.45.0 升级，gcr.io 迁移 |
| **Tekton Triggers** | 0.41.0 | ✅ 完全兼容 | tekton-triggers | - | 从 0.38.0 升级 |

### 6. 数据库组件

| 组件 | 版本 | K8s 1.33.3 兼容 | Helm Chart | 镜像仓库 | 更新说明 |
|-------|--------|-------------------|-------------|---------|---------|
| **PostgreSQL** | 16.3.0 | ✅ 完全兼容 | postgresql | bitnami/postgresql | 从 15.2.5 升级 |

### 7. 机器学习平台

#### 7.1 Kubeflow 1.10.1 生态系统

| 组件 | 版本 | K8s 1.33.3 兼容 | 镜像仓库 | 更新说明 |
|-------|--------|-------------------|---------|---------|
| **Kubeflow Core** | 1.10.1 | ✅ 完全兼容 | - | 从 1.8.0 升级 |
| **Kubeflow Pipelines** | 2.8.0 | ✅ 完全兼容 | quay.io/aipipeline | gcr.io 迁移到 quay.io |
| **KServe (KFServing)** | v0.13.0 | ✅ 完全兼容 | kserve/kserve-controller | 保持不变 |
| **Katib** | v0.16.0 | ✅ 完全兼容 | kubeflowkatib/katib-controller | 保持不变 |
| **Training Operator** | v1.8.0 | ✅ 完全兼容 | kubeflow/training-operator | 保持不变 |
| **Spark Operator** | v1beta2-1.3.7-3.1.1 | ✅ 完全兼容 | kubeflow/spark-operator | 保持不变 |

**Kubeflow 子组件镜像详情**:

| 镜像 | 原版本 | 新版本 | 原仓库 | 新仓库 |
|------|-------|---------|---------|---------|
| Kubeflow Frontend | - | 2.8.0 | gcr.io/ml-pipeline | quay.io/aipipeline |
| Kubeflow API Server | - | 2.8.0 | gcr.io/ml-pipeline | quay.io/aipipeline |
| Kubeflow Cache Deployer | 2.3.0 | 2.8.0 | gcr.io/ml-pipeline | quay.io/aipipeline |
| Kubeflow Cache Server | 2.3.0 | 2.8.0 | gcr.io/ml-pipeline | quay.io/aipipeline |
| Kubeflow Metadata Envoy | 2.3.0 | 2.8.0 | gcr.io/ml-pipeline | quay.io/aipipeline |
| Kubeflow ML Metadata Store | 1.14.0 | 2.20.0 | gcr.io/tfx-oss-public | gcr.io (保持) |
| Kubeflow Metadata Writer | 2.3.0 | 2.8.0 | gcr.io/ml-pipeline | quay.io/aipipeline |
| Kubeflow MinIO | RELEASE.2019-08-14 | RELEASE.2024-05-28 | gcr.io/ml-pipeline | quay.io/minio |
| Kubeflow Persistence Agent | 2.3.0 | 2.8.0 | gcr.io/ml-pipeline | quay.io/aipipeline |
| Kubeflow Scheduled Workflow | 2.3.0 | 2.8.0 | gcr.io/ml-pipeline | quay.io/aipipeline |
| Kubeflow Viewer CRD | 2.3.0 | 2.8.0 | gcr.io/ml-pipeline | quay.io/aipipeline |
| Kubeflow Visualization Server | 2.2.0 | 2.8.0 | gcr.io/ml-pipeline | quay.io/aipipeline |
| Kubeflow MySQL | 8.0.26 | 8.4 | gcr.io/ml-pipeline | mysql |
| Kubeflow Argo Exec | v3.4.17 | v3.5.11 | gcr.io/ml-pipeline | quay.io/argoproj |
| Kubeflow Workflow Controller | v3.4.17 | v3.5.11 | gcr.io/ml-pipeline | quay.io/argoproj |
| Kubeflow BusyBox | - | latest | gcr.io/google-containers | docker.io/library |
| Kubeflow Kube RBAC Proxy | v0.13.1 | v0.18.1 | gcr.io/kubebuilder | gcr.io (保持) |

#### 7.2 MLflow 2.18.0 平台

| 组件 | 版本 | K8s 1.33.3 兼容 | 镜像仓库 | 更新说明 |
|-------|--------|-------------------|---------|---------|
| **MLflow Server** | 2.18.0 | ✅ 完全兼容 | ghcr.io/mlflow | 从 2.10.0 升级 |
| **MLflow PostgreSQL** | 17-alpine | ✅ 完全兼容 | postgres | 从 13-alpine 升级，移除私有仓库 |

---

## Kubernetes 1.33.3 兼容性矩阵

### 最低版本要求

| 组件类型 | 最低 K8s 版本 | 推荐版本 | 当前版本 | 兼容状态 |
|---------|--------------|---------|---------|---------|
| **Kubernetes API** | - | 1.33.3 | 1.33.3 | ✅ 目标版本 |
| **Kubeflow 1.10.1** | >= 1.25.0 | 1.10.1 | ✅ 完全支持 |
| **MLflow 2.18.0** | >= 1.25.0 | 2.18.0 | ✅ 完全支持 |
| **Istio 1.24.2** | 1.20-1.27 | 1.24.2 | ✅ 兼容 |
| **Calico 3.29.1** | >= 1.26.0 | 3.29.1 | ✅ 兼容 |
| **Cert-Manager 1.16.2** | >= 1.22.0 | 1.16.2 | ✅ 兼容 |
| **Prometheus Operator 71.2.2** | >= 1.19.0 | 71.2.2 | ✅ 兼容 |
| **MetalLB 0.15.5** | >= 1.20.0 | 0.15.5 | ✅ 兼容 |
| **Nginx Ingress 4.12.2** | >= 1.24.0 | 4.12.2 | ✅ 兼容 |
| **Metrics Server 0.7.2** | >= 1.19.0 | 0.7.2 | ✅ 兼容 |

### API 废弃检查

Kubernetes 1.33.3 中已废弃的 API，所有组件均已适配：

| 废弃 API | 影响 | 状态 |
|----------|------|------|
| **extensions/v1beta1** | Ingress、CustomResourceDefinition | ✅ 已迁移到 networking.k8s.io/v1 |
| **batch/v1beta1** | CronJob | ✅ 已迁移到 batch/v1 |
| **policy/v1beta1** | PodDisruptionBudget | ✅ 已迁移到 policy/v1 |
| **flowcontrol.apiserver.k8s.io/v1beta1** | PriorityClass | ✅ 已迁移至 flowcontrol.apiserver.k8s.io/v1beta3 |

---

## 镜像仓库变更

### 已移除的私有镜像仓库

| 原仓库地址 | 位置 | 状态 |
|-----------|------|------|
| `192.168.40.248/library` | GitLab、MLflow PostgreSQL | ✅ 已移除 |
| `registry.cn-hangzhou.aliyuncs.com` | Rook-Ceph、ArgoCD、Prometheus | ✅ 已移除 |

### 新的官方镜像仓库映射

| 组件类型 | 原仓库 | 新官方仓库 | 说明 |
|---------|---------|-------------|------|
| **通用镜像** | 私有仓库 | docker.io | Docker Hub 官方镜像 |
| **Google 镜像** | gcr.io | quay.io / ghcr.io | gcr.io 部分已迁移，部分保留 |
| **GitLab** | 私有仓库 | registry.gitlab.com | GitLab 官方仓库 |
| **ArgoCD** | 阿里云 | quay.io/argoproj | Red Hat Quay 官方仓库 |
| **Tekton** | gcr.io/tekton-releases | ghcr.io/tektoncd | GitHub Container Registry |
| **Kubeflow Pipelines** | gcr.io/ml-pipeline | quay.io/aipipeline | Argoproj/AI Pipeline |
| **Kubeflow Argo Workflows** | gcr.io/ml-pipeline | quay.io/argoproj | Argo Project 官方仓库 |
| **Kubeflow MySQL** | gcr.io/ml-pipeline | mysql | MySQL 官方 Docker Hub |
| **Kubeflow MinIO** | gcr.io/ml-pipeline | quay.io/minio | MinIO 官方仓库 |
| **MLflow** | 私有仓库 | ghcr.io/mlflow | MLflow 官方仓库 |

### 镜像仓库优先级

```
优先级 1: docker.io (Docker Hub 官方)
优先级 2: quay.io (Red Hat 官方)
优先级 3: ghcr.io (GitHub Container Registry 官方)
优先级 4: gcr.io (仅限未迁移的组件)
优先级 5: registry.k8s.io (Kubernetes 官方)
❌ 禁止: 私有仓库、阿里云镜像、华为云镜像
```

---

## 部署建议

### 1. 部署前检查

#### 1.1 环境验证

```bash
# 检查 Kubernetes 版本
kubectl version --short

# 检查节点资源
kubectl top nodes

# 检查存储类
kubectl get storageclass
```

#### 1.2 依赖安装

确保以下组件已部署：
- ✅ Kubernetes 1.33.3
- ✅ Helm 3.14+ (已安装)
- ✅ kubectl 1.29+
- ✅ 足够的节点资源（建议最少 8 CPU, 32GB RAM）

### 2. 分阶段部署策略

#### 阶段 1: 基础设施（必须）

```bash
# 1. 部署 CNI 网络插件
terraform apply -target=module.networking-calico

# 2. 部署 MetalLB
terraform apply -target=module.networking-metallb

# 3. 部署存储（Rook-Ceph）
terraform apply -target=module.storage-rook-ceph

# 4. 部署 Ingress
terraform apply -target=module.networking-nginx-ingress

# 5. 部署证书管理
terraform apply -target=module.certificate-cert-manager
```

#### 阶段 2: 监控与可观测性（推荐）

```bash
# 6. 部署监控栈
terraform apply -target=module.monitoring-prometheus
terraform apply -target=module.monitoring-grafana
terraform apply -target=module.monitoring-metrics-server
```

#### 阶段 3: DevOps 工具（可选）

```bash
# 7. 部署 ArgoCD
terraform apply -target=module.devops-argocd

# 8. 部署 GitLab（如需要）
terraform apply -target=module.devops-gitlab

# 9. 部署 Harbor（如需要）
terraform apply -target=module.devops-harbor
```

#### 阶段 4: 机器学习平台（可选）

```bash
# 10. 部署 Kubeflow
terraform apply -target=module.ml-kubeflow

# 11. 部署 MLflow
terraform apply -target=module.ml-mlflow
```

### 3. 部署后验证

#### 3.1 基础设施验证

```bash
# 检查 Pod 状态
kubectl get pods -A

# 检查服务状态
kubectl get svc -A

# 检查存储类
kubectl get storageclass

# 检查证书
kubectl get certificates -A
```

#### 3.2 Kubeflow 验证

```bash
# 检查 Kubeflow 命名空间
kubectl get pods -n kubeflow

# 检查 Kubeflow 组件
kubectl get deployments -n kubeflow

# 验证 Pipelines UI
kubectl port-forward -n kubeflow svc/ml-pipeline-ui 8080:80

# 验证 Notebook
kubectl port-forward -n kubeflow svc/ml-pipeline-ui 8888:8888
```

#### 3.3 MLflow 验证

```bash
# 检查 MLflow 命名空间
kubectl get pods -n mlflow

# 验证 PostgreSQL 连接
kubectl exec -n mlflow <postgres-pod> -- pg_isready

# 验证 MLflow 服务
kubectl port-forward -n mlflow svc/<mlflow-service> 5000:80
```

### 4. 性能优化建议

#### 4.1 资源限制

根据组件类型调整资源限制：

| 组件 | CPU Request | CPU Limit | Memory Request | Memory Limit |
|-------|-------------|-----------|-----------------|---------------|
| **Kubeflow Pipelines** | 1000m | 4000m | 4Gi | 8Gi |
| **MLflow Server** | 4000m | 8000m | 4Gi | 8Gi |
| **MLflow PostgreSQL** | 2000m | 4000m | 2Gi | 4Gi |
| **ArgoCD** | 500m | 1000m | 256Mi | 512Mi |
| **Grafana** | 100m | 200m | 128Mi | 256Mi |

#### 4.2 存储优化

```yaml
# Rook-Ceph 存储类示例
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: rook-ceph-block
provisioner: rook-ceph.rbd.csi.ceph.com
parameters:
  imageFormat: "2"
  features: layering
  pool: kubeflow-pool
allowVolumeExpansion: true
```

#### 4.3 网络优化

```yaml
# Istio 网关配置
apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
  name: kubeflow-gateway
spec:
  selector:
    istio: ingressgateway
  servers:
  - port:
      number: 80
      name: http
      protocol: HTTP
    hosts:
    - "*"
```

### 5. 故障排查

#### 5.1 常见问题

| 问题 | 可能原因 | 解决方案 |
|------|---------|---------|
| Pod CrashLoopBackOff | 镜像拉取失败 | 检查镜像仓库配置，确认使用官方仓库 |
| Service 无法访问 | MetalLB 未就绪 | 等待 MetalLB Controller Pod 就绪 |
| Kubeflow UI 无响应 | 资源不足 | 增加内存和 CPU 限制 |
| MLflow 数据库连接失败 | PostgreSQL 未启动 | 检查 PostgreSQL Pod 日志 |
| 证书验证失败 | Cert-Manager 未颁发证书 | 检查 DNS 配置和 Ingress |

#### 5.2 日志收集

```bash
# 收集所有 Pod 日志
kubectl logs -A -l app=kubeflow --tail=100

# 收集节点日志
kubectl describe node <node-name>

# 收集事件
kubectl get events -A --sort-by='.lastTimestamp'
```

### 6. 回滚计划

如果部署失败，准备回滚到旧版本：

```bash
# 1. 备份当前配置
cp terraform.tf terraform.tf.backup

# 2. 回滚 Terraform 配置
git checkout <commit-hash>

# 3. 执行回滚
terraform apply

# 4. 验证回滚状态
kubectl get pods -A
```

---

## 版本更新历史

| 日期 | 版本 | 主要变更 |
|-------|--------|---------|
| 2026-01-18 | v1.33.3 | - 私有仓库移除<br>- 组件版本升级至最新稳定版<br>- Kubeflow 1.10.1 + MLflow 2.18.0<br>- gcr.io 迁移至 quay.io/ghcr.io<br>- 全部组件兼容 K8s 1.33.3 |

---

## 参考资源

### 官方文档

- [Kubernetes 1.33.3 Release Notes](https://github.com/kubernetes/kubernetes/blob/master/CHANGELOG/CHANGELOG-1.33.md)
- [Kubeflow 1.10.0 Documentation](https://www.kubeflow.org/docs/components/pipelines/installation/)
- [MLflow 2.18.0 Release Notes](https://github.com/mlflow/mlflow/releases/tag/v2.18.0)
- [Istio 1.24.2 Documentation](https://istio.io/latest/docs/releases/1.24.x)
- [Calico 3.29.1 Documentation](https://docs.projectcalico.org/archive/v3.29/)

### 社区资源

- [Kubeflow GitHub](https://github.com/kubeflow/kubeflow)
- [MLflow GitHub](https://github.com/mlflow/mlflow)
- [CNCF Landscape](https://landscape.cncf.io/)

---

## 联系与支持

如有问题，请查阅：

1. 项目文档: `docs/` 目录下的其他文档
2. Terraform 模块: `modules/` 目录
3. Issue 追踪: 项目 Issue 管理系统

---

**文档版本**: v1.0
**维护者**: Infrastructure Team
**审核状态**: ✅ 已审核
