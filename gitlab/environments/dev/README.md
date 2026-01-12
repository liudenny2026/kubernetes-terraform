# GitLab 18.6 Deployment with Terraform

This Terraform configuration deploys GitLab 18.6 to a Kubernetes cluster using the specified storage classes and service configuration.

## Prerequisites

- Terraform >= 1.0
- Kubernetes cluster with kubectl configured to connect via `~/.kube/config`
- Available storage classes:
  - `local-path` (default)
  - `minio-sc`
  - `rook-ceph-blockstorage`

## Configuration

The deployment uses the following defaults:

- GitLab Version: 18.6.0
- Namespace: gitlab
- Storage Class: local-path
- PVC Size: 8Gi
- Service Type: LoadBalancer
- Replica Count: 1
- Use Private Registry: true
- Private Registry URL: 192.168.40.248/library

## Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `gitlab_version` | GitLab version to deploy | 18.6.0 |
| `namespace` | Kubernetes namespace for deployment | gitlab |
| `storage_class` | Storage class for persistent volumes | local-path |
| `pvc_size` | Size of persistent volume claim | 8Gi |
| `service_type` | Service type to expose GitLab | LoadBalancer |
| `gitlab_admin_password` | Password for GitLab admin user | - |
| `gitlab_initial_root_password` | Initial root password for GitLab | - |
| `gitlab_replica_count` | Number of GitLab pod replicas | 1 |
| `use_private_registry` | Whether to use private registry for images | true |
| `private_registry_url` | Private registry URL for pulling images | 192.168.40.248/library |

## Deployment Steps

1. Update the `terraform.tfvars` file with your desired configuration and passwords:

```bash
gitlab_version = "18.6.0"
namespace = "gitlab"
storage_class = "local-path" # Options: local-path, minio-sc, rook-ceph-blockstorage
pvc_size = "8Gi"
service_type = "LoadBalancer"
gitlab_admin_password = "your-secure-admin-password"
gitlab_initial_root_password = "your-secure-root-password"
gitlab_replica_count = 1
```

2. Initialize Terraform:

```bash
terraform init
```

3. Review the execution plan:

```bash
terraform plan
```

4. Deploy GitLab:

```bash
terraform apply
```

5. Once deployment is complete, check the output for the external IP address of the LoadBalancer service.

## Accessing GitLab

After deployment, you can access GitLab using:

- External IP: Use the IP address shown in the Terraform output
- Internal Cluster: http://gitlab.gitlab.svc.cluster.local

The initial root password can be found in the secret created by this configuration.

## Storage Classes

This configuration supports three storage classes:

- `local-path`: Rancher local path provisioner
- `minio-sc`: Local volume provisioner for MinIO
- `rook-ceph-blockstorage`: Rook Ceph block storage (recommended)

## Service Configuration

The configuration creates a LoadBalancer service by default, which will provision an external load balancer through your cloud provider. The service exposes ports:

- Port 80 (HTTP)
- Port 443 (HTTPS)
- Port 22 (SSH)

## Cleanup

To remove the GitLab deployment:

```bash
terraform destroy
```