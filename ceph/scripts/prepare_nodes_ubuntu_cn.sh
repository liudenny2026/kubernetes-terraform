#!/bin/bash

# Ubuntu 节点准备脚本用于 Ceph 部署
# 此脚本自动化 Ubuntu 节点的准备工作，用于 Ceph 部署
# 在每个节点上运行此脚本：master, node1, node2 (或替换为您实际的节点名称)

set -e  # 如果命令退出状态非零则立即退出

# 输出颜色
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # 无颜色

echo -e "${GREEN}开始 Ubuntu 节点为 Ceph 部署的准备工作${NC}"

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
if [ $EUID -eq 0 ]; then
    print_warning "此脚本不应以 root 身份运行。请以具有 sudo 权限的用户身份运行。"
    exit 1
fi

# 检查是否运行在 Ubuntu 上
if ! grep -q "Ubuntu" /etc/os-release; then
    print_error "此脚本仅适用于 Ubuntu 系统。"
    exit 1
fi

# 检查内核版本
KERNEL_VERSION=$(uname -r | cut -d'-' -f1)
REQUIRED_KERNEL="4.17"
if dpkg --compare-versions "$KERNEL_VERSION" lt "$REQUIRED_KERNEL"; then
    print_warning "内核版本 $KERNEL_VERSION 低于要求的 $REQUIRED_KERNEL。请考虑升级。"
fi

print_status "内核版本检查通过: $KERNEL_VERSION"

# 加载内核模块的函数
load_kernel_modules() {
    print_status "正在加载必需的内核模块..."
    
    sudo modprobe rbd
    sudo modprobe ceph
    sudo modprobe nbd
    
    # 使模块在重启后仍然加载
    echo "rbd" | sudo tee -a /etc/modules-load.d/ceph.conf
    echo "ceph" | sudo tee -a /etc/modules-load.d/ceph.conf
    echo "nbd" | sudo tee -a /etc/modules-load.d/ceph.conf
    
    print_status "内核模块已加载并配置为持久化"
}

# 调优内核参数的函数
tune_kernel_params() {
    print_status "正在为 Ceph 调优内核参数..."
    
    # 创建 sysctl 配置文件
    cat << EOF | sudo tee /etc/sysctl.d/99-ceph.conf
net.core.rmem_max = 134217728
net.core.wmem_max = 134217728
net.ipv4.tcp_rmem = 4096 87380 134217728
net.ipv4.tcp_wmem = 4096 65536 134217728
fs.file-max = 10000000
EOF

    # 应用更改
    sudo sysctl -p /etc/sysctl.d/99-ceph.conf
    
    print_status "内核参数已调优"
}

# 准备存储磁盘的函数
prepare_storage_disk() {
    local disk="/dev/sdb"
    
    print_status "正在准备存储磁盘 $disk..."
    
    # 检查磁盘是否存在
    if [ ! -b "$disk" ]; then
        print_error "磁盘 $disk 不存在。请确认磁盘可用。"
        exit 1
    fi
    
    # 检查磁盘大小（应至少为 100GB）
    DISK_SIZE=$(lsblk -b -o SIZE $disk | grep -v SIZE | awk '{print int($1/1024/1024/1024)}')
    if [ "$DISK_SIZE" -lt 100 ]; then
        print_error "磁盘 $disk 大小为 ${DISK_SIZE}GB，小于要求的 100GB。"
        exit 1
    fi
    
    print_status "找到磁盘 $disk，大小为 ${DISK_SIZE}GB"
    
    # 检查磁盘是否有已挂载的分区
    MOUNTED_PARTITIONS=$(lsblk -r -o NAME,MOUNTPOINT $disk | grep -v NAME | grep -v "^sdb$ ")
    if [ -n "$MOUNTED_PARTITIONS" ]; then
        print_warning "磁盘 $disk 有已挂载的分区。它们将被卸载。"
        echo "$MOUNTED_PARTITIONS" | while read -r line; do
            PARTITION=$(echo "$line" | awk '{print $1}')
            MOUNTPOINT=$(echo "$line" | awk '{print $2}')
            if [ -n "$MOUNTPOINT" ] && [ "$MOUNTPOINT" != "" ]; then
                print_status "正在从 $MOUNTPOINT 卸载 $PARTITION"
                sudo umount "/dev/$PARTITION" || true
            fi
        done
    fi
    
    # 清除分区表
    print_status "正在清除 $disk 上的分区表..."
    sudo dd if=/dev/zero of=$disk bs=1M count=100 oflag=direct,dsync
    
    # 清除 SCSI 预订
    if command -v sgdisk &> /dev/null; then
        print_status "正在清除 $disk 上的 SCSI 预订..."
        sudo sgdisk --zap-all $disk
    else
        print_warning "未找到 sgdisk。跳过 SCSI 预订清除。"
    fi
    
    # 擦除文件系统
    print_status "正在擦除 $disk 上的文件系统..."
    sudo wipefs -a $disk || true
    
    print_status "存储磁盘 $disk 准备成功"
}

# 禁用交换分区的函数
disable_swap() {
    print_status "正在禁用交换分区..."
    
    # 临时禁用交换分区
    sudo swapoff -a
    
    # 通过注释 /etc/fstab 中的内容永久禁用交换分区
    sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
    
    print_status "交换分区已禁用"
}

