# MLflow Terraform Deployment

Terraform configuration for deploying MLflow on Kubernetes.

## Prerequisites

- Terraform >= 1.0
- kubectl configured for your Kubernetes cluster
- Access to container registries

## Quick Start

1. Review `terraform.tfvars` and adjust settings as needed
2. Initialize: `terraform init`
3. Plan: `terraform plan`
4. Deploy: `terraform apply`

## Configuration

Edit `terraform.tfvars` to customize:

- `mlflow_enabled`: Enable/disable deployment (default: true)
- `mlflow_namespace`: Target namespace (default: mlflow)
- `mlflow_replicas`: Server replicas (default: 1)
- `service_type`: Service type (default: ClusterIP)

## Access

After deployment, access MLflow via port forward:

```bash
kubectl port-forward -n mlflow svc/mlflow-server 5000:5000
```

Visit http://localhost:5000 in your browser.