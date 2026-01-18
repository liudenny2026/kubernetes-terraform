# ============================================================================
# Windows PowerShell 快速设置脚本（已配置环境）
# ============================================================================
# 功能：设置 PowerShell 环境变量，方便日常使用 kubectl
# ============================================================================

$ErrorActionPreference = "Stop"

# 项目路径
$projectRoot = "d:/文档/GitHub/kubernetes-terraform"
$configDir = "$projectRoot/config"
$devConfig = "$configDir/dev-config"
$prodConfig = "$configDir/prod-config"

# 颜色输出
function Write-ColorOutput {
    param([string]$Message, [string]$Color = "White")
    Write-Host $Message -ForegroundColor $Color
}

Write-ColorOutput "========================================" "Cyan"
Write-ColorOutput "Windows PowerShell 环境设置" "Green"
Write-ColorOutput "========================================" "Cyan"
Write-Host ""

# 检查配置文件
Write-ColorOutput "检查配置文件..." "Yellow"
if (Test-Path $devConfig) {
    Write-ColorOutput "✓ 开发配置: $devConfig" "Green"
} else {
    Write-ColorOutput "✗ 开发配置不存在: $devConfig" "Red"
    exit 1
}

if (Test-Path $prodConfig) {
    Write-ColorOutput "✓ 生产配置: $prodConfig" "Green"
} else {
    Write-ColorOutput "✗ 生产配置不存在: $prodConfig" "Red"
    exit 1
}
Write-Host ""

# 检查 kubectl
Write-ColorOutput "检查 kubectl..." "Yellow"
try {
    $kubectlVersion = kubectl version --client 2>&1
    Write-ColorOutput "✓ kubectl 已安装" "Green"
} catch {
    Write-ColorOutput "✗ kubectl 未安装" "Red"
    Write-Host "请先安装 kubectl: https://kubernetes.io/docs/tasks/tools/"
    exit 1
}
Write-Host ""

# 检查 PowerShell 配置文件
Write-ColorOutput "检查 PowerShell 配置文件..." "Yellow"
$profilePath = $PROFILE
Write-ColorOutput "配置文件路径: $profilePath" "Cyan"

if (-not (Test-Path $profilePath)) {
    New-Item -ItemType File -Path $profilePath -Force | Out-Null
    Write-ColorOutput "✓ 已创建 PowerShell 配置文件" "Green"
} else {
    Write-ColorOutput "✓ PowerShell 配置文件已存在" "Green"
}

# 检查是否已配置
$profileContent = Get-Content $profilePath -Raw
if ($profileContent -match "kubernetes-admin") {
    Write-ColorOutput "! 警告: 配置文件中已存在 Kubernetes 配置" "Yellow"
    $overwrite = Read-Host "是否覆盖现有配置? (y/N)"
    if ($overwrite -ne "y" -and $overwrite -ne "Y") {
        Write-ColorOutput "配置已取消" "Yellow"
        exit 0
    }
}
Write-Host ""

# 读取上下文名称
Write-ColorOutput "读取配置信息..." "Yellow"
$devContext = kubectl config view --kubeconfig=$devConfig -o jsonpath='{.contexts[0].name}'
$prodContext = kubectl config view --kubeconfig=$prodConfig -o jsonpath='{.contexts[0].name}'
Write-ColorOutput "开发上下文: $devContext" "Cyan"
Write-ColorOutput "生产上下文: $prodContext" "Cyan"
Write-Host ""

# 创建备份
if (Test-Path $profilePath) {
    $backupPath = "$profilePath.backup.$(Get-Date -Format 'yyyyMMdd-HHmmss')"
    Copy-Item $profilePath $backupPath
    Write-ColorOutput "✓ 已备份配置文件到: $backupPath" "Green"
    Write-Host ""
}

# 添加配置到 PowerShell 配置文件
Write-ColorOutput "更新 PowerShell 配置文件..." "Yellow"

$configScript = @"

# ============================================================================
# Kubernetes 多集群配置（自动生成）
# ============================================================================

# 开发环境快捷函数
function kdev {
    `$env:KUBECONFIG = "$devConfig"
    Write-Host "已切换到开发环境" -ForegroundColor Green
    Write-Host "上下文: $devContext" -ForegroundColor Yellow
}

# 生产环境快捷函数
function kprod {
    `$env:KUBECONFIG = "$prodConfig"
    Write-Host "已切换到生产环境" -ForegroundColor Green
    Write-Host "上下文: $prodContext" -ForegroundColor Yellow
}

# 查看当前环境
function kcurrent {
    Write-Host "当前 KUBECONFIG: `$env:KUBECONFIG" -ForegroundColor Yellow
    Write-Host "当前上下文: $(kubectl config current-context)" -ForegroundColor Green
    Write-Host "当前命名空间: $(kubectl config view --minify -o jsonpath='{..namespace}')" -ForegroundColor Cyan
}

# 列出所有 Pod
function kp { kubectl get pods -A }

# 列出所有部署
function kd { kubectl get deployments -A }

# 列出所有服务
function ks { kubectl get services -A }

# 列出所有命名空间
function kns { kubectl get namespaces }

# 查看节点
function knodes { kubectl get nodes -o wide }

