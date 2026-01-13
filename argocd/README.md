# ArgoCD Terraform Deployment

使用Terraform在Kubernetes集群上部署ArgoCD的配置。

## 目录结构

```
├── README.md (this file)
├── environments/
│   └── dev/
│       ├── main.tf
│       ├── variables.tf
│       ├── terraform.tfvars
│       └── README.md
└── modules/
    └── argocd/
        ├── main.tf
        ├── variables.tf
        ├── outputs.tf
        └── versions.tf
```

## 前提条件

1. 安装Terraform >= 1.0.0
2. 安装kubectl
3. 拥有一个可用的Kubernetes集群
4. 配置好~/.kube/config文件，能够访问目标Kubernetes集群

## 部署步骤

### 1. 初始化Terraform

进入开发环境目录并初始化Terraform：

```bash
cd environments/dev
terraform init
```

### 2. 查看部署计划

```bash
terraform plan
```

### 3. 部署ArgoCD

```bash
terraform apply
```

输入`yes`确认部署。

## 配置说明

### 镜像源配置

默认使用阿里云镜像源加速下载：
- ArgoCD镜像：`registry.cn-hangzhou.aliyuncs.com/argoproj`
- Redis镜像：`registry.cn-hangzhou.aliyuncs.com/google_containers/redis`
- HAProxy镜像：`registry.cn-hangzhou.aliyuncs.com/google_containers/haproxy`

### 自定义配置

可以通过修改`environments/dev/terraform.tfvars`文件来自定义部署配置：

```hcl
# Kubernetes配置文件路径
kube_config_path = "~/.kube/config"

# ArgoCD部署命名空间
namespace = "argocd"

# ArgoCD Helm Chart版本
chart_version = "5.33.0"

# 国内镜像源
image_repository = "registry.cn-hangzhou.aliyuncs.com/argoproj"

# 额外的Helm配置
values = {
  # 示例：配置ArgoCD服务器的服务类型
  # "server.service.type" = "LoadBalancer"
  
  # 示例：增加资源限制
  # "server.resources.requests.cpu" = "250m"
  # "server.resources.requests.memory" = "256Mi"
}
```

## 访问ArgoCD

### 1. 端口转发

```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

### 2. 获取初始密码

```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

### 3. 访问ArgoCD界面

打开浏览器访问：`https://localhost:8080`

- 用户名：`admin`
- 密码：使用上述命令获取的初始密码

## 清理部署

要删除ArgoCD部署：

```bash
terraform destroy
```

输入`yes`确认删除。

## 注意事项

1. 确保~/.kube/config文件有足够的权限访问Kubernetes集群
2. 默认部署在`argocd`命名空间
3. 可以根据需要修改镜像源为其他国内镜像源
4. 首次登录后请立即修改初始密码