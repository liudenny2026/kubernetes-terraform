# Kubernetes Kubeconfig 文件管理指南

## 目录下可以有多个 config 文件吗？

**答案：可以！** `~/.kube/` 目录下可以存在多个 kubeconfig 文件，但 Kubernetes 只会读取默认的 `~/.kube/config` 文件。

## 解决方案：合并多个 kubeconfig 文件

### 方式一：KUBECONFIG 环境变量（推荐）

使用 `KUBECONFIG` 环境变量可以同时指定多个 kubeconfig 文件，kubectl 会自动合并它们。

#### 1. 准备独立的 kubeconfig 文件

```bash
# 目录结构
~/.kube/
├── config               # 主配置文件（空或默认）
├── config-dev           # 开发集群配置
├── config-prod          # 生产集群配置
└── config-cluster1      # 其他集群配置
```

#### 2. 使用 KUBECONFIG 变量

```bash
# 临时设置多个 kubeconfig 文件
export KUBECONFIG=~/.kube/config-dev:~/.kube/config-prod

# 查看合并后的配置
kubectl config view

# 查看所有上下文
kubectl config get-contexts
```

#### 3. 永久设置（添加到 shell 配置）

```bash
# Bash (~/.bashrc 或 ~/.bash_profile)
echo 'export KUBECONFIG=~/.kube/config-dev:~/.kube/config-prod' >> ~/.bashrc
source ~/.bashrc

# Zsh (~/.zshrc)
echo 'export KUBECONFIG=~/.kube/config-dev:~/.kube/config-prod' >> ~/.zshrc
source ~/.zshrc
```

#### 4. 验证合并效果

```bash
# 查看合并后的所有上下文
kubectl config get-contexts

# 查看合并后的所有集群
kubectl config get-clusters

# 查看合并后的所有用户
kubectl config get-users
```

### 方式二：合并 kubeconfig 文件（永久）

将多个 kubeconfig 文件合并到一个 `~/.kube/config` 文件中。

#### 方法 1：使用 kubectl config view

```bash
# 临时合并
KUBECONFIG=~/.kube/config-dev:~/.kube/config-prod kubectl config view --flatten > ~/.kube/config.tmp
mv ~/.kube/config.tmp ~/.kube/config

# 验证
kubectl config get-contexts
```

#### 方法 2：使用 kubectl config merge（推荐）

```bash
# 创建基础配置（如果不存在）
touch ~/.kube/config

# 合并开发集群
KUBECONFIG=~/.kube/config:~/.kube/config-dev kubectl config view --flatten > ~/.kube/config.tmp
mv ~/.kube/config.tmp ~/.kube/config

# 合并生产集群
KUBECONFIG=~/.kube/config:~/.kube/config-prod kubectl config view --flatten > ~/.kube/config.tmp
mv ~/.kube/config.tmp ~/.kube/config

# 验证
kubectl config get-contexts
```

#### 方法 3：手动合并（JSON/YAML）

```yaml
# ~/.kube/config
apiVersion: v1
kind: Config
clusters:
  # 开发集群
  - name: dev.kubernetes.cluster
    cluster:
      server: https://dev-k8s-api.example.com:6443
      certificate-authority-data: <base64-ca-dev>

  # 生产集群
  - name: prod.kubernetes.cluster
    cluster:
      server: https://prod-k8s-api.example.com:6443
      certificate-authority-data: <base64-ca-prod>

users:
  # 开发用户
  - name: dev-admin
    user:
      client-certificate-data: <base64-cert-dev>
      client-key-data: <base64-key-dev>

  # 生产用户
  - name: prod-admin
    user:
      client-certificate-data: <base64-cert-prod>
      client-key-data: <base64-key-prod>

contexts:
  # 开发上下文
  - name: dev.kubernetes.cluster
    context:
      cluster: dev.kubernetes.cluster
      user: dev-admin

  # 生产上下文
  - name: prod.kubernetes.cluster
    context:
      cluster: prod.kubernetes.cluster
      user: prod-admin

current-context: dev.kubernetes.cluster
```

### 方式三：使用工具合并