# 查看日志
function klog {
    param([string]`$Pod, [string]`$Namespace = "default", [int]`$Tail = 100)
    kubectl logs -n `$Namespace `$Pod --tail=`$Tail -f
}

# 进入 Pod
function kexec {
    param([string]`$Pod, [string]`$Namespace = "default", [string]`$Shell = "/bin/bash")
    kubectl exec -it -n `$Namespace `$Pod -- `$Shell
}

# Terraform 快捷函数
function tf-dev {
    param([string]`$Action = "apply")
    kdev
    Push-Location "$projectRoot\environments\dev"

    if (`$Action -eq "plan") {
        terraform plan
    } elseif (`$Action -eq "init") {
        terraform init
    } elseif (`$Action -eq "destroy") {
        terraform destroy
    } else {
        terraform apply
    }

    Pop-Location
}

function tf-prod {
    param([string]`$Action = "apply")
    kprod
    Push-Location "$projectRoot\environments\prod"

    if (`$Action -eq "plan") {
        terraform plan
    } elseif (`$Action -eq "init") {
        terraform init
    } elseif (`$Action -eq "destroy") {
        terraform destroy
    } else {
        terraform apply
    }

    Pop-Location
}

Write-Host "Kubernetes 环境已加载" -ForegroundColor Green
Write-Host "  kdev          - 切换到开发环境" -ForegroundColor Cyan
Write-Host "  kprod         - 切换到生产环境" -ForegroundColor Cyan
Write-Host "  kcurrent      - 查看当前环境" -ForegroundColor Cyan
Write-Host "  tf-dev plan   - 开发环境规划" -ForegroundColor Cyan
Write-Host "  tf-dev apply  - 开发环境部署" -ForegroundColor Cyan
Write-Host "  tf-prod plan  - 生产环境规划" -ForegroundColor Cyan
Write-Host "  tf-prod apply - 生产环境部署" -ForegroundColor Cyan
"@

# 清理旧的 Kubernetes 配置
$profileContent = Get-Content $profilePath -Raw
if ($profileContent -match "kubernetes-admin") {
    # 移除旧的配置块
    $profileContent = $profileContent -replace "# =+.*?# =+[\s\S]*?Write-Host `".*`" -ForegroundColor Cyan`r?`n", ""
    Set-Content $profilePath $profileContent
}

# 添加新配置
Add-Content $profilePath $configScript
Write-ColorOutput "✓ 已更新 PowerShell 配置文件" "Green"
Write-Host ""

# 测试配置
Write-ColorOutput "测试配置..." "Yellow"
Write-Host ""

Write-ColorOutput "测试开发环境:" "Cyan"
kubectl --kubeconfig=$devConfig get nodes 2>&1 | Select-Object -First 5
Write-Host ""

Write-ColorOutput "测试生产环境:" "Cyan"
kubectl --kubeconfig=$prodConfig get nodes 2>&1 | Select-Object -First 5
Write-Host ""

# 重新加载配置
$reload = Read-Host "是否立即重新加载配置? (Y/n)"
if ($reload -ne "n" -and $reload -ne "N") {
    . $PROFILE
    Write-ColorOutput "✓ 配置已重新加载" "Green"
    Write-Host ""

    # 测试快捷函数
    Write-ColorOutput "测试快捷函数:" "Yellow"
    Write-Host "  kdev"
    kdev
    Write-Host "  kprod"
    kprod
}

Write-Host ""
Write-ColorOutput "========================================" "Cyan"
Write-ColorOutput "设置完成！" "Green"
Write-ColorOutput "========================================" "Cyan"
Write-Host ""
Write-ColorOutput "使用说明:" "Yellow"
Write-Host ""
Write-ColorOutput "日常使用 kubectl:" "Cyan"
Write-Host "  kdev            - 切换到开发环境"
Write-Host "  kprod           - 切换到生产环境"
Write-Host "  kcurrent        - 查看当前环境"
Write-Host "  kp              - 列出所有 Pod"
Write-Host "  kd              - 列出所有部署"
Write-Host "  ks              - 列出所有服务"
Write-Host "  klog <pod>      - 查看 Pod 日志"
Write-Host "  kexec <pod>     - 进入 Pod"
Write-Host ""
Write-ColorOutput "Terraform 部署:" "Cyan"
Write-Host "  tf-dev plan     - 开发环境规划"
Write-Host "  tf-dev apply    - 开发环境部署"
Write-Host "  tf-prod plan    - 生产环境规划"
Write-Host "  tf-prod apply   - 生产环境部署"
Write-Host ""
Write-ColorOutput "手动使用 Terraform:" "Cyan"
Write-Host "  cd environments\dev"
Write-Host "  terraform plan"
Write-Host "  terraform apply"
Write-Host ""
Write-Host "  cd ..\prod"
Write-Host "  terraform plan"
Write-Host "  terraform apply"
Write-Host ""

Write-ColorOutput "配置文件路径:" "Yellow"
Write-Host "  开发: $devConfig"
Write-Host "  生产: $prodConfig"
Write-Host ""

Write-ColorOutput "Terraform 变量文件:" "Yellow"
Write-Host "  开发: $projectRoot\environments\dev\terraform.tfvars"
Write-Host "  生产: $projectRoot\environments\prod\terraform.tfvars"
Write-Host ""
