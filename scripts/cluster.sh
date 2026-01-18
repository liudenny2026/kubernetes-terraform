#!/bin/bash
# ============================================================================
# 多集群管理辅助脚本
# ============================================================================

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 配置
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
KUBECONFIG="${KUBECONFIG:-$HOME/.kube/config}"

# 帮助信息
usage() {
    cat << EOF
多集群管理工具

用法:
    $(basename "$0") <command> [options]

命令:
    list                    列出所有可用集群上下文
    use <context>           切换到指定的集群上下文
    current                 显示当前集群上下文
    test <context>          测试到指定集群的连接
    deploy <env>            部署到指定环境 (dev|prod|stage)
    plan <env>              规划指定环境变更
    status <env>            查看环境状态

选项:
    -h, --help              显示帮助信息

示例:
    $(basename "$0") list
    $(basename "$0") use dev.kubernetes.cluster
    $(basename "$0") test prod.kubernetes.cluster
    $(basename "$0") deploy dev
    $(basename "$0") plan prod
    $(basename "$0") status dev

环境变量:
    KUBECONFIG              kubeconfig 文件路径 (默认: ~/.kube/config)
    TF_VAR_config_context   Terraform 使用的上下文 (覆盖默认值)

EOF
}

# 列出所有上下文
list_contexts() {
    echo -e "${GREEN}可用的 Kubernetes 集群上下文:${NC}"
    kubectl config get-contexts -o name | while read -r ctx; do
        local current=""
        if [[ "$(kubectl config current-context)" == "$ctx" ]]; then
            current=" ${YELLOW}(当前)${NC}"
        fi
        echo -e "  - ${ctx}${current}"
    done
}

# 使用指定上下文
use_context() {
    local context="$1"
    if [[ -z "$context" ]]; then
        echo -e "${RED}错误: 请指定上下文名称${NC}" >&2
        exit 1
    fi

    if ! kubectl config get-contexts -o name | grep -q "^${context}$"; then
        echo -e "${RED}错误: 上下文 '$context' 不存在${NC}" >&2
        echo -e "${YELLOW}可用上下文:${NC}"
        kubectl config get-contexts -o name
        exit 1
    fi

    kubectl config use-context "$context"
    echo -e "${GREEN}✓ 已切换到上下文: $context${NC}"
}

# 显示当前上下文
current_context() {
    local ctx
    ctx=$(kubectl config current-context)
    echo -e "${GREEN}当前集群上下文:${NC} $ctx"
    echo -e "${GREEN}集群服务器:${NC} $(kubectl config view -o jsonpath="{.contexts[?(@.name==\"$ctx\")].context.cluster}")"
    echo -e "${GREEN}认证用户:${NC} $(kubectl config view -o jsonpath="{.contexts[?(@.name==\"$ctx\")].context.user}")"
}

# 测试连接
test_connection() {
    local context="$1"
    if [[ -z "$context" ]]; then
        echo -e "${RED}错误: 请指定上下文名称${NC}" >&2
        exit 1
    fi

    echo -e "${YELLOW}测试连接到集群: $context${NC}"
    if kubectl --context="$context" cluster-info &>/dev/null; then
        echo -e "${GREEN}✓ 连接成功${NC}"
        echo ""
        echo "集群节点:"
        kubectl --context="$context" get nodes -o wide
        return 0
    else
        echo -e "${RED}✗ 连接失败${NC}" >&2
        return 1
    fi
}

# 部署环境
deploy_env() {
    local env="$1"
    if [[ -z "$env" ]]; then
        echo -e "${RED}错误: 请指定环境 (dev|prod|stage)${NC}" >&2
        exit 1
    fi

    local env_dir="$PROJECT_ROOT/environments/$env"
    if [[ ! -d "$env_dir" ]]; then
        echo -e "${RED}错误: 环境 '$env' 不存在${NC}" >&2
        exit 1
    fi

    # 推断上下文名称
    local context="${env}.kubernetes.cluster"
    if [[ -n "$TF_VAR_config_context" ]]; then
        context="$TF_VAR_config_context"
    fi

    echo -e "${YELLOW}部署到环境: $env${NC}"
    echo -e "${YELLOW}使用上下文: $context${NC}"
    echo ""

    cd "$env_dir"
    terraform init
    terraform plan -var="config_context=$context" -out=tfplan
    echo -e "${GREEN}✓ 计划完成，请查看上述变更${NC}"
    echo ""
    read -p "确认部署? (y/N) " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        terraform apply tfplan
        echo -e "${GREEN}✓ 部署完成${NC}"
    else
        echo "部署已取消"
    fi
}

# 规划环境
plan_env() {
    local env="$1"
    if [[ -z "$env" ]]; then
        echo -e "${RED}错误: 请指定环境 (dev|prod|stage)${NC}" >&2
        exit 1
    fi

    local env_dir="$PROJECT_ROOT/environments/$env"
    if [[ ! -d "$env_dir" ]]; then
        echo -e "${RED}错误: 环境 '$env' 不存在${NC}" >&2
        exit 1
    fi

    local context="${env}.kubernetes.cluster"
    if [[ -n "$TF_VAR_config_context" ]]; then
        context="$TF_VAR_config_context"
    fi

    echo -e "${YELLOW}规划环境: $env${NC}"
    echo -e "${YELLOW}使用上下文: $context${NC}"
    echo ""

    cd "$env_dir"
    terraform init
    terraform plan -var="config_context=$context"
}

# 查看环境状态
show_status() {
    local env="$1"
    if [[ -z "$env" ]]; then
        echo -e "${RED}错误: 请指定环境 (dev|prod|stage)${NC}" >&2
        exit 1
    fi

    local env_dir="$PROJECT_ROOT/environments/$env"
    if [[ ! -d "$env_dir" ]]; then
        echo -e "${RED}错误: 环境 '$env' 不存在${NC}" >&2
        exit 1
    fi

    cd "$env_dir"

    if [[ ! -d ".terraform" ]]; then
        echo -e "${YELLOW}环境 '$env' 未初始化${NC}"
        return
    fi

    echo -e "${GREEN}环境 '$env' 状态:${NC}"
    echo ""
    terraform show
}

# 主函数
main() {
    local command="$1"

    case "$command" in
        list)
            list_contexts
            ;;
        use)
            use_context "$2"
            ;;
        current)
            current_context
            ;;
        test)
            test_connection "$2"
            ;;
        deploy)
            deploy_env "$2"
            ;;
        plan)
            plan_env "$2"
            ;;
        status)
            show_status "$2"
            ;;
        -h|--help|help)
            usage
            ;;
        "")
            usage
            exit 1
            ;;
        *)
            echo -e "${RED}错误: 未知命令 '$command'${NC}" >&2
            usage
            exit 1
            ;;
    esac
}

main "$@"