#### 使用 kubectx 工具

```bash
# 安装 kubectx
git clone https://github.com/ahmetb/kubectx.git ~/.kubectx
ln -s ~/.kubectx/kubectx /usr/local/bin/kubectx
ln -s ~/.kubectx/kubens /usr/local/bin/kubens

# 列出所有上下文
kubectx

# 切换上下文
kubectx prod.kubernetes.cluster
```

#### 使用 kubectl-ctx 插件

```bash
# 安装插件
kubectl krew install ctx

# 列出上下文
kubectl ctx

# 切换上下文
kubectl ctx prod.kubernetes.cluster
```

## 实际操作示例

### 场景 1：你有两个独立的 kubeconfig 文件

假设你有：
- `dev-kubeconfig.yaml` - 开发集群
- `prod-kubeconfig.yaml` - 生产集群

#### 步骤 1：复制到 ~/.kube/ 目录

```bash
mkdir -p ~/.kube
cp dev-kubeconfig.yaml ~/.kube/config-dev
cp prod-kubeconfig.yaml ~/.kube/config-prod
```

#### 步骤 2：选择合并方式

**选项 A：使用环境变量（推荐用于开发）**

```bash
# 添加到 ~/.bashrc
cat >> ~/.bashrc << 'EOF'
# Kubernetes 多集群配置
export KUBECONFIG=~/.kube/config-dev:~/.kube/config-prod
EOF

# 重新加载
source ~/.bashrc

# 验证
kubectl config get-contexts
```

**选项 B：合并到一个文件（推荐用于生产）**

```bash
# 创建基础文件
touch ~/.kube/config

# 合并
KUBECONFIG=~/.kube/config:~/.kube/config-dev:~/.kube/config-prod \
  kubectl config view --flatten > ~/.kube/config.tmp

# 应用
mv ~/.kube/config.tmp ~/.kube/config

# 验证
kubectl config get-contexts
```

### 场景 2：从云服务商下载的 kubeconfig

```bash
# AWS EKS
aws eks update-kubeconfig --name dev-cluster --kubeconfig ~/.kube/config-dev
aws eks update-kubeconfig --name prod-cluster --kubeconfig ~/.kube/config-prod

# GKE
gcloud container clusters get-credentials dev-cluster --zone us-central1-a --kubeconfig ~/.kube/config-dev
gcloud container clusters get-credentials prod-cluster --zone us-central1-a --kubeconfig ~/.kube/config-prod

# Azure AKS
az aks get-credentials --name dev-cluster --resource-group myResourceGroup --file ~/.kube/config-dev
az aks get-credentials --name prod-cluster --resource-group myResourceGroup --file ~/.kube/config-prod

# 合并所有配置
KUBECONFIG=~/.kube/config-dev:~/.kube/config-prod \
  kubectl config view --flatten > ~/.kube/config
```

## 管理 kubeconfig 的最佳实践

### 1. 目录结构

```bash
~/.kube/
├── config                    # 主配置文件（合并后的）
├── config-dev                # 开发环境原始配置
├── config-prod               # 生产环境原始配置
├── config-stage              # 预发布环境原始配置
└── backups/                  # 配置备份
    ├── config-20250118.yaml
    └── config-20250117.yaml
```

### 2. 命名约定

```bash
# 建议的命名规范
~/.kube/config-dev                # 开发环境
~/.kube/config-prod               # 生产环境
~/.kube/config-stage              # 预发布环境
~/.kube/config-cluster-name       # 特定集群
~/.kube/config-project-name       # 特定项目
```

### 3. 上下文命名

```bash
# 格式: {environment}.{project}.{cluster}
dev.kubernetes.dev-cluster
prod.kubernetes.prod-cluster
stage.kubernetes.stage-cluster
```

### 4. 备份配置

