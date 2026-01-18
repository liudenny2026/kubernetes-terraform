# Windows 环境下的 Kubeconfig 管理指南

## 概述

在 Windows 系统下管理多个 Kubernetes 集群的 kubeconfig，有多种方式可选。本文档介绍最推荐和最方便的方案。

## Windows 环境分析

Windows 下有以下常见的 shell 环境：
1. **PowerShell** - Windows 原生，功能强大
2. **Git Bash** - Git for Windows 附带，类 Unix 环境
3. **WSL (Windows Subsystem for Linux)** - 完整 Linux 环境
4. **CMD** - 传统命令行，功能有限

## 推荐方案对比

| 方案 | 便利性 | 兼容性 | 推荐场景 | 难度 |
|------|--------|--------|----------|------|
| **方案一：PowerShell 配置文件** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | 日常开发、生产管理 | ⭐ 简单 |
| **方案二：Git Bash 环境变量** | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | Git Bash 用户 | ⭐ 简单 |
| **方案三：WSL + Linux 命令** | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ | 开发者、熟悉 Linux | ⭐⭐ 中等 |
| **方案四：独立 kubeconfig 文件** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | Terraform 部署 | ⭐ 简单 |

## 🏆 方案一：PowerShell 配置文件（最推荐）

### 为什么推荐？
- Windows 原生支持，无需额外安装
- 与 Terraform 兼容性最好
- 配置持久化，自动生效
- 支持复杂逻辑和条件判断

### 设置步骤

#### 步骤 1：准备 kubeconfig 文件

```powershell
# 创建目录（如果不存在）
New-Item -ItemType Directory -Force -Path $env:USERPROFILE\.kube

# 复制你的配置文件
# 假设你有 dev-kubeconfig.yaml 和 prod-kubeconfig.yaml
Copy-Item "dev-kubeconfig.yaml" "$env:USERPROFILE\.kube\config-dev"
Copy-Item "prod-kubeconfig.yaml" "$env:USERPROFILE\.kube\config-prod"
```

#### 步骤 2：创建 PowerShell 配置文件

```powershell
# 检查配置文件是否存在
Test-Path $PROFILE

# 如果不存在，创建它
if (-not (Test-Path $PROFILE)) {
    New-Item -ItemType File -Path $PROFILE -Force
}

# 查看配置文件位置
$PROFILE
# 通常输出: C:\Users\你的用户名\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1
```

#### 步骤 3：编辑配置文件

```powershell
# 使用记事本打开
notepad $PROFILE

# 或者使用 VS Code
code $PROFILE
```

添加以下内容：

```powershell
# ============================================================================
# Kubernetes 多集群配置
# ============================================================================

# 设置 KUBECONFIG 环境变量（合并多个配置文件）
$env:KUBECONFIG = "$env:USERPROFILE\.kube\config-dev;$env:USERPROFILE\.kube\config-prod"

# 可选：创建快捷函数
function kctx {
    param([string]$Context)
    kubectl config use-context $Context
}

function kcns {
    param([string]$Namespace)
    kubectl config set-context --current --namespace=$Namespace
}

function klist {
    kubectl config get-contexts
}

# 提示当前上下文
Write-Host "Kubernetes 多集群配置已加载" -ForegroundColor Green
Write-Host "可用上下文:" -ForegroundColor Yellow
kubectl config get-contexts
```

#### 步骤 4：重新加载配置

```powershell
# 方法 1：关闭并重新打开 PowerShell
# 方法 2：重新加载配置文件
. $PROFILE
```

#### 步骤 5：验证配置

```powershell
# 查看所有上下文
kubectl config get-contexts

# 查看当前上下文
kubectl config current-context

# 切换到开发集群
kubectl config use-context dev.kubernetes.cluster

# 切换到生产集群
kubectl config use-context prod.kubernetes.cluster
```

### 使用示例

```powershell
# 查看集群状态
kubectl get nodes

# 查看所有命名空间
kubectl get ns

# 切换上下文
kctx dev.kubernetes.cluster

# 查看部署
kubectl get deployments -A
```

### Terraform 集成

```powershell
# Terraform 会自动读取 KUBECONFIG 环境变量
cd environments/dev
terraform plan
terraform apply

cd ..\prod
terraform plan
terraform apply
```

---

## 方案二：Git Bash 环境变量

### 适用场景
- 你已经在使用 Git Bash
- 偏好类 Unix 环境
- 需要与 Linux 脚本兼容

### 设置步骤

#### 步骤 1：准备 kubeconfig 文件

