# Kubernetes 上的 Ceph 集群 Terraform 部署方案

此 Terraform 配置使用 Rook 操作员在 Kubernetes 集群上部署 Ceph 存储集群。

## 项目结构

```
ceph/
├── environments/          # 环境配置目录
│   └── dev/              # 开发环境配置
├── modules/ceph/         # Ceph 集群模块
│   ├── templates/         # YAML 模板文件
│   └── test-resources.yaml  # 测试资源配置
└── scripts/               # 节点准备脚本
```

## 技术栈

- **Terraform**: 基础设施即代码工具 (>= 1.0)
- **Kubernetes**: 容器编排平台
- **Rook**: Ceph 的云原生存储编排器 (v1.18.8)
- **Ceph**: 分布式存储系统 (v19.2.3 - Squid)
- **Helm**: Kubernetes 包管理器

## 镜像仓库

私有 Harbor 仓库：`192.168.40.248/library/`

**重要**: 确保所有节点已配置访问私有仓库的凭据。

## 部署流程

### 1. 准备节点

```bash
# Ubuntu 节点准备脚本
sudo bash scripts/prepare_nodes_ubuntu_cn.sh

# 验证节点准备
sudo bash scripts/verify_node_preparation_cn.sh
```

### 2. 部署 Ceph 集群

```bash
cd environments/dev

# 初始化 Terraform
terraform init

# 查看执行计划
terraform plan

# 应用配置
terraform apply
```

### 3. 验证部署

```bash
# 检查 Pod 状态
kubectl -n rook-ceph get pods

# 检查集群状态
kubectl -n rook-ceph get cephcluster
```

## 主要变量

| 变量名 | 类型 | 默认值 | 描述 |
|--------|------|--------|------|
| node_names | list | ["master", "node1", "node2"] | Ceph 部署节点列表 |
| storage_devices | list | ["sdb"] | 存储设备列表 |
| storage_size | number | 100 | 每设备存储大小（GB） |
| monitor_count | number | 3 | Ceph 监控器数量 |
| enable_dashboard | bool | true | 启用仪表板 |
| dashboard_loadbalancer_enabled | bool | false | 启用 LoadBalancer |

## 访问 Ceph 仪表板

### 端口转发方式

```bash
kubectl -n rook-ceph port-forward svc/rook-ceph-mgr-dashboard 8443:8443
```

访问 https://localhost:8443

### 获取密码

```bash
terraform output dashboard_password
```

## 测试存储功能

```bash
cd modules/ceph

# Linux/Mac
./run-tests.sh

# Windows
run-tests.bat
```

测试包括：
- RBD 块存储读写和性能测试
- CephFS 文件系统读写和性能测试
- 并发访问测试

## 清理部署

```bash
cd environments/dev
terraform destroy
```

## 故障排除

### 检查集群状态

```bash
# Ceph 集群状态
kubectl -n rook-ceph get cephcluster

# OSD 状态
kubectl -n rook-ceph get cephblockpools

# 操作员日志
kubectl -n rook-ceph logs -l app=rook-ceph-operator
```

### 常见问题

1. **CRD 未找到**: 确保 Rook 操作员已完全部署
2. **节点标签错误**: 确认节点名称与 `node_names` 变量匹配
3. **磁盘权限错误**: 验证 Ceph 可访问 `storage_devices` 指定的设备

## 注意事项

- 确保 `node_names` 指定的节点有足够容量的 `sdb` 磁盘（至少 100GB）
- 部署期间可通过 `kubectl -n rook-ceph get pods` 监控进度
- 生产环境部署前请先在开发环境充分测试