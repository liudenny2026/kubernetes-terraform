#!/bin/bash
# 还原镜像地址到原始地址

set -e

echo "开始还原镜像地址..."

# 还原 GCR 镜像
sed -i 's|registry.cn-hangzhou.aliyuncs.com/google_containers/|gcr.io/|g' manifests/kfp.yaml
sed -i 's|registry.cn-hangzhou.aliyuncs.com/google_containers/|gcr.io/|g' manifests/kserve.yaml
sed -i 's|registry.cn-hangzhou.aliyuncs.com/google_containers/|gcr.io/|g' manifests/model-registry.yaml
sed -i 's|registry.cn-hangzhou.aliyuncs.com/google_containers/|gcr.io/|g' manifests/katib-operator.yaml

# 还原 quay.io 镜像
sed -i 's|registry.cn-hangzhou.aliyuncs.com/jetstack/|quay.io/jetstack/|g' manifests/kfp.yaml
sed -i 's|registry.cn-hangzhou.aliyuncs.com/jetstack/|quay.io/jetstack/|g' manifests/kserve.yaml

# 还原 docker.io/istio 镜像
sed -i 's|registry.cn-hangzhou.aliyuncs.com/istio/|docker.io/istio/|g' manifests/kfp.yaml
sed -i 's|registry.cn-hangzhou.aliyuncs.com/istio/|docker.io/istio/|g' manifests/kserve.yaml

# 还原 kubeflow/kserve 镜像
sed -i 's|registry.cn-hangzhou.aliyuncs.com/kubeflow/|docker.io/kubeflow/|g' manifests/kserve.yaml
sed -i 's|registry.cn-hangzhou.aliyuncs.com/kubeflow/|docker.io/kubeflow/|g' manifests/model-registry.yaml
sed -i 's|registry.cn-hangzhou.aliyuncs.com/kubeflow/|docker.io/kubeflow/|g' manifests/katib-operator.yaml

sed -i 's|registry.cn-hangzhou.aliyuncs.com/kserve/|docker.io/kserve/|g' manifests/kserve.yaml

# 还原其他镜像
sed -i 's|registry.cn-hangzhou.aliyuncs.com/minio/|docker.io/minio/|g' manifests/kfp.yaml
sed -i 's|registry.cn-hangzhou.aliyuncs.com/library/|docker.io/|g' manifests/katib-operator.yaml
sed -i 's|registry.cn-hangzhou.aliyuncs.com/library/|docker.io/|g' manifests/kfp.yaml

echo "镜像地址已还原！"
