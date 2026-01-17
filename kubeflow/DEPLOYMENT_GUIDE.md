# Kubeflow 完整部署方案

本文档提供了使用Terraform部署完整Kubeflow 1.9.x的详细指南，包括新增的核心组件：Jupyter Notebook Services、Central Dashboard和Authentication。

## 1. 系统要求

- Kubernetes集群 (1.27+ 推荐用于Kubeflow 1.9.x)
- kubectl 已配置
- Terraform 1.5.0+
- 充足的集群资源：至少4 CPU cores和12 GB RAM

## 2. 已包含的Kubeflow组件

### 注意：基础设施组件变更
**Cert-Manager** 和 **Istio** 已从本部署方案中移除，需要**单独部署**：
- 这两个组件是Kubeflow的前提条件
- 请参考官方文档进行手动安装
- 支持使用Kubernetes官方或云厂商提供的安装方式

### 核心功能组件
- ✅ **Training Operator** - 分布式训练
- ✅ **Katib** - 超参数调优
- ✅ **Kubeflow Pipelines** - ML工作流编排
- ✅ **Spark Operator** - Apache Spark作业管理

### 模型部署组件
- ✅ **KServe** - 模型服务
- ✅ **Model Registry** - 模型版本管理

### 用户界面组件
- ✅ **Central Dashboard** - Kubeflow Web UI主入口
- ✅ **Jupyter Notebook Services** - 交互式开发环境
- ✅ **Authentication** - Dex认证系统
- ✅ **Profile Controller** - 命名空间和资源管理

## 3. 部署前准备

### 3.1 下载必要的manifest文件

由于网络限制，某些Kubeflow组件的manifest文件需要手动下载：

1. **Training Operator**
   ```bash
   curl -o manifests/training-operator.yaml https://github.com/kubeflow/training-operator/releases/download/v1.8.0/training-operator.yaml
   ```

2. **Katib**
   ```bash
   curl -o manifests/katib-operator.yaml https://github.com/kubeflow/katib/releases/download/v0.17.0/katib-standalone-operator.yaml
   ```

3. **KServe Runtimes**
   ```bash
   curl -o manifests/kserve-runtimes.yaml https://github.com/kserve/kserve/releases/download/v0.13.0/kserve-runtimes.yaml
   ```

4. **Kubeflow Pipelines**
   ```bash
   curl -o manifests/kfp.yaml https://github.com/kubeflow/pipelines/releases/download/2.2.0/kfp-platform.yaml
   ```

5. **Model Registry**
   ```bash
   curl -o manifests/model-registry.yaml https://github.com/kubeflow/model-registry/releases/download/v0.2.0/model-registry.yaml
   ```

6. **Dex Authentication**
   ```bash
   curl -o manifests/dex.yaml https://github.com/kubeflow/manifests/releases/download/v1.9.1/dex.yaml
   ```

7. **Central Dashboard**
   ```bash
   curl -o manifests/centraldashboard.yaml https://github.com/kubeflow/manifests/releases/download/v1.9.1/centraldashboard.yaml
   ```

8. **Jupyter Web App**
   ```bash
   curl -o manifests/jupyter-web-app.yaml https://github.com/kubeflow/manifests/releases/download/v1.9.1/jupyter-web-app.yaml
   ```

### 3.2 配置环境变量

根据您的集群环境，编辑 `environments/dev/variables.tf` 文件：

```hcl
# Kubernetes配置
variable "kube_config_path" {
  description = "Path to the kubeconfig file"
  type        = string
  default     = "C:/Users/your_user/.kube/config"  # Windows example
}

# Kubeflow版本
variable "kubeflow_version" {
  description = "Target Kubeflow version for reference"
  type        = string
  default     = "1.9.1"
}
```

## 4. 部署步骤

### 4.1 初始化Terraform

```bash
cd environments/dev
terraform init
```

### 4.2 验证配置

