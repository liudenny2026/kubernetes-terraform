# Local Path Storage Multi-Environment Deployment

This repository contains the Terraform configuration for deploying Local Path Storage across multiple environments (Dev, Stage, Prod).

## Directory Structure

- `environments/dev/` - Development environment configuration
- `environments/stage/` - Staging environment configuration  
- `environments/prod/` - Production environment configuration
- `modules/local-path-storage/` - Reusable Terraform module for Local Path Storage

## Usage

To deploy to a specific environment:

```bash
cd environments/<env_name>
terraform init
terraform plan
terraform apply
```

Each environment has its own state and configuration.

### Environment Configuration

- **dev**: Development environment with default settings
- **stage**: Staging environment (copy of dev settings, can be customized)
- **prod**: Production environment (copy of dev settings, can be customized)

To customize an environment, modify the `terraform.tfvars` file in each environment directory.