# 配置防火墙的函数
configure_firewall() {
    print_status "正在为 Ceph 配置防火墙..."
    
    # 检查是否安装了 ufw
    if ! command -v ufw &> /dev/null; then
        print_status "正在安装 ufw 防火墙..."
        sudo apt update
        sudo apt install -y ufw
    fi
    
    # 如果尚未启用，则启用防火墙
    if ! sudo ufw status | grep -q "Status: active"; then
        print_status "正在启用防火墙..."
        echo "y" | sudo ufw enable
    fi
    
    # 允许所需端口
    sudo ufw allow 6789/tcp  # Ceph 监控器
    sudo ufw allow 6800:7300/tcp  # Ceph OSD 和元数据服务器
    
    print_status "防火墙已为 Ceph 配置"
}

# 检查容器运行时的函数
check_container_runtime() {
    print_status "正在检查容器运行时..."
    
    # 检查 Docker
    if command -v docker &> /dev/null; then
        DOCKER_VERSION=$(docker --version | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')
        print_status "找到 Docker: $DOCKER_VERSION"
        
        # 检查版本是否足够（18.09+）
        if dpkg --compare-versions "$DOCKER_VERSION" ge "18.09"; then
            print_status "Docker 版本充足"
        else
            print_warning "Docker 版本 $DOCKER_VERSION 低于推荐的 18.09"
        fi
    # 检查 containerd
    elif command -v containerd &> /dev/null; then
        CONTAINERD_VERSION=$(containerd --version | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')
        print_status "找到 Containerd: $CONTAINERD_VERSION"
        
        # 检查版本是否足够（1.2.5+）
        if dpkg --compare-versions "$CONTAINERD_VERSION" ge "1.2.5"; then
            print_status "Containerd 版本充足"
        else
            print_warning "Containerd 版本 $CONTAINERD_VERSION 低于推荐的 1.2.5"
        fi
    else
        print_warning "未找到容器运行时。请安装 Docker 或 containerd。"
    fi
}

# 安装附加工具的函数
install_tools() {
    print_status "正在安装附加工具..."
    
    # 更新包列表
    sudo apt update
    
    # 安装所需工具
    sudo apt install -y \
        smartmontools \
        sysfsutils \
        nvme-cli \
        lshw \
        lsscsi \
        mdadm \
        jq \
        curl \
        wget \
        net-tools \
        dnsutils
    
    # 尝试安装时间同步工具，处理可能的依赖冲突
    if ! sudo apt install -y ntp 2>/dev/null; then
        print_warning "无法安装 ntp，可能存在依赖冲突。跳过 ntp 安装。"
    fi
    
    if ! sudo apt install -y chrony 2>/dev/null; then
        print_warning "无法安装 chrony，可能存在依赖冲突。跳过 chrony 安装。"
    fi
    
    print_status "附加工具已安装"
}

# 验证准备工作的函数
verify_preparation() {
    print_status "正在验证节点准备工作..."
    
    # 验证内核模块已加载
    if lsmod | grep -E "(rbd|ceph|nbd)" > /dev/null; then
        print_status "✓ 内核模块已加载"
    else
        print_error "✗ 内核模块未加载"
        return 1
    fi
    
    # 验证磁盘可用
    if [ -b "/dev/sdb" ]; then
        print_status "✓ 磁盘 /dev/sdb 可用"
    else
        print_error "✗ 磁盘 /dev/sdb 不可用"
        return 1
    fi
    
    # 验证防火墙配置
    if sudo ufw status | grep -E "6789|6800:7300" > /dev/null; then
        print_status "✓ 防火墙已为 Ceph 配置"
    else
        print_error "✗ 防火墙未为 Ceph 配置"
        return 1
    fi
    
    print_status "节点准备验证成功完成"
}

# 主执行函数
main() {
    print_status "开始节点准备过程..."
    
    # 加载内核模块
    load_kernel_modules
    
    # 调优内核参数
    tune_kernel_params
    
    # 准备存储磁盘
    prepare_storage_disk
    
    # 禁用交换分区
    disable_swap
    
    # 配置防火墙
    configure_firewall
    
    # 安装附加工具
    install_tools
    
    # 检查容器运行时
    check_container_runtime
    
    # 验证准备
    verify_preparation
    
    print_status "节点准备工作成功完成！"
    print_status "请重新启动系统以应用所有更改："
    echo "sudo reboot"
    
    print_status "重启后，使用以下命令验证设置："
    echo "lsmod | grep -E '(rbd|ceph|nbd)'"
    echo "lsblk | grep sdb"
    echo "sudo ufw status"
}

# 确认提示
echo -e "${YELLOW}此脚本将为此 Ubuntu 节点准备 Ceph 部署。${NC}"
echo -e "${YELLOW}它将对系统配置进行更改并清除 /dev/sdb 上的数据。${NC}"
echo -e "${YELLOW}请确保您已备份 /dev/sdb 上的任何重要数据。${NC}"
echo -n "您要继续吗？(yes/no): "
read REPLY
echo

if echo "$REPLY" | grep -iq "^y"; then
    main "$@"
else
    print_status "操作被用户取消。"
    exit 0
fi