```bash
# 在 Git Bash 中执行
mkdir -p ~/.kube
cp dev-kubeconfig.yaml ~/.kube/config-dev
cp prod-kubeconfig.yaml ~/.kube/config-prod
```

#### 步骤 2：编辑 Git Bash 配置文件

```bash
# 编辑 ~/.bashrc 或 ~/.bash_profile
notepad ~/.bashrc
```

添加以下内容：

```bash
# Kubernetes 多集群配置
export KUBECONFIG="$HOME/.kube/config-dev:$HOME/.kube/config-prod"

# 快捷函数
alias klist='kubectl config get-contexts'
alias kctx='kubectl config use-context'

# 提示当前上下文
echo "Kubernetes 多集群配置已加载"
kubectl config get-contexts
```

#### 步骤 3：重新加载配置

```bash
# 重新加载配置
source ~/.bashrc

# 或关闭并重新打开 Git Bash
```

---

## 方案三：独立 kubeconfig 文件（最简单）

### 为什么推荐？
- 完全隔离，不会相互干扰
- 无需配置环境变量
- Terraform 部署最安全
- 适合 CI/CD 环境

### 设置步骤

#### 步骤 1：准备独立的 kubeconfig 文件

```powershell
# 创建目录
New-Item -ItemType Directory -Force -Path $env:USERPROFILE\.kube

# 复制配置文件
Copy-Item "dev-kubeconfig.yaml" "$env:USERPROFILE\.kube\dev-config"
Copy-Item "prod-kubeconfig.yaml" "$env:USERPROFILE\.kube\prod-config"
```

#### 步骤 2：验证配置

```powershell
# 测试开发集群
$env:KUBECONFIG = "$env:USERPROFILE\.kube\dev-config"
kubectl get nodes

# 测试生产集群
$env:KUBECONFIG = "$env:USERPROFILE\.kube\prod-config"
kubectl get nodes
```

#### 步骤 3：在 Terraform 中使用

编辑 `environments/dev/terraform.tfvars`:

```hcl
kubeconfig_path = "C:/Users/你的用户名/.kube/dev-config"
config_context  = "dev.kubernetes.cluster"
```

编辑 `environments/prod/terraform.tfvars`:

```hcl
kubeconfig_path = "C:/Users/你的用户名/.kube/prod-config"
config_context  = "prod.kubernetes.cluster"
```

### 部署命令

```powershell
# 开发环境
cd environments/dev
terraform plan -var="kubeconfig_path=C:/Users/你的用户名/.kube/dev-config"
terraform apply -var="kubeconfig_path=C:/Users/你的用户名/.kube/dev-config"

# 生产环境
cd environments/prod
terraform plan -var="kubeconfig_path=C:/Users/你的用户名/.kube/prod-config"
terraform apply -var="kubeconfig_path=C:/Users/你的用户名/.kube/prod-config"
```

### 创建快捷脚本

创建 `scripts/deploy-dev.ps1`:

```powershell
param(
    [string]$Action = "apply"
)

$env:KUBECONFIG = "$env:USERPROFILE\.kube\dev-config"

if ($Action -eq "plan") {
    terraform plan
} else {
    terraform apply
}
```

创建 `scripts/deploy-prod.ps1`:

```powershell
param(
    [string]$Action = "apply"
)

$env:KUBECONFIG = "$env:USERPROFILE\.kube\prod-config"

if ($Action -eq "plan") {
    terraform plan
} else {
    terraform apply
}
```

使用：

```powershell
# 开发环境
.\scripts\deploy-dev.ps1 -Action plan
.\scripts\deploy-dev.ps1 -Action apply

# 生产环境
.\scripts\deploy-prod.ps1 -Action plan
.\scripts\deploy-prod.ps1 -Action apply
```

---

## 方案四：使用配置文件路径（简化版）

### 步骤 1：准备配置文件

```powershell
# 放在项目目录中
Copy-Item "dev-kubeconfig.yaml" "d:\文档\GitHub\kubernetes-terraform\config\dev-config"
Copy-Item "prod-kubeconfig.yaml" "d:\文档\GitHub\kubernetes-terraform\config\prod-config"
```

### 步骤 2：更新 Terraform 变量

编辑 `environments/dev/terraform.tfvars`:

```hcl
kubeconfig_path = "d:/文档/GitHub/kubernetes-terraform/config/dev-config"
config_context  = "dev.kubernetes.cluster"
```

编辑 `environments/prod/terraform.tfvars`:

