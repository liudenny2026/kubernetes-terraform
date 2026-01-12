# Harbor 部署 - Terraform + Helm 最佳实践

## 概述

本项目采用 **Terraform + Helm** 的最佳实践来部署 Harbor 容器镜像仓库：

- **Terraform**: 管理基础设施和 Helm Release 的生命周期
- **Helm**: 使用官方 Helm Chart 部署 Harbor 应用

## 架构优势

### 为什么使用 Terraform + Helm？

1. **Terraform 的优势**:
   - 基础设施即代码 (IaC)
   - 状态管理和幂等性
   - 版本控制和协作
   - 环境一致性

2. **Helm 的优势**:
   - 官方维护的 Chart，经过充分测试
   - 简化复杂应用的部署
   - 版本化升级和回滚
   - 可配置的价值观文件

3. **最佳实践结合**:
   - Terraform 管理 Helm Release 的生命周期
   - 避免手写大量 Kubernetes 资源
   - 减少配置错误和复杂性
   - 易于维护和扩展

## 前置要求

1. Kubernetes 集群 (v1.19+)
2. Terraform v1.0+
3. Helm v3.0+
4. kubectl 配置正确
5. MetalLB (用于 LoadBalancer 类型服务)

## 快速开始

### 1. 初始化 Terraform

```bash
cd environments/dev
terraform init
```

### 2. 查看部署计划

```bash
terraform plan
```

### 3. 部署 Harbor

```bash
terraform apply -auto-approve
```

### 4. 获取访问信息

部署完成后，运行：

```bash
terraform output
```

### 5. 获取 LoadBalancer IP

```bash
kubectl get svc -n harbor harbor
```

## 访问 Harbor

### Web 界面

```
http://<LOADBALANCER_IP>
```

默认凭证:
- 用户名: `admin`
- 密码: 查看 `terraform output harbor_admin_password`

### Docker 登录

```bash
docker login <LOADBALANCER_IP> -u admin -p <PASSWORD>
```

## 配置说明

### 存储配置

默认使用 `local-path` 存储类，适合开发和测试环境。

生产环境建议使用:
- `rook-ceph-blockstorage` (Ceph)
- `longhorn`
- 其他高可用存储类

### 网络配置

默认使用 LoadBalancer 类型服务，需要 MetalLB 支持。

如需使用 NodePort:

```hcl
set {
  name  = "expose.type"
  value = "nodePort"
}
```

### TLS/HTTPS 配置

启用 TLS：

```hcl
set {
  name  = "expose.tls.enabled"
  value = "true"
}

set {
  name  = "expose.tls.certSource"
  value = "secret"
}
```

## 常用命令

### 查看 Harbor 状态

```bash
kubectl get pods -n harbor
kubectl get svc -n harbor
kubectl get pvc -n harbor
```

### 查看日志

```bash
kubectl logs -n harbor deployment/harbor-core
kubectl logs -n harbor deployment/harbor-jobservice
```

### 升级 Harbor

```bash
terraform apply -auto-approve
```

### 卸载 Harbor

```bash
terraform destroy -auto-approve
```

## 故障排查

### Pod 处于 Pending 状态

检查 PVC 状态:
```bash
kubectl get pvc -n harbor
```

如果 PVC 处于 Pending，检查存储类和 PV 配置。

### Pod 处于 CrashLoopBackOff

查看日志:
```bash
kubectl logs -n harbor <pod-name>
kubectl describe pod -n harbor <pod-name>
```

### 无法访问 Web 界面

1. 检查 Service 状态:
```bash
kubectl get svc -n harbor
```

2. 检查 LoadBalancer IP:
```bash
kubectl get svc -n harbor harbor -o jsonpath='{.status.loadBalancer.ingress[0].ip}'
```

3. 检查防火墙规则

## 生产环境建议

1. **存储**: 使用高可用存储类 (Ceph RBD, Longhorn)
2. **备份**: 定期备份 Harbor 数据库和镜像存储
3. **监控**: 集成 Prometheus 和 Grafana
4. **日志**: 使用 ELK 或 Loki 收集日志
5. **安全**: 启用 TLS，使用强密码，配置 RBAC
6. **高可用**: 配置多副本，使用外部数据库和 Redis

## 项目结构

```
harbor/
├── environments/
│   ├── dev/                  # 开发环境配置
│   │   ├── main.tf           # 主配置文件 (Helm provider)
│   │   ├── variables.tf      # 变量定义
│   │   ├── outputs.tf        # 输出定义
│   │   └── terraform.tfvars # 变量值
│   ├── prod/                 # 生产环境配置
│   └── stage/                # 预发布环境配置
└── custom-values.yaml        # 自定义 Helm values (可选)
```

## 参考资料

- [Harbor 官方文档](https://goharbor.io/docs/)
- [Harbor Helm Chart](https://github.com/goharbor/harbor-helm)
- [Terraform Helm Provider](https://registry.terraform.io/providers/hashicorp/helm/latest/docs)
