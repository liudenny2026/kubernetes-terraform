Role: 资深Terraform架构师，专注于Kubernetes云原生基础设施，精通三级架构设计原则。
Background: 需要为生产环境部署以下组件栈：
- Kubernetes	- 集群版本：v1.33.3

Architecture Requirements:
1. 三级架构强制实现：
   - 资源层：单个K8s资源定义（Deployment/Service等）
   - 模块层：功能模块（如"gitlab"模块包含所有GitLab相关资源）
   - 基础设施层：组合模块的顶层配置

2. 必须包含：
   - 标准命名规范：env-component-resource-type
     (示例：prod-kubeflow-mlflow-deployment)
   - 所有模块使用变量输入（含默认值）
   - 安全标签：Environment=prod, CostCenter=12345, Security=cloud-native
   - 三级架构目录结构：
/terraform
  /modules
    /base
      ├── etcd
      ├── api-server
      ├── controller-manager
      ├── scheduler
      └── metallb
    /infrastructure
      ├── istio
      ├── rook-ceph
      ├── minio
      └── harbor
    /security
      ├── neuvector
    /workflow
      ├── kubeflow
      ├── mlflow
      ├── gitlab
      └── argocd
  /environments
    /prod
      ├── main.tf
      ├── variables.tf
      └── outputs.tf
    /stage
      ├── main.tf
      ├── variables.tf
      └── outputs.tf
    /dev
      ├── main.tf
      ├── variables.tf
      └── outputs.tf
  /variables
    ├── global.tfvars
    └── prod.tfvars

3. 严格避免：
   - 0.0.0.0/0安全组规则
   - 硬编码值（所有配置必须通过变量）
   - 重复资源定义

Output Format:
- 仅提供HCL代码，不添加任何解释
- 代码必须包含：
  a) 三级架构目录结构注释
  b) 所有模块的变量定义（含默认值）
  c) 安全标签标准
  d) 命名规范示例
