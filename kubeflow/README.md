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

- Kubernetes cluster (1.25+)
- kubectl configured
- Terraform 1.5.0+
- Helm 3.x

### Dev Environment

```bash
cd environments/dev
terraform init
terraform plan
terraform apply
```

### Other Environments

```bash
cd environments/prod
terraform init
terraform plan
terraform apply
```

## Components

The following Kubeflow components are deployed:

1. **Cert-Manager** - Certificate management
2. **Istio** (optional) - Service mesh
3. **Spark Operator** - Apache Spark job management
4. **Training Operator** - Distributed training (TFJob, PyTorchJob, etc.)
5. **Katib** - Hyperparameter tuning
6. **KServe** - Model serving
7. **Kubeflow Pipelines** - ML workflow orchestration
8. **Model Registry** - Model versioning

## Configuration

Edit `environments/*/terraform.tfvars` to customize your deployment:

```hcl
kube_config_path     = "~/.kube/config"
kubeflow_version     = "1.9.1"
deploy_istio         = false
cert_manager_version = "v1.16.1"
```

## Manual Steps

Some Kubeflow components require manual download. See `MANUAL_STEPS.md` for details.

## Clean Up

```bash
terraform destroy
```
