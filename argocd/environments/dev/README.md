# ArgoCD Dev Environment Deployment

This directory contains Terraform configuration for deploying ArgoCD to the development Kubernetes cluster.

## Prerequisites

- Terraform >= 1.0.0
- kubectl installed and configured
- Access to a Kubernetes cluster via ~/.kube/config

## Deployment Steps

1. **Initialize Terraform**: This will download the required providers and modules.
   ```bash
   terraform init
   ```

2. **Review Plan**: Check what resources will be created.
   ```bash
   terraform plan
   ```

3. **Apply Configuration**: Deploy ArgoCD to the cluster.
   ```bash
   terraform apply
   ```

4. **Access ArgoCD**: 
   - Port forward to access the UI:
     ```bash
     kubectl port-forward svc/argocd-server -n argocd 8080:443
     ```
   - Get initial admin password:
     ```bash
     kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
     ```
   - Open browser at https://localhost:8080

## Customization

Edit the `terraform.tfvars` file to customize your deployment:

- `kube_config_path`: Path to your kubeconfig file (default: ~/.kube/config)
- `namespace`: Namespace to deploy ArgoCD (default: argocd)
- `chart_version`: ArgoCD Helm chart version (default: 5.33.0)
- `image_repository`: Image repository to use (default: registry.cn-hangzhou.aliyuncs.com/argoproj)
- `values`: Additional Helm values for customization

## Cleanup

To remove ArgoCD from the cluster:

```bash
terraform destroy
```

## Notes

- The deployment uses Alibaba Cloud image registry by default for faster downloads in China region
- All resources are created in the specified namespace (default: argocd)
- The Helm release name is "argocd"
- Initial admin password is automatically generated and stored in a Kubernetes secret