```bash
terraform validate
terraform plan
```

### 4.3 执行部署

```bash
terraform apply -auto-approve
```

部署过程可能需要20-30分钟，具体取决于您的集群网络和资源配置。

## 5. 部署验证

### 5.1 检查所有组件状态

```bash
# 检查所有命名空间的Pod状态
kubectl get pods -A | grep -E "kubeflow|cert-manager|istio"

# 检查Kubeflow命名空间的所有组件
kubectl get pods -n kubeflow
```

### 5.2 访问Kubeflow Dashboard

#### 方式一：端口转发直接访问Central Dashboard
```bash
# 使用端口转发访问Central Dashboard服务
kubectl port-forward svc/centraldashboard -n kubeflow 8080:80
```

然后在浏览器中访问：`http://localhost:8080`

#### 方式二：使用已部署的Ingress（推荐）
如果您的集群已配置Ingress控制器，可以通过以下方式访问：
```bash
# 查看已配置的Ingress规则
kubectl get ingress -n kubeflow
```

使用显示的主机名访问Kubeflow Dashboard。

#### 方式三：使用已部署的Istio Gateway
如果您自行部署了Istio，可以使用Istio Ingress Gateway访问：
```bash
kubectl port-forward svc/istio-ingressgateway -n istio-system 8080:80
```

### 5.3 验证Jupyter Notebook功能

1. 登录Kubeflow Dashboard
2. 点击左侧菜单的"Notebooks"
3. 点击"New Server"创建一个新的Notebook实例
4. 选择合适的资源配置并点击"Launch"
5. 等待Notebook实例就绪后点击"Connect"

## 6. 组件详细说明

### 6.1 Jupyter Notebook Services

- **功能**：提供交互式开发环境，支持多种框架和镜像
- **访问方式**：通过Kubeflow Dashboard的"Notebooks"菜单
- **配置文件**：`manifests/jupyter-web-app.yaml`

### 6.2 Central Dashboard

- **功能**：Kubeflow的Web UI主入口，整合所有组件的访问
- **访问方式**：集群Ingress或端口转发
- **配置文件**：`manifests/centraldashboard.yaml`

### 6.3 Authentication

- **功能**：基于Dex的认证系统，支持多种认证方式
- **默认配置**：使用内置用户（admin@example.com）
- **配置文件**：`manifests/dex.yaml`

## 7. 常见问题与解决方案

### 7.1 资源不足

**问题**：Pod处于Pending状态，提示资源不足
**解决方案**：
- 增加集群资源
- 调整组件的资源请求和限制
- 考虑使用更小的镜像

### 7.2 证书问题

**问题**：HTTPS访问失败，证书错误
**解决方案**：
- 检查Cert-Manager是否正常运行
- 确认Let's Encrypt或自签名证书配置正确
- 查看证书请求状态：`kubectl get certificate -A`

### 7.3 Ingress访问问题

**问题**：无法通过Ingress访问Kubeflow
**解决方案**：
- 检查Istio Ingress Gateway状态：`kubectl get pods -n istio-system`
- 验证Ingress规则：`kubectl get gateway -n kubeflow`
- 使用端口转发进行临时访问

## 8. 清理与卸载

如需卸载Kubeflow，执行以下命令：

```bash
cd environments/dev
terraform destroy -auto-approve
```

注意：这将删除所有Kubeflow组件，包括数据和配置。

## 9. 后续优化建议

1. **配置持久存储**：为Jupyter Notebooks和Pipelines配置持久卷
2. **自定义认证**：集成企业认证系统（LDAP/OAuth）
3. **资源配额**：为不同用户设置资源配额
4. **监控与日志**：集成Prometheus和Grafana进行监控
5. **备份策略**：制定数据和模型的备份计划

---

通过本指南，您可以部署一个包含完整核心组件的Kubeflow环境，为数据科学家和ML工程师提供端到端的机器学习平台。