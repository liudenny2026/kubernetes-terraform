# MinIO Kubernetes Terraform部署指南

本项目使用Terraform模块化架构将MinIO对象存储部署到Kubernetes集群。

## 项目特点

### 模块化架构

- ✅ **代码复用**: MinIO逻辑封装在独立模块中
- ✅ **清晰分离**: 根模块协调，子模块实现
- ✅ **易于扩展**: 可以轻松添加多个MinIO实例

### 技术特性

- ✅ 支持最新Kubernetes版本（v1.28+）
- ✅ 使用最新的MinIO稳定版本
- ✅ 容器安全上下文
- ✅ 健康探针配置
- ✅ 资源限制配置
- ✅ 本地存储PV（40G）

### 目录结构

```
minio/
├── main.tf                # 根模块入口
├── variables.tf           # 根模块变量（精简版）
├── outputs.tf             # 根模块输出
├── terraform.tfvars       # 变量配置
├── terraform.tfvars.example  # 变量模板
├── versions.tf            # Terraform版本和provider配置
├── modules/
│   └── minio/            # MinIO子模块
│       ├── main.tf         # 模块主配置
│       ├── variables.tf     # 模块变量
│       ├── outputs.tf      # 模块输出
│       ├── versions.tf     # 模块provider
│       ├── namespace.tf    # 命名空间
│       ├── deployment.tf  # Deployment
│       └── service.tf      # Service
└── README.md
```

## 快速开始

### 1. 初始化Terraform

```bash
terraform init
```

### 2. 配置变量

编辑 `minio.terraform.tfvars`，重点配置以下参数：

- `node_name`: **重要！Kubernetes worker节点名称**（必须是worker节点，如node1或node2）
- `minio_root_user`: MinIO管理员用户名
- `minio_root_password`: MinIO管理员密码（建议使用强密码）

**重要提示**:
- 必须使用worker节点（非control-plane节点）
- 可用的worker节点名称：`node1`, `node2`
- 查看节点命令：`kubectl get nodes -o wide`

### 3. 准备节点存储目录

在选中的worker节点上创建存储目录：

```bash
# SSH登录到节点
ssh user@<节点IP>

# 创建存储目录
sudo mkdir -p /data/minio

# 设置权限（MinIO使用UID 1000）
sudo chown 1000:1000 /data/minio
sudo chmod 755 /data/minio

# 验证
ls -la /data/
```

### 4. 执行部署

```bash
# 计划部署
terraform plan

# 执行部署
terraform apply -auto-approve
```

### 5. 验证部署

查看输出：

```bash
terraform output
```

## 访问MinIO

### 集群内部访问

- API: `http://minio.minio.svc.cluster.local:9000`
- 控制台: `http://minio.minio.svc.cluster.local:9001`

### 外部访问

需要手动创建LoadBalancer Service或Ingress：

```bash
# 示例：创建LoadBalancer Service
kubectl expose deployment minio -n minio --port=9000 --type=LoadBalancer --name=minio-lb
```

### 查看Secret内容

查看MinIO的认证信息：

```bash
# 查看Secret的完整配置
kubectl get secret minio-secret -n minio -o yaml
```

输出示例：

```yaml
apiVersion: v1
data:
  CONSOLE_ACCESS_KEY: WVdSdGFXND0=
  CONSOLE_SECRET_KEY: VFdsdWFVOUJRV1J0YVc0eU1ESTBRRk5sWTNWeVpRPT0=
  rootPassword: VFdsdWFVOUJRV1J0YVc0eU1ESTBRRk5sWTNWeVpRPT0=
  rootUser: WVdSdGFXND0=
kind: Secret
metadata:
  creationTimestamp: "2026-01-09T14:18:38Z"
  labels:
    app: minio
  name: minio-secret
  namespace: minio
  resourceVersion: "1294636"
  uid: 55a3daa9-0b2a-479d-9823-1d787304a98e
type: Opaque
```

**解码base64值**：

Secret中的值是base64编码的，使用以下命令解码：

```bash
# 解码rootUser（管理员用户名）
echo "YWRtaW4=" | base64 -d  # 输出: admin

# 解码rootPassword（管理员密码）
echo "cGFzc3dvcmQ=" | base64 -d  # 输出: password

# 解码CONSOLE_ACCESS_KEY（控制台访问密钥）
echo "WVdSdGFXND0=" | base64 -d

# 解码CONSOLE_SECRET_KEY（控制台密钥）
echo "VFdsdWFVOUJRV1J0YVc0eU1ESTBRRk5sWTNWeVpRPT0=" | base64 -d
```

**注意**：实际使用时，请将 `YWRtaW4=` 和 `cGFzc3dvcmQ=` 替换为从您的Secret中获取的实际base64值。

## 文档

- [modules/minio/README.md](./modules/minio/README.md) - MinIO模块详细文档