```bash
# 创建备份脚本
cat > ~/.kube/backup.sh << 'EOF'
#!/bin/bash
BACKUP_DIR="$HOME/.kube/backups"
mkdir -p "$BACKUP_DIR"
cp ~/.kube/config "$BACKUP_DIR/config-$(date +%Y%m%d-%H%M%S).yaml"
echo "Kubeconfig backed up to $BACKUP_DIR"
EOF

chmod +x ~/.kube/backup.sh

# 定期备份（添加到 crontab）
echo "0 0 * * * ~/.kube/backup.sh" | crontab -
```

## 故障排除

### 问题 1：合并后配置混乱

```bash
# 查看原始配置
kubectl config view --raw

# 重新生成干净的配置
kubectl config view --flatten > ~/.kube/config.new
mv ~/.kube/config.new ~/.kube/config
```

### 问题 2：无法切换上下文

```bash
# 查看所有上下文
kubectl config get-contexts

# 检查当前上下文
kubectl config current-context

# 强制设置上下文
kubectl config use-context prod.kubernetes.cluster
```

### 问题 3：证书过期

```bash
# 检查证书过期时间
kubectl config view --raw | grep -A 3 "client-certificate-data"

# 更新证书（根据云服务商）
# EKS: aws eks update-kubeconfig --name cluster-name
# GKE: gcloud container clusters get-credentials cluster-name
# AKS: az aks get-credentials --name cluster-name --resource-group group-name
```

## 与 Terraform 集成

### 在 Terraform 中使用多个 kubeconfig

#### 方式一：使用环境变量

```bash
# 开发环境
cd environments/dev
export KUBECONFIG=~/.kube/config-dev:~/.kube/config-prod
export TF_VAR_config_context="dev.kubernetes.cluster"
terraform apply

# 生产环境
cd environments/prod
export KUBECONFIG=~/.kube/config-dev:~/.kube/config-prod
export TF_VAR_config_context="prod.kubernetes.cluster"
terraform apply
```

#### 方式二：在 terraform.tfvars 中指定

**environments/dev/terraform.tfvars**:
```hcl
kubeconfig_path = "~/.kube/config-dev:~/.kube/config-prod"
config_context  = "dev.kubernetes.cluster"
```

**environments/prod/terraform.tfvars**:
```hcl
kubeconfig_path = "~/.kube/config-dev:~/.kube/config-prod"
config_context  = "prod.kubernetes.cluster"
```

#### 方式三：使用独立的 kubeconfig 文件

```bash
# 为每个环境创建独立的 kubeconfig
kubectl config use-context dev.kubernetes.cluster
kubectl config view --flatten > ~/.kube/dev-config

kubectl config use-context prod.kubernetes.cluster
kubectl config view --flatten > ~/.kube/prod-config

# 在 Terraform 中使用
cd environments/dev
terraform apply -var="kubeconfig_path=~/.kube/dev-config"

cd environments/prod
terraform apply -var="kubeconfig_path=~/.kube/prod-config"
```

## 总结

### 推荐方案对比

| 方案 | 优点 | 缺点 | 适用场景 |
|------|------|------|---------|
| KUBECONFIG 环境变量 | 灵活，可动态添加 | 每次会话需要设置 | 开发环境，频繁切换 |
| 合并到单一文件 | 简单，kubectl 默认使用 | 文件可能很大，合并复杂 | 生产环境，稳定配置 |
| 独立 kubeconfig 文件 | 完全隔离，互不影响 | 需要明确指定路径 | CI/CD，自动化脚本 |

### 推荐做法

1. **开发环境**：使用 KUBECONFIG 环境变量，方便添加新集群
2. **生产环境**：合并到单一 `~/.kube/config`，简化管理
3. **CI/CD**：使用独立 kubeconfig 文件，避免冲突

### 快速开始

```bash
# 1. 准备配置文件
cp dev-kubeconfig.yaml ~/.kube/config-dev
cp prod-kubeconfig.yaml ~/.kube/config-prod

# 2. 设置环境变量（推荐）
echo 'export KUBECONFIG=~/.kube/config-dev:~/.kube/config-prod' >> ~/.bashrc
source ~/.bashrc

# 3. 验证
kubectl config get-contexts

# 4. 使用
kubectl config use-context dev.kubernetes.cluster
kubectl config use-context prod.kubernetes.cluster
```
