# Terraform Dev Environment

此目录包含开发环境的 Terraform 配置。

## 使用步骤

### 1. 初始化 Terraform

```bash
terraform init
```

### 2. 查看计划

```bash
terraform plan
```

### 3. 应用配置

```bash
terraform apply
```

### 4. 获取输出信息

```bash
terraform output
```

## 配置说明

主要配置项在 `terraform.tfvars` 文件中：

- `kubeconfig_path`: kubeconfig 文件路径
- `namespace`: 监控组件部署的命名空间
- `enable_istio_monitoring`: 是否启用 Istio 监控
- `enable_ceph_monitoring`: 是否启用 Ceph 监控
- `storage_class`: 存储类名称
- `registry_mirror`: 镜像源地址

## 访问 Grafana

应用配置后，使用以下命令获取 Grafana URL：

```bash
terraform output grafana_url
```

默认用户名: `admin`
默认密码: `prom-operator`

## 清理资源

```bash
terraform destroy
```
