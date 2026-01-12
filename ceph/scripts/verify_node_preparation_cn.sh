#!/bin/bash
set +e  # 关闭严格模式，避免与函数返回值冲突

# Ubuntu 节点准备验证脚本用于 Ceph 部署
# 此脚本验证重启后所有节点准备是否成功应用
# 在每次节点重启后运行此脚本：master, node1, node2

# set -e  # 临时注释掉，以避免与函数返回值的冲突

# 输出颜色
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # 无颜色

echo -e "${GREEN}开始重启后的 Ubuntu 节点准备验证${NC}"

# 打印状态消息的函数
print_status() {
    echo -e "${GREEN}[信息]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[警告]${NC} $1"
}

print_error() {
    echo -e "${RED}[错误]${NC} $1"
}

# 检查是否以 root 身份运行
# 使用更兼容的方式检查是否为 root 用户
uid=$(id -u 2>/dev/null || echo "0")
if [ "$uid" -eq 0 ]; then
    print_warning "此脚本不应以 root 身份运行。请以具有 sudo 权限的用户身份运行。"
    exit 1
fi

# 检查是否运行在 Ubuntu 上
if ! grep -q "Ubuntu" /etc/os-release; then
    print_error "此脚本仅适用于 Ubuntu 系统。"
    exit 1
fi

# 验证内核模块的函数
verify_kernel_modules() {
    print_status "正在验证内核模块..."
    
    # 使用简单的变量来代替数组，以便兼容性更好
    if lsmod | grep -q "rbd"; then
        print_status "✓ 模块 rbd 已加载"
        rbd_loaded=1
    else
        print_error "✗ 模块 rbd 未加载"
        rbd_loaded=0
    fi
    
    if lsmod | grep -q "ceph"; then
        print_status "✓ 模块 ceph 已加载"
        ceph_loaded=1
    else
        print_error "✗ 模块 ceph 未加载"
        ceph_loaded=0
    fi
    
    if lsmod | grep -q "nbd"; then
        print_status "✓ 模块 nbd 已加载"
        nbd_loaded=1
    else
        print_error "✗ 模块 nbd 未加载"
        nbd_loaded=0
    fi
    
    # 检查模块是否配置为持久化
    if [ -f "/etc/modules-load.d/ceph.conf" ]; then
        if grep -q "rbd" "/etc/modules-load.d/ceph.conf"; then
            print_status "✓ 模块 rbd 已配置为持久化"
            rbd_persistent=1
        else
            print_error "✗ 模块 rbd 未配置为持久化"
            rbd_persistent=0
        fi
        
        if grep -q "ceph" "/etc/modules-load.d/ceph.conf"; then
            print_status "✓ 模块 ceph 已配置为持久化"
            ceph_persistent=1
        else
            print_error "✗ 模块 ceph 未配置为持久化"
            ceph_persistent=0
        fi
        
        if grep -q "nbd" "/etc/modules-load.d/ceph.conf"; then
            print_status "✓ 模块 nbd 已配置为持久化"
            nbd_persistent=1
        else
            print_error "✗ 模块 nbd 未配置为持久化"
            nbd_persistent=0
        fi
    else
        print_error "✗ 文件 /etc/modules-load.d/ceph.conf 不存在"
        rbd_persistent=0
        ceph_persistent=0
        nbd_persistent=0
    fi
    
    # 检查所有模块是否都已加载和持久化
    if [ $rbd_loaded -eq 1 ] && [ $ceph_loaded -eq 1 ] && [ $nbd_loaded -eq 1 ] && \
       [ $rbd_persistent -eq 1 ] && [ $ceph_persistent -eq 1 ] && [ $nbd_persistent -eq 1 ]; then
        print_status "✓ 所有内核模块验证成功"
        # 设置全局状态变量
        kernel_modules_ok=1
    else
        print_error "✗ 某些内核模块未正确配置"
        kernel_modules_ok=0
    fi
}


# 验证内核参数的函数
verify_kernel_params() {
    print_status "正在验证内核参数..."
    
    local success=0
    PARAMS_FILE="/etc/sysctl.d/99-ceph.conf"
    if [ ! -f "$PARAMS_FILE" ]; then
        print_error "✗ 内核参数文件 $PARAMS_FILE 不存在"
        return 1
    fi
    
    # 检查特定参数
    if sysctl net.core.rmem_max | grep -q "134217728"; then
        print_status "✓ net.core.rmem_max 设置正确"
    else
        print_error "✗ net.core.rmem_max 设置不正确"
        success=1
    fi
    
    if sysctl net.core.wmem_max | grep -q "134217728"; then
        print_status "✓ net.core.wmem_max 设置正确"
    else
        print_error "✗ net.core.wmem_max 设置不正确"
        success=1
    fi
    
    if sysctl fs.file-max | grep -q "10000000"; then
        print_status "✓ fs.file-max 设置正确"
    else
        print_error "✗ fs.file-max 设置不正确"
        success=1
    fi
    
    print_status "✓ 内核参数验证完成"
    
    # 如果有任何错误，则返回错误码
    if [ $success -eq 1 ]; then
        return 1
    fi
}

