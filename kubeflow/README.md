# Kubeflow Terraform Deployment

This project deploys Kubeflow 1.9.x to a Kubernetes cluster using Terraform.

## Project Structure

```
.
├── environments/
│   ├── dev/           # Development environment configuration
│   ├── prod/          # Production environment configuration
│   └── stage/         # Staging environment configuration
├── modules/
│   └── kubeflow/      # Reusable Kubeflow module
├── manifests/         # Kubeflow component manifests
└── docs/              # Documentation
```

## Quick Start

### Prerequisites

- Kubernetes cluster (1.27+ recommended for Kubeflow 1.9.x)
- kubectl configured
- Terraform 1.5.0+

### Dev Environment

```bash
cd environments/dev
terraform init
terraform plan
terraform apply
```

## Components

The following Kubeflow components are deployed using manifests:

1. **Spark Operator** - Apache Spark job management
2. **Training Operator** - Distributed training (TFJob, PyTorchJob, etc.)
3. **Katib** - Hyperparameter tuning
4. **KServe** - Model serving
5. **Kubeflow Pipelines** - ML workflow orchestration
6. **Model Registry** - Model versioning
7. **Dex Authentication** - Authentication system
8. **Central Dashboard** - Kubeflow web interface
9. **Jupyter Notebook Services** - Interactive development environment
10. **Profile Controller** - Namespace and resource management

## Important Notes

### Prerequisite Components

- **Cert-Manager**: Should be deployed separately before Kubeflow
- **Istio**: Should be deployed separately if service mesh is required

Refer to official documentation for manual installation instructions.

## Configuration

Edit `environments/*/variables.tf` to customize your deployment:

```hcl
variable "kube_config_path" {
  description = "Path to the kubeconfig file"
  type        = string
  default     = "C:/Users/your_user/.kube/config"  # Windows example
}

variable "kubeflow_version" {
  description = "Target Kubeflow version for reference"
  type        = string
  default     = "1.9.1"
}
```

## Manual Steps

Some Kubeflow components require manual download. See `MANUAL_STEPS.md` for details.

## Clean Up

```bash
terraform destroy
```
