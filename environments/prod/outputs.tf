# 三级架构 - 基础设施层
# 环境配置输出

# 基础组件输出
output "etcd_endpoints" {
  value       = module.etcd.endpoints
  description = "ETCD集群端点"
}

output "api_server_endpoint" {
  value       = module.api_server.endpoint
  description = "API Server端点"
}

# 基础设施组件输出
output "istio_gateway_ip" {
  value       = module.istio.gateway_ip
  description = "Istio Gateway外部IP"
}

output "rook_ceph_dashboard_url" {
  value       = module.rook.dashboard_url
  description = "Rook-Ceph Dashboard URL"
}

output "minio_endpoint" {
  value       = module.minio.endpoint
  description = "MinIO S3端点"
}

output "minio_console_url" {
  value       = module.minio.console_url
  description = "MinIO控制台URL"
}

output "harbor_url" {
  value       = module.harbor.url
  description = "Harbor仓库URL"
}

# 安全组件输出
output "neuvector_dashboard_url" {
  value       = module.neuvector.dashboard_url
  description = "NeuVector Dashboard URL"
}

output "falco_prometheus_endpoint" {
  value       = module.falco.prometheus_endpoint
  description = "Falco Prometheus端点"
}

output "opa_gateway_endpoint" {
  value       = module.opa.gateway_endpoint
  description = "OPA Gateway端点"
}

output "kyverno_api_endpoint" {
  value       = module.kyverno.api_endpoint
  description = "Kyverno API端点"
}

# 工作流组件输出
output "kubeflow_dashboard_url" {
  value       = module.kubeflow.dashboard_url
  description = "Kubeflow Dashboard URL"
}

output "mlflow_tracking_url" {
  value       = module.mlflow.tracking_url
  description = "MLflow Tracking服务器URL"
}

output "gitlab_url" {
  value       = module.gitlab.url
  description = "GitLab URL"
}

output "argocd_url" {
  value       = module.argocd.url
  description = "ArgoCD Dashboard URL"
}

# 环境摘要输出
output "environment_summary" {
  value = {
    environment       = var.environment
    component_prefix  = var.component_prefix
    deployed_components = [
      "etcd",
      "api-server",
      "controller-manager",
      "scheduler",
      "cloud-controller-manager",
      "istio",
      "rook-ceph",
      "minio",
      "harbor",
      "neuvector",
      "falco",
      "opa",
      "kyverno",
      "kubeflow",
      "mlflow",
      "gitlab",
      "argocd"
    ]
    global_tags = var.global_tags
  }
  description = "环境部署摘要信息"
}