```hcl
kubeconfig_path = "d:/文档/GitHub/kubernetes-terraform/config/prod-config"
config_context  = "prod.kubernetes.cluster"
```

### 步骤 3：部署

```powershell
# 开发环境
cd environments/dev
terraform plan
terraform apply

# 生产环境
cd ../prod
terraform plan
terraform apply
```

---

## 🎯 终极推荐：混合方案

### 对于日常开发使用 kubectl

使用 **PowerShell 配置文件**（方案一）：

```powershell
# 在 $PROFILE 中添加
$env:KUBECONFIG = "$env:USERPROFILE\.kube\config-dev;$env:USERPROFILE\.kube\config-prod"
```

### 对于 Terraform 部署

使用 **独立 kubeconfig 文件**（方案三）：

在 `terraform.tfvars` 中明确指定：
```hcl
kubeconfig_path = "d:/文档/GitHub/kubernetes-terraform/config/dev-config"
```

### 优势
- 日常使用 kubectl 时，可以轻松切换上下文
- Terraform 部署时，使用固定配置，避免误操作
- 完全隔离，互不影响

---

## Windows PowerShell 实用函数

### 创建完整的 PowerShell 配置文件

```powershell
# ============================================================================
# Kubernetes & Terraform 多集群管理配置
# ============================================================================

# === 基础配置 ===
$env:KUBECONFIG = "$env:USERPROFILE\.kube\config-dev;$env:USERPROFILE\.kube\config-prod"

# === 快捷函数 ===

# 列出所有上下文
function klist {
    kubectl config get-contexts
}

# 切换上下文
function kctx {
    param([string]$Context)
    kubectl config use-context $Context
}

# 切换命名空间
function kcns {
    param([string]$Namespace)
    kubectl config set-context --current --namespace=$Namespace
}

# 显示当前上下文
function kcurrent {
    $ctx = kubectl config current-context
    $ns = kubectl config view --minify -o jsonpath='{..namespace}'
    Write-Host "Context: $ctx" -ForegroundColor Green
    Write-Host "Namespace: $ns" -ForegroundColor Yellow
}

# 列出所有命名空间
function kns {
    kubectl get namespaces
}

# 列出所有 Pod（所有命名空间）
function kp {
    kubectl get pods -A
}

# 列出所有部署
function kd {
    kubectl get deployments -A
}

# 列出所有服务
function ks {
    kubectl get services -A
}

# 查看日志
function klog {
    param(
        [string]$Pod,
        [string]$Namespace = "default",
        [int]$Tail = 100
    )
    kubectl logs -n $Namespace $Pod --tail=$Tail -f
}

# 进入 Pod
function kexec {
    param(
        [string]$Pod,
        [string]$Namespace = "default",
        [string]$Shell = "/bin/bash"
    )
    kubectl exec -it -n $Namespace $Pod -- $Shell
}

# === Terraform 快捷函数 ===

# 开发环境部署
function tf-dev {
    param([string]$Action = "apply")
    $env:KUBECONFIG = "$env:USERPROFILE\.kube\dev-config"
    Push-Location "d:\文档\GitHub\kubernetes-terraform\environments\dev"

    if ($Action -eq "plan") {
        terraform plan
    } elseif ($Action -eq "init") {
        terraform init
    } elseif ($Action -eq "destroy") {
        terraform destroy
    } else {
        terraform apply
    }

    Pop-Location
}

# 生产环境部署
function tf-prod {
    param([string]$Action = "apply")
    $env:KUBECONFIG = "$env:USERPROFILE\.kube\prod-config"
    Push-Location "d:\文档\GitHub\kubernetes-terraform\environments\prod"

    if ($Action -eq "plan") {
        terraform plan
    } elseif ($Action -eq "init") {
        terraform init
    } elseif ($Action -eq "destroy") {
        terraform destroy
    } else {
        terraform apply
    }

    Pop-Location
}

# === 启动提示 ===
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Kubernetes & Terraform 环境已加载" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Kubernetes 命令:" -ForegroundColor Yellow
Write-Host "  klist           - 列出所有上下文" -ForegroundColor White
Write-Host "  kctx <name>     - 切换上下文" -ForegroundColor White
Write-Host "  kcns <name>     - 切换命名空间" -ForegroundColor White
Write-Host "  kcurrent        - 显示当前上下文" -ForegroundColor White
Write-Host "  kp              - 列出所有 Pod" -ForegroundColor White
Write-Host "  kd              - 列出所有部署" -ForegroundColor White
Write-Host "  ks              - 列出所有服务" -ForegroundColor White
Write-Host "  klog <pod>      - 查看日志" -ForegroundColor White
Write-Host "  kexec <pod>     - 进入 Pod" -ForegroundColor White
Write-Host ""
Write-Host "Terraform 命令:" -ForegroundColor Yellow
Write-Host "  tf-dev plan     - 开发环境规划" -ForegroundColor White
Write-Host "  tf-dev apply    - 开发环境部署" -ForegroundColor White
Write-Host "  tf-prod plan    - 生产环境规划" -ForegroundColor White
Write-Host "  tf-prod apply   - 生产环境部署" -ForegroundColor White
Write-Host ""
Write-Host "当前上下文:" -ForegroundColor Yellow
kubectl config get-contexts | Select-Object -First 5
Write-Host ""
```

