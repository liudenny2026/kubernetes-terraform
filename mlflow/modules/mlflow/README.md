# MLflow Unified Module

This module provides a complete MLflow deployment with optional advanced features. It combines both basic and advanced MLflow functionality in a single, configurable module.

## Features

- Basic MLflow server deployment
- Optional internal PostgreSQL database
- Optional model registry component
- Optional Kubeflow integration
- Configurable resource allocation
- Persistent storage for artifacts
- Multiple service type options (ClusterIP, NodePort, LoadBalancer)

## Usage

```hcl
module "mlflow" {
  source = "./modules/mlflow"

  # Basic configuration
  mlflow_namespace = "mlflow"
  mlflow_replicas  = 1
  service_type     = "ClusterIP"

  # Database configuration
  postgres_user     = "mlflow"
  postgres_password = "mlflowpassword"
  postgres_db       = "mlflow"

  # Enable/disable optional components
  enable_model_registry       = false
  enable_kubeflow_integration = false

  # Resource configuration
  postgres_cpu_request    = "500m"
  postgres_memory_request = "512Mi"
  postgres_cpu_limit      = "1000m"
  postgres_memory_limit   = "1Gi"

  mlflow_server_cpu_request    = "1000m"
  mlflow_server_memory_request = "1Gi"
  mlflow_server_cpu_limit      = "2000m"
  mlflow_server_memory_limit   = "2Gi"
}
```

## Variables

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `mlflow_namespace` | Namespace for MLflow deployment | string | `"mlflow"` |
| `create_namespace` | Whether to create the namespace | bool | `true` |
| `mlflow_replicas` | Number of MLflow server replicas | number | `1` |
| `service_type` | MLflow server service type | string | `"ClusterIP"` |
| `enable_internal_postgres` | Whether to deploy internal PostgreSQL | bool | `true` |
| `postgres_user` | PostgreSQL username | string | `"mlflow"` |
| `postgres_password` | PostgreSQL password | string | `"mlflowpassword"` |
| `postgres_db` | PostgreSQL database name | string | `"mlflow"` |
| `enable_model_registry` | Enable MLflow model registry | bool | `false` |
| `enable_kubeflow_integration` | Enable Kubeflow integration | bool | `false` |

For a complete list of variables, see [variables.tf](variables.tf).

## Outputs

| Name | Description |
|------|-------------|
| `service_url` | MLflow service URL |
| `namespace` | MLflow namespace |
| `postgres_service` | PostgreSQL service address |
| `model_registry_service_url` | Model registry service URL (if enabled) |
| `kubeflow_integration_service` | Kubeflow integration service (if enabled) |

For a complete list of outputs, see [outputs.tf](outputs.tf).