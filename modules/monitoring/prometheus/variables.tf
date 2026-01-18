# ============================================================================
# Prometheus & Grafana Module - Variables
# 三级架构: 资源�?- Monitoring Variables
# 命名规范: ${var.environment}-${var.naming_prefix}-infra-prometheus-{resource-type}
# ============================================================================

# 环境标识
variable "environment" {
  description = "Environment name (dev/stage/prod)"
  type        = string
  default     = "prod"
}

# 组件前缀
variable "naming_prefix" {
  description = "Naming prefix for resources"
  type        = string
  default     = "cloud-native"
}

# 命名空间
variable "namespace" {
  description = "Namespace for monitoring stack"
  type        = string
  default     = "monitoring"
}

# Prometheus仓库地址
variable "prometheus_repository" {
  description = "Helm repository for Prometheus (Alibaba Cloud for China network)"
  type        = string
  default     = "https://aliacs-app-catalog.oss-cn-hangzhou.aliyuncs.com/charts-incubator/"
}

# Prometheus图表名称
variable "prometheus_chart_name" {
  description = "Helm chart name for Prometheus stack (ack-prometheus-operator)"
  type        = string
  default     = "ack-prometheus-operator"
}

# Prometheus图表版本
variable "prometheus_chart_version" {
  description = "Prometheus chart version"
  type        = string
  default     = "71.2.2"
}

# Grafana仓库地址
variable "grafana_repository" {
  description = "Helm repository for Grafana"
  type        = string
  default     = "https://grafana.github.io/helm-charts"
}

# Grafana图表版本
variable "grafana_chart_version" {
  description = "Grafana chart version"
  type        = string
  default     = "11.4.1"
}

# 存储�?variable "storage_class" {
  description = "Storage class for persistent storage"
  type        = string
  default     = "local-path"
}

# 容器镜像仓库镜像
variable "registry_mirror" {
  description = "Container registry mirror for China"
  type        = string
  default     = ""
}

# Prometheus存储大小
variable "prometheus_storage_size" {
  description = "Storage size for Prometheus"
  type        = string
  default     = "50Gi"
}

# Prometheus CPU请求
variable "prometheus_cpu_request" {
  description = "CPU request for Prometheus"
  type        = string
  default = '1000m'
}

# Prometheus内存请求
variable "prometheus_memory_request" {
  description = "Memory request for Prometheus"
  type        = string
  default = '4Gi'
}

# Prometheus CPU限制
variable "prometheus_cpu_limit" {
  description = "CPU limit for Prometheus"
  type        = string
  default = '2000m'
}

# Prometheus内存限制
variable "prometheus_memory_limit" {
  description = "Memory limit for Prometheus"
  type        = string
  default = '8Gi'
}

# Grafana存储大小
variable "grafana_storage_size" {
  description = "Storage size for Grafana"
  type        = string
  default     = "10Gi"
}

# Grafana管理员用�?variable "grafana_admin_user" {
  description = "Grafana admin username"
  type        = string
  default     = "admin"
}

# Grafana管理员密�?variable "grafana_admin_password" {
  description = "Grafana admin password"
  type        = string
  sensitive   = true
  default     = "prom-operator"
}

# Grafana服务类型
variable "grafana_service_type" {
  description = "Service type for Grafana (ClusterIP, NodePort, LoadBalancer)"
  type        = string
  default     = "LoadBalancer"
}

# Alertmanager存储大小
variable "alertmanager_storage_size" {
  description = "Storage size for Alertmanager"
  type        = string
  default     = "10Gi"
}

# 是否启用Istio监控
variable "enable_istio_monitoring" {
  description = "Enable Istio monitoring"
  type        = bool
  default     = true
}

# 是否启用Ceph监控
variable "enable_ceph_monitoring" {
  description = "Enable Ceph monitoring"
  type        = bool
  default     = true
}

# 是否启用MetalLB监控
variable "enable_metallb_monitoring" {
  description = "Enable MetalLB monitoring"
  type        = bool
  default     = true
}

# 是否启用Kubeflow监控
variable "enable_kubeflow_monitoring" {
  description = "Enable Kubeflow monitoring"
  type        = bool
  default     = true
}

# 是否启用MLflow监控
variable "enable_mlflow_monitoring" {
  description = "Enable MLflow monitoring"
  type        = bool
  default     = true
}

# 是否启用MinIO监控
variable "enable_minio_monitoring" {
  description = "Enable MinIO monitoring"
  type        = bool
  default     = true
}

# 安全标签
variable "tags" {
  description = "Standard tags to apply to all resources"
  type        = map(string)
  default = {
    Environment  = "prod"
    CostCenter   = "12345"
    Security     = "cloud-native"
    ManagedBy    = "terraform"
    Project      = "kubernetes-infra"
  }
}
