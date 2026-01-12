# GitLab Kubernetes Deployment
# GitLab Kubernetes 部署

This repository contains Terraform configurations for deploying GitLab to a Kubernetes cluster. The project is organized with a modular approach to enable consistent deployments across different environments.

本仓库包含用于将 GitLab 部署到 Kubernetes 集群的 Terraform 配置。该项目采用模块化方法组织，以便在不同环境中实现一致的部署。

## Project Structure
## 项目结构

```
kubernetes/gitlab/
├── README.md (this file)
├── environments/
│   └── dev/
│       ├── main.tf
│       ├── variables.tf
│       ├── terraform.tfvars
│       └── README.md
└── modules/
    └── gitlab/
        ├── main.tf
        ├── variables.tf
        ├── outputs.tf
        └── versions.tf
```

## Environments
## 环境配置

The `environments/` directory contains environment-specific configurations:

`environments/` 目录包含特定环境的配置：

- `dev/` - Development environment configuration
- `dev/` - 开发环境配置

Each environment directory contains:

每个环境目录包含：

- `main.tf` - Environment-specific Terraform configuration
- `main.tf` - 特定环境的 Terraform 配置
- `variables.tf` - Environment-specific variable definitions
- `variables.tf` - 特定环境的变量定义
- `terraform.tfvars` - Environment-specific variable values
- `terraform.tfvars` - 特定环境的变量值
- `README.md` - Environment-specific documentation
- `README.md` - 特定环境的文档

## Modules
## 模块

The `modules/` directory contains reusable Terraform modules:

`modules/` 目录包含可重用的 Terraform 模块：

- `gitlab/` - GitLab deployment module that handles the actual GitLab installation on Kubernetes
- `gitlab/` - GitLab 部署模块，负责在 Kubernetes 上实际安装 GitLab

## Getting Started
## 开始使用

1. Navigate to your desired environment:

1. 导航到您想要的环境：
   ```bash
   cd environments/dev
   ```

2. Initialize Terraform:

2. 初始化 Terraform：
   ```bash
   terraform init
   ```

3. Review the execution plan:

3. 查看执行计划：
   ```bash
   terraform plan
   ```

4. Deploy GitLab:

4. 部署 GitLab：
   ```bash
   terraform apply
   ```

## Prerequisites
## 前置条件

- Terraform >= 1.0
- Kubernetes cluster with kubectl configured to connect via `~/.kube/config`
- Available storage classes in your Kubernetes cluster

- Terraform >= 1.0 版本
- 已配置 kubectl 连接到 Kubernetes 集群（通过 `~/.kube/config`）
- Kubernetes 集群中存在可用的存储类

## Configuration
## 配置

See the environment-specific README files for detailed configuration options and deployment instructions.

有关详细的配置选项和部署说明，请参阅特定环境的 README 文件。

## Contributing
## 贡献

For changes to the GitLab module itself, modify the files in `modules/gitlab/`. For environment-specific changes, modify the appropriate environment directory.

如需修改 GitLab 模块本身，请修改 `modules/gitlab/` 目录中的文件。如需环境特定的更改，请修改相应的环境目录。