#!/bin/bash
# 替换所有国外镜像为国内可下载的镜像地址

set -e

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}开始替换镜像地址...${NC}"

# 1. 替换 GCR 镜像为阿里云镜像
echo -e "${YELLOW}[1/5] 替换 GCR 镜像...${NC}"
sed -i 's|gcr.io/|registry.cn-hangzhou.aliyuncs.com/google_containers/|g' manifests/kfp.yaml
sed -i 's|gcr.io/|registry.cn-hangzhou.aliyuncs.com/google_containers/|g' manifests/kserve.yaml
sed -i 's|gcr.io/|registry.cn-hangzhou.aliyuncs.com/google_containers/|g' manifests/model-registry.yaml
sed -i 's|gcr.io/|registry.cn-hangzhou.aliyuncs.com/google_containers/|g' manifests/katib-operator.yaml

# 2. 替换 quay.io 镜像
echo -e "${YELLOW}[2/5] 替换 quay.io 镜像...${NC}"
sed -i 's|quay.io/jetstack/|registry.cn-hangzhou.aliyuncs.com/jetstack/|g' manifests/kfp.yaml
sed -i 's|quay.io/jetstack/|registry.cn-hangzhou.aliyuncs.com/jetstack/|g' manifests/kserve.yaml

# 3. 替换 docker.io/istio 镜像
echo -e "${YELLOW}[3/5] 替换 docker.io/istio 镜像...${NC}"
sed -i 's|docker.io/istio/|registry.cn-hangzhou.aliyuncs.com/istio/|g' manifests/kfp.yaml
sed -i 's|docker.io/istio/|registry.cn-hangzhou.aliyuncs.com/istio/|g' manifests/kserve.yaml

# 4. 替换 docker.io/kubeflow 和 docker.io/kserve 镜像
echo -e "${YELLOW}[4/5] 替换 kubeflow/kserve 镜像...${NC}"
sed -i 's|docker.io/kubeflow/|registry.cn-hangzhou.aliyuncs.com/kubeflow/|g' manifests/kserve.yaml
sed -i 's|docker.io/kubeflow/|registry.cn-hangzhou.aliyuncs.com/kubeflow/|g' manifests/model-registry.yaml
sed -i 's|docker.io/kubeflow/|registry.cn-hangzhou.aliyuncs.com/kubeflow/|g' manifests/katib-operator.yaml

sed -i 's|docker.io/kserve/|registry.cn-hangzhou.aliyuncs.com/kserve/|g' manifests/kserve.yaml

# 5. 替换其他 docker.io 镜像（mysql, minio等）
echo -e "${YELLOW}[5/5] 替换其他 docker.io 镜像...${NC}"
sed -i 's|docker.io/minio/|registry.cn-hangzhou.aliyuncs.com/minio/|g' manifests/kfp.yaml
sed -i 's|docker.io/mysql/|registry.cn-hangzhou.aliyuncs.com/library/|g' manifests/katib-operator.yaml

echo -e "${GREEN}镜像地址替换完成！${NC}"
echo ""
echo "替换后的镜像示例："
echo "=========================================="
grep "image:" manifests/kfp.yaml | head -5
echo "=========================================="
echo ""
echo "请检查替换结果，确认无误后运行 terraform apply"
