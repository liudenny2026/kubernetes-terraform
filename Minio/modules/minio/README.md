# MinIO Terraform模块

## 模块说明

这是一个可复用的Terraform模块，用于在Kubernetes集群中部署MinIO对象存储服务。

## 部署前准备

**重要**: 在执行部署前，请完成以下准备工作：

### 1. 准备存储目录

**关键步骤**: 在目标节点上创建存储目录并设置权限：

```bash
# SSH登录到目标节点
# 创建存储目录
sudo mkdir -p /data/Minio

# 设置权限（MinIO容器使用UID/GID 1000运行）
sudo chown 1000:1000 /data/Minio
sudo chmod 755 /data/Minio
```

### 2. 检查节点信息

查看当前Kubernetes集群的节点列表：

```bash
kubectl get nodes -o wide
```

**重要**: 选择一个用于PV本地存储的节点名称，该名称将在`terraform.tfvars`中的`node_name`变量中使用。

## 用法

### 基本用法

```hcl
module "minio" {
  source = "./modules/minio"

  # 必需配置
  node_name = "node1"  # Kubernetes worker节点名称

  # 可选配置（使用默认值）
  namespace = "minio"
  storage_capacity = "40Gi"
}
```

### 完整配置示例

```hcl
module "minio" {
  source = "./modules/minio"

  # 命名空间
  namespace          = "minio"
  app_name           = "minio"

  # 存储配置
  node_name          = "node1"
  storage_path        = "/data/minio"
  storage_capacity    = "40Gi"
  storage_class_name = "minio-sc"

  # 资源命名
  pv_name           = "minio-pv"
  pvc_name          = "minio-pvc"
  deployment_name    = "minio"
  service_name      = "minio"
  secret_name       = "minio-secret"

  # MinIO配置
  replicas                  = 1
  minio_image              = "192.168.40.248/library/minio/minio:RELEASE.2025-07-23T15-54-02Z"
  minio_root_user          = "admin"
  minio_root_password      = "MinIO@Admin2024@Secure"
  minio_root_user_b64      = "YWRtaW4="
  minio_root_password_b64  = "TWluaU9BQWRtaW4yMDI0QFNlY3VyZQ=="

  # 安全配置
  minio_user_id         = 1000
  minio_group_id        = 1000

  # 端口配置
  minio_api_port        = 9000
  minio_console_port    = 9001

  # 资源限制
  minio_cpu_request    = "500m"
  minio_cpu_limit      = "2000m"
  minio_memory_request = "1Gi"
  minio_memory_limit   = "4Gi"
}
```

## 创建的资源

模块会创建以下Kubernetes资源：

1. **Namespace** - 独立的命名空间
2. **StorageClass** - 本地存储类
3. **PersistentVolume** - 40G本地存储
4. **PersistentVolumeClaim** - 存储声明
5. **Secret** - MinIO访问凭证
6. **Deployment** - MinIO应用部署
7. **Service (ClusterIP)** - 集群内部访问
8. **Service (LoadBalancer)** - 外部访问（可选）

## 模块输入变量

| 变量名 | 类型 | 默认值 | 描述 | 必需 |
|---------|------|---------|--------|------|
| namespace | string | "minio" | Kubernetes命名空间 | 否 |
| app_name | string | "minio" | 应用名称 | 否 |
| node_name | string | "node1" | Kubernetes节点名称 | 否 |
| storage_path | string | "/data/minio" | PV本地存储路径 | 否 |
| storage_capacity | string | "40Gi" | 存储容量 | 否 |
| storage_class_name | string | "minio-sc" | StorageClass名称 | 否 |
| pv_name | string | "minio-pv" | PV名称 | 否 |
| pvc_name | string | "minio-pvc" | PVC名称 | 否 |
| deployment_name | string | "minio" | Deployment名称 | 否 |
| service_name | string | "minio" | Service名称 | 否 |
| secret_name | string | "minio-secret" | Secret名称 | 否 |
| replicas | number | 1 | MinIO副本数 | 否 |
| minio_image | string | - | MinIO镜像地址 | **是** |
| minio_root_user | string | "admin" | 管理员用户名 | 否 |
| minio_root_password | string | - | 管理员密码 | **是** |
| minio_root_user_b64 | string | - | Base64编码的用户名 | **是** |
| minio_root_password_b64 | string | - | Base64编码的密码 | **是** |
| minio_user_id | number | 1000 | 容器运行用户ID | 否 |
| minio_group_id | number | 1000 | 容器运行组ID | 否 |
| minio_api_port | number | 9000 | MinIO API端口 | 否 |
| minio_console_port | number | 9001 | MinIO控制台端口 | 否 |
| minio_cpu_request | string | "500m" | CPU请求 | 否 |
| minio_cpu_limit | string | "2000m" | CPU限制 | 否 |
| minio_memory_request | string | "1Gi" | 内存请求 | 否 |
| minio_memory_limit | string | "4Gi" | 内存限制 | 否 |

## 模块输出

| 输出名 | 类型 | 描述 |
|-------|------|--------|
| namespace | string | 命名空间名称 |
| storage_class_name | string | StorageClass名称 |
| pv_name | string | PV名称 |
| pvc_name | string | PVC名称 |
| deployment_name | string | Deployment名称 |
| service_name | string | Service名称 |
| secret_name | string | Secret名称 |
| minio_api_endpoint | string | MinIO API端点 |
| minio_console_endpoint | string | MinIO控制台端点 |

## 要求

### 系统要求

- Terraform >= 1.6
- HashiCorp Kubernetes Provider >= 2.23
- Kubernetes集群 v1.28+

### 集群要求

- 目标节点具备本地存储能力
- 可访问的私有镜像仓库
- 集群有足够的资源（至少2核CPU、4GB内存）

### 前置条件（必须完成）

**部署前必须完成以下步骤**：

1. 配置`~/.kube/config`文件
2. 确认集群连接正常
3. 在目标节点创建`/data/minio`目录
4. 设置目录权限为`1000:1000`

## 故障排查

### 节点名称不匹配

```
Error: 0 nodes are available: node(s) didn't find available persistent volumes to bind
```

**解决**: 确保`node_name`与实际节点名称完全匹配：
```bash
kubectl get nodes
```

### PVC无法绑定

```
Warning FailedScheduling: didn't find available persistent volumes to bind
```

**解决**:
1. 确认已在目标节点上创建存储目录：
   ```bash
   # 在目标节点上执行
   sudo mkdir -p /data/minio
   sudo chown 1000:1000 /data/minio
   sudo chmod 755 /data/minio
   ```
2. 检查PV状态：
   ```bash
   kubectl get pv minio-pv
   ```
3. 检查PVC状态：
   ```bash
   kubectl get pvc -n minio
   ```
4. 确保PV和PVC配置一致

## 示例

### 单命名空间部署

```hcl
module "minio" {
  source = "./modules/Minio"
  node_name = "node1"
}
```

### 多环境部署

```hcl
# 开发环境
module "minio_dev" {
  source = "./modules/minio"

  namespace          = "minio-dev"
  deployment_name    = "minio-dev"
  node_name          = "node1"
  storage_capacity    = "20Gi"
}

# 生产环境
module "minio_prod" {
  source = "./modules/minio"

  namespace          = "minio-prod"
  deployment_name    = "minio-prod"
  node_name          = "node2"
  storage_capacity    = "100Gi"
}
```
