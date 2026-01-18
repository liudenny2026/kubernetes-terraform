# 新增企业级模块使用指南

## 概述

本文档介绍新增的企业级Kubernetes Terraform模块的使用方法。

## 新增模块列表

### P0 - 企业必需模块
1. **Cert-Manager** - TLS证书自动化管理
2. **Keycloak** - 统一身份认证SSO
3. **Velero** - 备份恢复
4. **PostgreSQL Operator** - 数据库
5. **Redis Operator** - 缓存

### P1 - 高优先级模块
1. **Kong** - API网关
2. **RabbitMQ** - 消息队列
3. **Elasticsearch** - 日志搜索
4. **Kubecost** - 成本管理
5. **DevSpace** - 开发工具

## 模块使用示例

### 1. Cert-Manager 使用示例

```hcl
module "cert_manager" {
  source = "./modules/certificate/cert-manager"

  namespace         = "cert-manager"
  create_namespace = true

  chart_version = "1.13.2"
  replica_count = 1

  create_letsencrypt_issuer = true
  letsencrypt_email          = "admin@example.com"
  letsencrypt_issuer_name    = "letsencrypt"

  letsencrypt_solvers = [
    {
      http01 = {
        ingress = {
          class = "nginx"
        }
      }
    }
  ]

  enable_prometheus_monitoring = true

  kubeconfig_path = var.kubeconfig_path
}
```

### 2. Keycloak 使用示例

```hcl
module "keycloak" {
  source = "./modules/iam/keycloak"

  namespace         = "keycloak"
  create_namespace = true

  chart_version = "15.0.6"
  replica_count = 1

  admin_user     = "admin"
  admin_password = var.keycloak_admin_password

  ingress_enabled     = true
  ingress_hostname    = "keycloak.example.com"
  ingress_tls        = true
  ingress_class_name = "nginx"

  create_database = true
  db_persistence_enabled = true
  db_storage_size = "8Gi"

  enable_metrics = true

  kubeconfig_path = var.kubeconfig_path
}
```

### 3. Velero 使用示例

```hcl
module "velero" {
  source = "./modules/backup/velero"

  namespace         = "velero"
  create_namespace = true

  chart_version = "5.0.0"

  cloud_provider = "aws"
  region        = "us-east-1"

  backup_bucket_name = "my-k8s-backups"
  backup_prefix      = "velero"
  backup_ttl         = "720h"

  create_s3_secret = true
  s3_access_key_id     = var.aws_access_key
  s3_secret_access_key = var.aws_secret_key

  schedule_name = "daily-backup"
  schedule_cron = "0 2 * * *"

  use_restic = true

  enable_metrics = true

  kubeconfig_path = var.kubeconfig_path
}
```

### 4. PostgreSQL Operator 使用示例

```hcl
module "postgresql" {
  source = "./modules/database/postgresql"

  namespace         = "postgresql"
  create_namespace = true

  chart_version = "15.2.5"
  replica_count = 1

  image_tag = "16.1.0"

  persistence_enabled = true
  persistence_size     = "10Gi"
  storage_class       = "gp2"

  memory_request = "256Mi"
  cpu_request    = "250m"
  memory_limit  = "2Gi"
  cpu_limit     = "1000m"

  extra_sets = [
    {
      name  = "auth.password"
      value = var.postgresql_password
    }
  ]

  kubeconfig_path = var.kubeconfig_path
}
```

### 5. Redis Operator 使用示例

```hcl
module "redis" {
  source = "./modules/cache/redis"

  namespace         = "redis"
  create_namespace = true

  chart_version = "18.1.5"
  replica_count = 1

  persistence_enabled = true
  persistence_size     = "4Gi"

  memory_request = "128Mi"
  cpu_request    = "100m"
  memory_limit  = "512Mi"
  cpu_limit     = "500m"

  extra_sets = [
    {
      name  = "auth.enabled"
      value = "true"
    }
  ]

  kubeconfig_path = var.kubeconfig_path
}
```

### 6. Kong API Gateway 使用示例

```hcl
module "kong" {
  source = "./modules/api-gateway/kong"

  namespace         = "kong"
  create_namespace = true

  chart_version = "2.35.0"
  replica_count = 2

  persistence_enabled = true
  persistence_size     = "8Gi"

  service_type = "LoadBalancer"

  ingress_enabled  = true
  ingress_hostname = "kong.example.com"
  ingress_tls     = true

  memory_request = "512Mi"
  cpu_request    = "500m"
  memory_limit  = "2Gi"
  cpu_limit     = "2000m"

  kubeconfig_path = var.kubeconfig_path
}
```

### 7. RabbitMQ 使用示例

