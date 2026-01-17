# 通过私有Harbor镜像代理仓库下载华为云SWR镜像

## 1. Harbor镜像代理功能介绍
Harbor支持配置代理项目（Proxy Cache），可以代理远程镜像仓库（如华为云SWR）。当用户从Harbor拉取镜像时：
- 如果Harbor本地已有该镜像，直接返回
- 如果Harbor本地没有该镜像，自动从远程仓库拉取并缓存
- 后续请求将直接使用缓存的镜像

## 2. 在Harbor中创建华为云SWR代理项目

### 步骤1：登录Harbor控制台
访问：`http://192.168.40.102`
使用管理员账号登录

### 步骤2：创建代理项目
1. 点击"新建项目"按钮
2. 填写项目信息：
   - 项目名称：`swr-proxy`
   - 访问级别：`公开`（或根据需求选择私有）
   - 项目类型：选择`代理缓存`
3. 配置代理设置：
   - 目标URL：`https://swr.cn-north-4.myhuaweicloud.com`
   - 认证方式：如果需要认证，选择`基本认证`并填写华为云SWR的访问密钥
   - 其他选项：保持默认
4. 点击"确定"创建项目

## 3. 配置Kubernetes节点使用Harbor代理

### 步骤1：配置Docker使用Harbor代理
在每个Kubernetes节点上执行以下操作：

1. 编辑Docker配置文件：
   ```bash
   vi /etc/docker/daemon.json
   ```

2. 添加Harbor代理配置：
   ```json
   {
     "registry-mirrors": [
       "http://192.168.40.102"
     ],
     "insecure-registries": [
       "192.168.40.102"
     ]
   }
   ```

3. 重启Docker服务：
   ```bash
   systemctl daemon-reload
   systemctl restart docker
   ```

### 步骤2：测试Harbor代理功能
```bash
# 从Harbor代理拉取华为云SWR的镜像
docker pull 192.168.40.102/swr-proxy/ddn-k8s/quay.io/jetstack/cert-manager-startupapicheck:v1.16.1

# tag为原始镜像名称
docker tag 192.168.40.102/swr-proxy/ddn-k8s/quay.io/jetstack/cert-manager-startupapicheck:v1.16.1 quay.io/jetstack/cert-manager-startupapicheck:v1.16.1
```

## 4. 批量下载镜像脚本

### 基于Harbor代理的镜像下载脚本
```bash
#!/bin/bash

# Harbor代理地址
HARBOR_PROXY="192.168.40.102/swr-proxy"

# 需要下载的镜像列表（从华为云SWR地址转换而来）
IMAGES=("ddn-k8s/quay.io/jetstack/cert-manager-startupapicheck:v1.16.1" 
        "ddn-k8s/docker.io/kubeflow/spark-operator/kubectl:2.4.0" 
        "ddn-k8s/docker.io/kubeflow/training-operator:v1.8.1" 
        "ddn-k8s/docker.io/kubeflow/katib-controller:v0.16.0" 
        "ddn-k8s/docker.io/kubeflow/katib-db-manager:v0.16.0" 
        "ddn-k8s/docker.io/kubeflow/katib-ui:v0.16.0" 
        "ddn-k8s/docker.io/mysql:8.0.32" 
        "ddn-k8s/docker.io/kserve/kserve-agent:v0.13.0" 
        "ddn-k8s/gcr.io/ml-pipeline/cache-server:2.3.0" 
        "ddn-k8s/docker.io/minio/minio:RELEASE.2023-01-25T00-19-54Z" 
        "ddn-k8s/gcr.io/ml-pipeline/workflow-controller:v3.4.3-patch" 
        "ddn-k8s/docker.io/kubeflow/centraldashboard:v1.9.0" 
        "ddn-k8s/docker.io/kubeflow/kubeflow:jupyter-web-app-v1.9.0" 
        "ddn-k8s/gcr.io/ml-pipeline/cache-deployer:2.3.0" 
        "ddn-k8s/kserve/storage-initializer:v0.13.0" 
        "ddn-k8s/kserve/router:v0.13.0" 
        "ddn-k8s/kserve/art-explainer")

# 下载并tag镜像
for IMAGE in "${IMAGES[@]}"; do
    # 提取原始镜像名称（去掉ddn-k8s/前缀）
    ORIGINAL_IMAGE=$(echo $IMAGE | sed 's/ddn-k8s\///')
    
    echo "正在下载: $HARBOR_PROXY/$IMAGE"
    docker pull $HARBOR_PROXY/$IMAGE
    
    echo "正在tag: $HARBOR_PROXY/$IMAGE -> $ORIGINAL_IMAGE"
    docker tag $HARBOR_PROXY/$IMAGE $ORIGINAL_IMAGE
    
    echo "完成: $ORIGINAL_IMAGE"
    echo ""
done

echo "所有镜像下载和tag完成！"
```

## 5. 在Kubernetes集群中使用Harbor代理

### 配置Kubernetes镜像拉取秘密（如果Harbor项目是私有的）
```bash
# 创建Harbor认证秘密
kubectl create secret docker-registry harbor-credential \
  --docker-server=192.168.40.102 \
  --docker-username=<harbor-username> \
  --docker-password=<harbor-password> \
  --namespace=kubeflow
```

### 在Deployment中使用Harbor代理镜像
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: cert-manager-webhook
  namespace: cert-manager
spec:
  template:
    spec:
      containers:
      - name: cert-manager-webhook
        # 使用Harbor代理的镜像
        image: 192.168.40.102/swr-proxy/ddn-k8s/quay.io/jetstack/cert-manager-webhook:v1.16.1
      # 如果Harbor项目是私有的，需要指定imagePullSecrets
      imagePullSecrets:
      - name: harbor-credential
```

## 6. 优势总结

1. **集中管理**：所有节点从同一个Harbor代理拉取镜像
2. **减少网络流量**：第一次拉取后，后续请求使用缓存
3. **提高可靠性**：即使远程仓库不可用，仍可使用缓存的镜像
4. **简化配置**：无需在每个节点配置多个镜像源
5. **统一认证**：只需要在Harbor中配置一次远程仓库的认证信息

## 7. 注意事项

1. 确保Harbor服务器有足够的磁盘空间来缓存镜像
2. 定期监控Harbor的缓存使用情况
3. 根据需要配置镜像缓存的过期策略
4. 确保Kubernetes节点可以访问Harbor服务器（端口5000或80/443）
5. 如果Harbor使用HTTPS，确保配置了正确的证书