# 验证存储磁盘的函数
verify_storage_disk() {
    local disk="/dev/sdb"
    
    print_status "正在验证存储磁盘 $disk..."
    
    # 检查磁盘是否存在
    if [ ! -b "$disk" ]; then
        print_error "✗ 磁盘 $disk 不存在"
        return 1
    fi
    
    # 检查磁盘大小（应至少为 100GB）
    DISK_SIZE=$(lsblk -b -o SIZE $disk | grep -v SIZE | awk '{print int($1/1024/1024/1024)}')
    if [ "$DISK_SIZE" -lt 100 ]; then
        print_warning "磁盘 $disk 大小为 ${DISK_SIZE}GB，小于推荐的 100GB。"
    else
        print_status "✓ 磁盘 $disk 找到，大小为 ${DISK_SIZE}GB"
    fi
    
    # 检查磁盘是否有已挂载的分区（准备后应该没有）
    MOUNTED_PARTITIONS=$(lsblk -r -o NAME,MOUNTPOINT $disk | grep -v NAME | grep -v "^sdb$ ")
    if [ -n "$MOUNTED_PARTITIONS" ]; then
        print_warning "磁盘 $disk 有已挂载的分区。这可能是意外的。"
        echo "$MOUNTED_PARTITIONS" | while read -r line; do
            PARTITION=$(echo "$line" | awk '{print $1}')
            MOUNTPOINT=$(echo "$line" | awk '{print $2}')
            if [ -n "$MOUNTPOINT" ] && [ "$MOUNTPOINT" != "" ]; then
                print_warning "分区 $PARTITION 挂载在 $MOUNTPOINT"
            fi
        done
    else
        print_status "✓ 磁盘 $disk 没有已挂载的分区（准备后预期）"
    fi
    
    print_status "✓ 存储磁盘验证完成"
    return 0
}

# 验证交换分区已禁用的函数
verify_swap_disabled() {
    print_status "正在验证交换分区已禁用..."
    
    # 检查交换是否激活
    SWAP_ACTIVE=$(swapon --show | wc -l)
    if [ "$SWAP_ACTIVE" -le 1 ]; then  # 1 行只是标题
        print_status "✓ 交换已禁用（无活动交换）"
    else
        print_warning "交换仍处于活动状态："
        swapon --show
    fi
    
    # 检查交换是否在 fstab 中被注释掉
    if grep -qE "^[^#].*swap" /etc/fstab; then
        print_warning "在 /etc/fstab 中找到交换条目（未注释）"
    else
        print_status "✓ 交换在 /etc/fstab 中被注释掉"
    fi
    
    print_status "✓ 交换验证完成"
}

# 验证已安装工具的函数
verify_installed_tools() {
    print_status "正在验证已安装的工具..."
    
    TOOLS=("smartmontools" "sysfsutils" "nvme-cli" "lshw" "lsscsi" "mdadm" "jq" "curl" "wget" "net-tools" "dnsutils")
    
    for tool in "${TOOLS[@]}"; do
        if command -v "$tool" &> /dev/null; then
            print_status "✓ $tool 已安装"
        else
            # 对于某些工具，命令名与包名不同
            case $tool in
                "smartmontools")
                    if command -v smartctl &> /dev/null; then
                        print_status "✓ smartmontools 已安装（smartctl 命令可用）"
                    else
                        print_warning "$tool 未安装"
                    fi
                    ;;
                "net-tools")
                    if command -v netstat &> /dev/null; then
                        print_status "✓ net-tools 已安装（netstat 命令可用）"
                    else
                        print_warning "$tool 未安装"
                    fi
                    ;;
                "dnsutils")
                    if command -v nslookup &> /dev/null; then
                        print_status "✓ dnsutils 已安装（nslookup 命令可用）"
                    else
                        print_warning "$tool 未安装"
                    fi
                    ;;
                *)
                    print_warning "$tool 未安装"
                    ;;
            esac
        fi
    done
    
    # 单独检查时间同步工具
    if command -v ntpd &> /dev/null || command -v chronyd &> /dev/null; then
        print_status "✓ 时间同步工具可用（ntp 或 chrony）"
    else
        print_warning "似乎未安装 ntp 或 chrony"
    fi
    
    print_status "✓ 工具验证完成"
}

