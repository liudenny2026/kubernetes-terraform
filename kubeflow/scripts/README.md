# 镜像替换脚本使用说明

## 脚本说明

本项目提供两个脚本来管理 Docker 镜像地址：

- `replace-gcr-images.sh` - 将国外镜像替换为国内可下载的镜像
- `restore-original-images.sh` - 还原到原始镜像地址

## 镜像映射关系

| 原始镜像源 | 国内镜像源 |
|-----------|----------|
| `gcr.io/` | `registry.cn-hangzhou.aliyuncs.com/google_containers/` |
| `quay.io/jetstack/` | `registry.cn-hangzhou.aliyuncs.com/jetstack/` |
| `docker.io/istio/` | `registry.cn-hangzhou.aliyuncs.com/istio/` |
| `docker.io/kubeflow/` | `registry.cn-hangzhou.aliyuncs.com/kubeflow/` |
| `docker.io/kserve/` | `registry.cn-hangzhou.aliyuncs.com/kserve/` |
| `docker.io/minio/` | `registry.cn-hangzhou.aliyuncs.com/minio/` |
| `docker.io/mysql/` | `registry.cn-hangzhou.aliyuncs.com/library/` |

## 使用方法

### 1. 替换为国内镜像

```bash
cd scripts
chmod +x replace-gcr-images.sh
./replace-gcr-images.sh
```

### 2. 还原原始镜像

```bash
cd scripts
chmod +x restore-original-images.sh
./restore-original-images.sh
```

### 3. 验证替换结果

```bash
# 查看替换后的镜像
grep "image:" ../manifests/kfp.yaml | head -10
grep "image:" ../manifests/kserve.yaml | head -10
```

## 替换范围

脚本会修改以下文件中的镜像地址：

- `manifests/kfp.yaml`
- `manifests/kserve.yaml`
- `manifests/kserve-runtimes.yaml`
- `manifests/model-registry.yaml`
- `manifests/katib-operator.yaml`

## 注意事项

1. **备份原始文件**：建议在替换前备份原始 manifest 文件
   ```bash
   cd ../manifests
   cp kfp.yaml kfp.yaml.bak
   cp kserve.yaml kserve.yaml.bak
   ```

2. **镜像可用性**：阿里云镜像库可能不包含所有镜像，如遇到拉取失败的情况：
   - 方案A：手动拉取原始镜像并推送到私有仓库
   - 方案B：尝试其他镜像源（腾讯云、网易云等）

3. **版本兼容性**：确保替换后的镜像版本与原始版本一致

4. **Helm Chart 镜像**：Helm 部署的组件（如 Cert-Manager、Istio）需要单独在 values 文件中配置镜像地址

## Helm 镜像配置

对于通过 Helm 部署的组件，需要在 `main.tf` 或 `terraform.tfvars` 中添加镜像仓库配置：

### Cert-Manager

```hcl
resource "helm_release" "cert_manager" {
  # ... 其他配置
  values = [
    yamlencode({
      installCRDs = true
      image = {
        repository = "registry.cn-hangzhou.aliyuncs.com/jetstack/cert-manager-controller"
        tag = "v1.16.1"
      }
      # ... 其他配置
    })
  ]
}
```

### Istio

```hcl
resource "helm_release" "istiod" {
  # ... 其他配置
  values = [
    yamlencode({
      hub = "registry.cn-hangzhou.aliyuncs.com/istio"
      # ... 其他配置
    })
  ]
}
```

## 常见问题

### Q: 替换后仍然无法拉取镜像？

A: 某些阿里云镜像可能不存在，尝试以下方案：
1. 使用腾讯云镜像：`ccr.ccs.tencentyun.com/`
2. 手动拉取并推送到私有仓库
3. 配置 Docker 代理

### Q: 如何批量检查所有镜像地址？

A: 使用以下命令：
```bash
cd ../manifests
grep -r "image:" . | grep -v ".bak" | sort -u
```

### Q: Spark Operator 的镜像在哪里配置？

A: Spark Operator 是本地 Helm chart，需要编辑 `manifests/spark-operator.tgz` 中的 values 文件，或者在 `main.tf` 中配置：
```hcl
values = [
  yamlencode({
    image = {
      repository = "registry.cn-hangzhou.aliyuncs.com/kubeflow/spark-operator"
      tag = "2.4.0"
    }
  })
]
```

## 更新日志

- 2026-01-12: 初始版本，支持替换 GCR、quay.io、docker.io 镜像
