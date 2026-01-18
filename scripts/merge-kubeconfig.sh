#!/bin/bash
# ============================================================================
# Kubeconfig 合并工具
# ============================================================================
# 功能：将多个 kubeconfig 文件合并到主配置文件
# 使用：./scripts/merge-kubeconfig.sh
# ============================================================================

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 配置
KUBE_DIR="${KUBE_DIR:-$HOME/.kube}"
MAIN_CONFIG="$KUBE_DIR/config"
BACKUP_DIR="$KUBE_DIR/backups"

# 创建备份目录
mkdir -p "$BACKUP_DIR"

# 帮助信息
usage() {
    cat << EOF
Kubeconfig 合并工具

用法:
    $(basename "$0") [options]

选项:
    -s, --source <files>    要合并的源文件（多个文件用逗号分隔）
    -o, --output <file>     输出文件（默认: ~/.kube/config）
    -b, --backup            在合并前备份当前配置
    -c, --check            仅检查配置，不执行合并
    -h, --help              显示帮助信息

示例:
    # 合并开发和生产配置
    $(basename "$0") -s ~/.kube/config-dev,~/.kube/config-prod

    # 合并并备份
    $(basename "$0") -s ~/.kube/config-dev,~/.kube/config-prod -b

    # 仅检查配置
    $(basename "$0") -s ~/.kube/config-dev,~/.kube/config-prod -c

    # 指定输出文件
    $(basename "$0") -s config-dev.yaml,config-prod.yaml -o merged-config.yaml

EOF
}

# 备份当前配置
backup_config() {
    if [[ -f "$MAIN_CONFIG" ]]; then
        local backup_file="$BACKUP_DIR/config-$(date +%Y%m%d-%H%M%S).yaml"
        cp "$MAIN_CONFIG" "$backup_file"
        echo -e "${GREEN}✓ 配置已备份到: $backup_file${NC}"
    fi
}

# 检查源文件是否存在
check_source_files() {
    local sources="$1"
    local IFS=','
    read -ra files <<< "$sources"

    for file in "${files[@]}"; do
        if [[ ! -f "$file" ]]; then
            echo -e "${RED}✗ 错误: 源文件不存在: $file${NC}" >&2
            return 1
        fi
        echo -e "${GREEN}✓ 找到源文件: $file${NC}"
    done
}

# 查看合并后的配置
view_merged_config() {
    local sources="$1"
    local output="$2"

    echo -e "${YELLOW}合并预览:${NC}"
    echo ""
    KUBECONFIG="$sources" kubectl config view --flatten > /tmp/merged-config.yaml

    echo "集群:"
    kubectl config get-clusters --kubeconfig=/tmp/merged-config.yaml | sed 's/^/  /'

    echo ""
    echo "上下文:"
    kubectl config get-contexts --kubeconfig=/tmp/merged-config.yaml | sed 's/^/  /'

    echo ""
    echo "用户:"
    kubectl config get-users --kubeconfig=/tmp/merged-config.yaml | sed 's/^/  /'

    rm /tmp/merged-config.yaml
}

# 合并配置文件
merge_configs() {
    local sources="$1"
    local output="$2"

    echo -e "${YELLOW}开始合并配置...${NC}"
    echo "源文件: $sources"
    echo "输出文件: $output"
    echo ""

    # 创建输出文件（如果不存在）
    touch "$output"

    # 合并配置
    KUBECONFIG="$output:$sources" kubectl config view --flatten > /tmp/merged-config.yaml

    # 验证合并结果
    if kubectl config get-contexts --kubeconfig=/tmp/merged-config.yaml &>/dev/null; then
        # 应用合并结果
        mv /tmp/merged-config.yaml "$output"
        echo -e "${GREEN}✓ 配置合并成功${NC}"
        echo ""
        echo "合并后的上下文:"
        kubectl config get-contexts --kubeconfig="$output" | sed 's/^/  /'
        return 0
    else
        echo -e "${RED}✗ 合并失败: 配置无效${NC}" >&2
        rm /tmp/merged-config.yaml
        return 1
    fi
}

# 主函数
main() {
    local sources=""
    local output="$MAIN_CONFIG"
    local backup=false
    local check_only=false

    # 解析参数
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -s|--source)
                sources="$2"
                shift 2
                ;;
            -o|--output)
                output="$2"
                shift 2
                ;;
            -b|--backup)
                backup=true
                shift
                ;;
            -c|--check)
                check_only=true
                shift
                ;;
            -h|--help)
                usage
                exit 0
                ;;
            *)
                echo -e "${RED}未知选项: $1${NC}" >&2
                usage
                exit 1
                ;;
        esac
    done

    # 检查是否指定了源文件
    if [[ -z "$sources" ]]; then
        echo -e "${RED}错误: 必须指定源文件${NC}" >&2
        echo ""
        echo "示例:"
        echo "  $(basename "$0") -s ~/.kube/config-dev,~/.kube/config-prod"
        exit 1
    fi

    # 检查源文件
    echo -e "${YELLOW}检查源文件...${NC}"
    if ! check_source_files "$sources"; then
        exit 1
    fi

    # 备份
    if [[ "$backup" == true ]]; then
        echo ""
        backup_config
    fi

    # 仅检查
    if [[ "$check_only" == true ]]; then
        echo ""
        view_merged_config "$sources" "$output"
        exit 0
    fi

    # 合并配置
    echo ""
    if ! merge_configs "$sources" "$output"; then
        exit 1
    fi

    # 完成
    echo ""
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}配置合并完成！${NC}"
    echo -e "${GREEN}========================================${NC}"
    echo ""
    echo "使用示例:"
    echo "  # 查看所有上下文"
    echo "  kubectl config get-contexts"
    echo ""
    echo "  # 切换上下文"
    echo "  kubectl config use-context <context-name>"
    echo ""
    echo "  # 设置为当前上下文"
    echo "  export KUBECONFIG=$output"
}

main "$@"