# 验证防火墙的函数
verify_firewall() {
    print_status "正在验证防火墙设置..."
    
    # 检查 ufw 是否已安装并已禁用
    if command -v ufw &> /dev/null; then
        if ufw status | grep -q "inactive"; then
            print_status "✓ UFW 防火墙已安装且处于非活动状态"
        else
            print_warning "UFW 防火墙已启用，对于 Ceph 集群这可能会有问题"
        fi
    else
        print_status "✓ UFW 防火墙未安装或不可用"
    fi
    
    # 检查 iptables 规则（可选）
    if command -v iptables &> /dev/null; then
        print_status "✓ iptables 可用"
    fi
    
    print_status "✓ 防火墙验证完成"
}

# 验证容器运行时的函数
verify_container_runtime() {
    print_status "正在验证容器运行时..."
    
    # 检查 Docker
    if command -v docker &> /dev/null; then
        DOCKER_VERSION=$(docker --version 2>/dev/null || echo "未知")
        print_status "✓ Docker 已安装: $DOCKER_VERSION"
    elif command -v podman &> /dev/null; then
        PODMAN_VERSION=$(podman --version 2>/dev/null || echo "未知")
        print_status "✓ Podman 已安装: $PODMAN_VERSION"
    elif command -v containerd &> /dev/null; then
        CONTAINERD_VERSION=$(containerd --version 2>/dev/null || echo "未知")
        print_status "✓ Containerd 已安装: $CONTAINERD_VERSION"
    else
        print_warning "未找到容器运行时（Docker、Podman 或 Containerd）"
    fi
    
    print_status "✓ 容器运行时验证完成"
}

# 运行所有验证的函数
run_verification() {
    print_status "开始综合验证..."
    
    local errors=0
    
    verify_kernel_modules
    if [ ${kernel_modules_ok:-0} -eq 1 ]; then
        print_status "✓ 内核模块验证通过"
    else
        print_error "✗ 内核模块验证失败"
        errors=$((errors + 1))
    fi
    
    verify_kernel_params
    if [ $? -eq 0 ]; then
        print_status "✓ 内核参数验证通过"
    else
        print_error "✗ 内核参数验证失败"
        errors=$((errors + 1))
    fi
    
    verify_storage_disk
    if [ $? -eq 0 ]; then
        print_status "✓ 存储磁盘验证通过"
    else
        print_error "✗ 存储磁盘验证失败"
        errors=$((errors + 1))
    fi
    
    verify_swap_disabled
    if [ $? -eq 0 ]; then
        print_status "✓ 交换验证通过"
    else
        print_error "✗ 交换验证失败"
        errors=$((errors + 1))
    fi
    
    verify_firewall
    if [ $? -eq 0 ]; then
        print_status "✓ 防火墙验证通过"
    else
        print_error "✗ 防火墙验证失败"
        errors=$((errors + 1))
    fi
    
    verify_installed_tools
    if [ $? -eq 0 ]; then
        print_status "✓ 工具验证通过"
    else
        print_error "✗ 工具验证失败"
        errors=$((errors + 1))
    fi
    
    verify_container_runtime
    if [ $? -eq 0 ]; then
        print_status "✓ 容器运行时验证通过"
    else
        print_error "✗ 容器运行时验证失败"
        errors=$((errors + 1))
    fi
    
    echo
    if [ $errors -eq 0 ]; then
        print_status "🎉 所有验证通过！节点已准备好进行 Ceph 部署。"
        echo "现在可以继续进行 Terraform Ceph 部署。"
        return 0
    else
        print_error "❌ $errors 个验证失败。请查看上面的错误。"
        print_status "修复问题后，重新运行此验证脚本。"
        return 1
    fi
}


# 主执行函数
main() {
    print_status "开始重启后的节点准备验证..."
    echo
    
    run_verification
    return $?
}

# 确认提示
echo -e "${YELLOW}此脚本将验证重启后所有节点准备是否正确应用。${NC}"
read -p "您要继续吗？(yes/no): " REPLY
echo

if echo "$REPLY" | grep -iq "^y"; then
    main "$@"
    exit_code=$?
    exit $exit_code
else
    print_status "操作被用户取消。"
    exit 0
fi