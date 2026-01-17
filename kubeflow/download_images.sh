# 以下是下载和tag kubeflow缺失镜像的命令
# 使用华为云SWR源下载镜像，然后tag为原始镜像名称

# 1. quay.io/jetstack/cert-manager-startupapicheck:v1.16.1
docker pull swr.cn-north-4.myhuaweicloud.com/ddn-k8s/quay.io/jetstack/cert-manager-startupapicheck:v1.16.1
docker tag swr.cn-north-4.myhuaweicloud.com/ddn-k8s/quay.io/jetstack/cert-manager-startupapicheck:v1.16.1 quay.io/jetstack/cert-manager-startupapicheck:v1.16.1

# 2. docker.io/kubeflow/spark-operator/kubectl:2.4.0
docker pull swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/kubeflow/spark-operator/kubectl:2.4.0
docker tag swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/kubeflow/spark-operator/kubectl:2.4.0 docker.io/kubeflow/spark-operator/kubectl:2.4.0

# 3. docker.io/kubeflow/training-operator:v1.8.1
docker pull swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/kubeflow/training-operator:v1.8.1
docker tag swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/kubeflow/training-operator:v1.8.1 docker.io/kubeflow/training-operator:v1.8.1

# 4. docker.io/kubeflow/katib-controller:v0.16.0
docker pull swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/kubeflow/katib-controller:v0.16.0
docker tag swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/kubeflow/katib-controller:v0.16.0 docker.io/kubeflow/katib-controller:v0.16.0

# 5. docker.io/kubeflow/katib-db-manager:v0.16.0
docker pull swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/kubeflow/katib-db-manager:v0.16.0
docker tag swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/kubeflow/katib-db-manager:v0.16.0 docker.io/kubeflow/katib-db-manager:v0.16.0

# 6. docker.io/kubeflow/katib-ui:v0.16.0
docker pull swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/kubeflow/katib-ui:v0.16.0
docker tag swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/kubeflow/katib-ui:v0.16.0 docker.io/kubeflow/katib-ui:v0.16.0

# 7. docker.io/mysql:8.0.32
docker pull swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/mysql:8.0.32
docker tag swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/mysql:8.0.32 docker.io/mysql:8.0.32

# 8. docker.io/kserve/kserve-agent:v0.13.0
docker pull swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/kserve/kserve-agent:v0.13.0
docker tag swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/kserve/kserve-agent:v0.13.0 docker.io/kserve/kserve-agent:v0.13.0

# 9. gcr.io/ml-pipeline/cache-server:2.3.0
docker pull swr.cn-north-4.myhuaweicloud.com/ddn-k8s/gcr.io/ml-pipeline/cache-server:2.3.0
docker tag swr.cn-north-4.myhuaweicloud.com/ddn-k8s/gcr.io/ml-pipeline/cache-server:2.3.0 gcr.io/ml-pipeline/cache-server:2.3.0

# 10. docker.io/minio/minio:RELEASE.2023-01-25T00-19-54Z
docker pull swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/minio/minio:RELEASE.2023-01-25T00-19-54Z
docker tag swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/minio/minio:RELEASE.2023-01-25T00-19-54Z docker.io/minio/minio:RELEASE.2023-01-25T00-19-54Z

# 11. gcr.io/ml-pipeline/workflow-controller:v3.4.3-patch
docker pull swr.cn-north-4.myhuaweicloud.com/ddn-k8s/gcr.io/ml-pipeline/workflow-controller:v3.4.3-patch
docker tag swr.cn-north-4.myhuaweicloud.com/ddn-k8s/gcr.io/ml-pipeline/workflow-controller:v3.4.3-patch gcr.io/ml-pipeline/workflow-controller:v3.4.3-patch

# 12. docker.io/kubeflow/centraldashboard:v1.9.0
docker pull swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/kubeflow/centraldashboard:v1.9.0
docker tag swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/kubeflow/centraldashboard:v1.9.0 docker.io/kubeflow/centraldashboard:v1.9.0

# 13. docker.io/kubeflow/kubeflow:jupyter-web-app-v1.9.0
docker pull swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/kubeflow/kubeflow:jupyter-web-app-v1.9.0
docker tag swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/kubeflow/kubeflow:jupyter-web-app-v1.9.0 docker.io/kubeflow/kubeflow:jupyter-web-app-v1.9.0

# 14. gcr.io/ml-pipeline/cache-deployer:2.3.0
docker pull swr.cn-north-4.myhuaweicloud.com/ddn-k8s/gcr.io/ml-pipeline/cache-deployer:2.3.0
docker tag swr.cn-north-4.myhuaweicloud.com/ddn-k8s/gcr.io/ml-pipeline/cache-deployer:2.3.0 gcr.io/ml-pipeline/cache-deployer:2.3.0

# 15. kserve/storage-initializer:v0.13.0
docker pull swr.cn-north-4.myhuaweicloud.com/ddn-k8s/kserve/storage-initializer:v0.13.0
docker tag swr.cn-north-4.myhuaweicloud.com/ddn-k8s/kserve/storage-initializer:v0.13.0 kserve/storage-initializer:v0.13.0

# 16. kserve/router:v0.13.0
docker pull swr.cn-north-4.myhuaweicloud.com/ddn-k8s/kserve/router:v0.13.0
docker tag swr.cn-north-4.myhuaweicloud.com/ddn-k8s/kserve/router:v0.13.0 kserve/router:v0.13.0

# 17. kserve/art-explainer
docker pull swr.cn-north-4.myhuaweicloud.com/ddn-k8s/kserve/art-explainer
docker tag swr.cn-north-4.myhuaweicloud.com/ddn-k8s/kserve/art-explainer kserve/art-explainer