```hcl
module "rabbitmq" {
  source = "./modules/messaging/rabbitmq"

  namespace         = "rabbitmq"
  create_namespace = true

  chart_version = "12.12.7"
  replica_count = 1

  rabbitmq_username = "admin"

  persistence_enabled = true
  persistence_size     = "8Gi"

  service_type = "ClusterIP"

  ingress_enabled     = true
  ingress_hostname    = "rabbitmq.example.com"
  ingress_tls        = true
  cert_manager_enabled = true

  memory_request = "256Mi"
  cpu_request    = "250m"
  memory_limit  = "1Gi"
  cpu_limit     = "1000m"

  enable_metrics = true

  kubeconfig_path = var.kubeconfig_path
}
```

### 8. Elasticsearch 使用示例

```hcl
module "elasticsearch" {
  source = "./modules/search/elasticsearch"

  namespace         = "elasticsearch"
  create_namespace = true

  chart_version = "8.5.1"
  replica_count = 3

  persistence_enabled = true
  persistence_size     = "20Gi"

  memory_request = "2Gi"
  cpu_request    = "1000m"
  memory_limit  = "4Gi"
  cpu_limit     = "2000m"

  extra_sets = [
    {
      name  = "protocol"
      value = "http"
    },
    {
      name  = "transport.host"
      value = "0.0.0.0"
    }
  ]

  kubeconfig_path = var.kubeconfig_path
}
```

### 9. Kubecost 使用示例

```hcl
module "kubecost" {
  source = "./modules/cost-management/kubecost"

  namespace         = "kubecost"
  create_namespace = true

  chart_version = "1.103.3"
  replica_count = 1

  persistence_enabled = true
  persistence_size     = "10Gi"

  memory_request = "1Gi"
  cpu_request    = "500m"
  memory_limit  = "4Gi"
  cpu_limit     = "2000m"

  ingress_enabled  = true
  ingress_hostname = "kubecost.example.com"
  ingress_tls     = true

  kubeconfig_path = var.kubeconfig_path
}
```

### 10. DevSpace 使用示例

```hcl
module "devspace" {
  source = "./modules/developer-experience/devspace"

  namespace         = "devspace"
  create_namespace = true

  chart_version = "6.3.0"
  replica_count = 1

  memory_request = "256Mi"
  cpu_request    = "250m"
  memory_limit  = "1Gi"
  cpu_limit     = "1000m"

  kubeconfig_path = var.kubeconfig_path
}
```

## 部署最佳实践

### 1. 按优先级部署

**第一阶段（立即部署）**:
```hcl
# 基础设施层
module "cert_manager" { }
module "velero"        { }

# 认证层
module "keycloak" { }
```

**第二阶段（1-2周内）**:
```hcl
# 数据层
module "postgresql" { }
module "redis"       { }

# 消息层
module "rabbitmq"    { }
```

**第三阶段（1个月内）**:
```hcl
# API网关层
module "kong"          { }

# 搜索层
module "elasticsearch" { }

# 运维层
module "kubecost"      { }
module "devspace"      { }
```

### 2. 资源配置建议

根据环境调整资源:

**开发环境**:
- replicas: 1
- memory_limit: "512Mi"
- cpu_limit: "500m"

**生产环境**:
- replicas: 3
- memory_limit: "2Gi"
- cpu_limit: "2000m"

**高可用配置**:
- replicas: 3
- 启用持久化存储
- 配置反亲和性规则

### 3. 监控集成

所有模块都支持Prometheus监控:
```hcl
enable_metrics        = true
enable_service_monitor = true
```

### 4. 高可用配置

```hcl
replica_count = 3

topology_spread_constraints_enabled = true
topology_spread_max_skew            = 1

persistence_enabled = true
persistence_size     = "10Gi"
```

## 常见问题

### Q1: 如何配置Let's Encrypt证书?

Cert-Manager模块自动配置Let's Encrypt:
```hcl
create_letsencrypt_issuer = true
letsencrypt_email          = "your@email.com"
```

### Q2: 如何配置备份?

Velero模块提供自动备份:
```hcl
schedule_name = "daily-backup"
schedule_cron = "0 2 * * *"
backup_ttl    = "720h"  # 30天
```

### Q3: 如何监控成本?

Kubecost提供实时成本监控:
```hcl
module "kubecost" {
  ingress_enabled  = true
  ingress_hostname = "kubecost.example.com"
}
```

## 输出变量

每个模块都提供以下输出:
- `namespace` - 安装命名空间
- `release_name` - Helm发布名称
- `service_name` - 服务名称

特定模块额外输出:
- Cert-Manager: `letsencrypt_production_issuer`
- Keycloak: `admin_url`, `external_url`
- Velero: `backup_bucket`, `schedule_name`
- RabbitMQ: `amqp_url`, `management_url`

## 总结

新增的10个企业级模块覆盖了:
- ✅ 身份认证与访问控制
- ✅ 证书管理
- ✅ 备份恢复
- ✅ 数据库
- ✅ 缓存
- ✅ API网关
- ✅ 消息队列
- ✅ 搜索引擎
- ✅ 成本管理
- ✅ 开发工具

这些模块使用标准Terraform和Helm Chart,支持云原生最佳实践,易于部署和维护。
