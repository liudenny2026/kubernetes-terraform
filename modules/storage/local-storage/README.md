# Local-Path-Provisioner Terraform模块

## 模块说明

这是一个可复用的Terraform模块，用于在Kubernetes集群中部署Local-Path-Provisioner动态存储供应器。

## 部署前准备

**重要**: 在执行部署前，请完成以下准备工作：

### 1. 准备存储目录

**关键步骤**: 在集群节点上创建存储目录并设置权限：

```bash
# SSH登录到每个节点
# 创建存储目录
sudo mkdir -p /data/local-path-Storage

# 设置权限（确保Kubernetes有访问权限）
sudo chmod 777 /data/local-path-Storage
```

### 2. 检查节点信息

查看当前Kubernetes集群的节点列表：

```bash
kubectl get nodes -o wide
```

## 用法

### 基本用法

```hcl
module "local_path_storage" {
  source = "./modules/local-path-storage"

  # 可选配置（使用默认值）
  namespace = "local-path-storage"
  storage_class_name = "local-path"
  default_path = "/data/local-path-Storage"
}
```

### 完整配置示例

```hcl
module "local_path_storage" {
  source = "./modules/local-path-storage"

  # 命名空间
  namespace = "local-path-storage"
  
  # 存储类配置
  storage_class_name = "local-path"
  is_default_storage_class = true

  # 镜像配置
  provisioner_image = "rancher/local-path-provisioner:v0.0.34"

  # 路径配置
  default_path = "/data/local-path-Storage"
  
  # 节点路径映射配置
  node_path_map = [
    {
      node  = "DEFAULT_PATH_FOR_NON_LISTED_NODES"
      paths = ["/data/local-path-Storage"]
    }
  ]

  # 部署配置
  replicas = 1
}
```

## 创建的资源

模块会创建以下Kubernetes资源：

1. **Namespace** - 独立的命名空间 (local-path-storage)
2. **ServiceAccount** - 服务账户
3. **Role/ClusterRole** - RBAC权限配置
4. **RoleBinding/ClusterRoleBinding** - RBAC绑定
5. **ConfigMap** - 配置存储
6. **Deployment** - Local-Path-Provisioner应用部署
7. **StorageClass** - 本地存储类

## 模块输入变量

| 变量名 | 类型 | 默认值 | 描述 | 必需 |
|---------|------|---------|--------|------|
| namespace | string | "local-path-storage" | Kubernetes命名空间 | 否 |
| storage_class_name | string | "local-path" | StorageClass名称 | 否 |
| provisioner_image | string | "rancher/local-path-provisioner:v0.0.34" | Provisioner镜像地址 | 否 |
| helper_pod_image | string | "busybox:1.36" | Helper Pod镜像地址 | 否 |
| default_path | string | "/data/local-path-Storage" | 默认存储路径 | 否 |
| is_default_storage_class | bool | false | 是否设为默认StorageClass | 否 |
| replicas | number | 1 | Provisioner副本数 | 否 |
| node_path_map | list(object) | [{"node":"DEFAULT_PATH_FOR_NON_LISTED_NODES","paths":["/data/local-path-Storage"]}] | 节点路径映射配置 | 否 |
| image_pull_secrets | list(string) | [] | 镜像拉取Secret列表（用于私有镜像仓库） | 否 |
| docker_registry_enabled | bool | true | 是否创建Docker Registry Secret | 否 |
| docker_registry_secret_name | string | "harbor-secret" | Docker Registry Secret名称 | 否 |
| docker_registry_server | string | "192.168.40.248" | Docker Registry服务器地址 | 否 |
| docker_registry_username | string | "admin" | Docker Registry用户名 | 否 |
| docker_registry_password | string | "Harbor12345" | Docker Registry密码 | 否 |

## 模块输出

| 输出名 | 类型 | 描述 |
|-------|------|--------|
| namespace | string | 命名空间名称 |
| storage_class_name | string | StorageClass名称 |
| provisioner_status | string | Local-Path-Provisioner状态 |

## 要求

### 系统要求

- Terraform >= 1.6
- HashiCorp Kubernetes Provider >= 2.23
- Kubernetes集群 v1.28+

### 集群要求

- 集群有足够的资源（至少0.5核CPU、256MB内存）
- 节点具备本地存储能力
- 集群支持RBAC

### 前置条件（必须完成）

**部署前必须完成以下步骤**：

1. 配置`~/.kube/config`文件
2. 确认集群连接正常
3. 在目标节点创建`/data/local-path-Storage`目录（或自定义路径）
4. 设置目录权限为`777`

## 故障排查

### 节点路径不匹配

```
Error: Failed to create volume
```

**解决**: 确保节点上存在配置的路径：
```bash
# 在目标节点上执行
sudo mkdir -p /data/local-path-Storage
sudo chmod 777 /data/local-path-Storage
```

### Provisioner无法启动

```
Warning FailedScheduling: 0/1 nodes are available
```

**解决**:
1. 检查Provisioner状态：
   ```bash
   kubectl get pods -n local-path-storage
   ```
2. 检查日志：
   ```bash
   kubectl logs -n local-path-storage deployment/local-path-provisioner
   ```
3. 检查RBAC权限是否正确创建

## 使用示例

### 创建PVC

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: test-pvc
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: local-path
  resources:
    requests:
      storage: 30Gi  # 30GB容量
```

### 创建Pod使用PVC

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: test-pod
spec:
  containers:
  - name: test-container
    image: nginx
    volumeMounts:
    - mountPath: /data
      name: test-volume
  volumes:
  - name: test-volume
    persistentVolumeClaim:
      claimName: test-pvc
```

## 示例

### 单命名空间部署

```hcl
module "local_path_storage" {
  source = "./modules/local-path-storage"
}
```

### 多环境部署

```hcl
# 开发环境
module "local_path_dev" {
  source = "./modules/local-path-storage"

  namespace          = "local-path-dev"

  default_path       = "/data/local-path-Storage-dev"
}

# 生产环境
module "local_path_prod" {
  source = "./modules/local-path-storage"

  namespace          = "local-path-prod"

  default_path       = "/data/local-path-Storage-prod"
  is_default_storage_class = true
}
```