### 使用示例

```powershell
# Kubernetes 操作
klist                    # 列出所有上下文
kctx dev.kubernetes.cluster    # 切换到开发集群
kcurrent                 # 显示当前上下文
kp                       # 列出所有 Pod
klog my-pod              # 查看 Pod 日志

# Terraform 部署
tf-dev plan              # 规划开发环境
tf-dev apply             # 部署开发环境
tf-prod plan             # 规划生产环境
tf-prod apply            # 部署生产环境
```

---

## Windows 路径注意事项

### 路径格式

Windows 下路径可以有以下写法：

```powershell
# 正斜杠（推荐，兼容性好）
"d:/文档/GitHub/kubernetes-terraform/config/dev-config"

# 反斜杠（Windows 原生）
"d:\文档\GitHub\kubernetes-terraform\config\dev-config"

# 环境变量
"$env:USERPROFILE\.kube\dev-config"

# 相对路径（在项目根目录）
"config/dev-config"
```

### 在 Terraform 中使用

```hcl
# 推荐使用正斜杠（跨平台兼容）
variable "kubeconfig_path" {
  default = "C:/Users/你的用户名/.kube/dev-config"
}

# 或者使用环境变量
variable "kubeconfig_path" {
  default = pathexpand("~/.kube/dev-config")
}
```

---

## 故障排除

### 问题 1：PowerShell 配置文件不生效

```powershell
# 检查执行策略
Get-ExecutionPolicy

# 如果是 Restricted，需要更改
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# 重新加载配置
. $PROFILE
```

### 问题 2：kubectl 找不到

```powershell
# 检查是否安装了 kubectl
kubectl version --client

# 如果未安装，使用以下命令安装：
# 方法 1: 使用 Chocolatey
choco install kubernetes-cli

# 方法 2: 使用 Scoop
scoop install kubectl

# 方法 3: 手动下载
# https://kubernetes.io/docs/tasks/tools/
```

### 问题 3：Terraform 无法找到 kubeconfig

```powershell
# 检查环境变量
$env:KUBECONFIG

# 检查文件是否存在
Test-Path $env:KUBECONFIG.Split(';')

# 临时设置
$env:KUBECONFIG = "C:/Users/你的用户名/.kube/dev-config"
terraform plan
```

---

## 总结

### 最佳实践

1. **日常开发**：使用 PowerShell 配置文件 + KUBECONFIG 环境变量
2. **Terraform 部署**：在 terraform.tfvars 中明确指定 kubeconfig 路径
3. **安全考虑**：生产环境使用独立配置文件，避免误操作
4. **团队协作**：将配置文件放在项目目录，使用版本控制

### 快速开始

```powershell
# 1. 准备配置文件
Copy-Item "dev-kubeconfig.yaml" "$env:USERPROFILE\.kube\dev-config"
Copy-Item "prod-kubeconfig.yaml" "$env:USERPROFILE\.kube\prod-config"

# 2. 编辑 PowerShell 配置
notepad $PROFILE

# 3. 添加配置
$env:KUBECONFIG = "$env:USERPROFILE\.kube\dev-config;$env:USERPROFILE\.kube\prod-config"

# 4. 重新加载
. $PROFILE

# 5. 验证
kubectl config get-contexts
```

### 推荐指数

| 场景 | 推荐方案 | 理由 |
|------|---------|------|
| **日常使用 kubectl** | ⭐⭐⭐⭐⭐ 方案一 | 原生支持，配置简单 |
| **Terraform 部署** | ⭐⭐⭐⭐⭐ 方案三 | 完全隔离，最安全 |
| **新手用户** | ⭐⭐⭐⭐ 方案三 | 步骤最少，不易出错 |
| **高级用户** | ⭐⭐⭐⭐⭐ 方案一 | 功能强大，可扩展 |
