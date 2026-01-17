# 三级架构 - 基础设施层
# 环境配置变量

# 环境标识
variable "environment" {
  type        = string
  default     = "prod"
  description = "部署环境标识 (prod/stage/dev)"
}

# 组件前缀
variable "component_prefix" {
  type        = string
  default     = "cloud-native"
  description = "组件命名前缀"
}

# 全局安全标签
variable "global_tags" {
  type = map(string)
  default = {
    Environment = "prod"
    CostCenter  = "12345"
    Security    = "cloud-native"
    ManagedBy   = "terraform"
    Project     = "kubernetes-infra"
  }
  description = "所有资源的标准安全标签"
}

# Istio配置
variable "istio_version" {
  type        = string
  default     = "1.28.0"
  description = "Istio版本"
}

variable "istio_namespace" {
  type        = string
  default     = "istio-system"
  description = "Istio命名空间"
}

# Rook-Ceph配置
variable "rook_version" {
  type        = string
  default     = "1.14.8"
  description = "Rook-Ceph版本"
}

variable "rook_namespace" {
  type        = string
  default     = "rook-ceph"
  description = "Rook-Ceph命名空间"
}

# MinIO配置
variable "minio_version" {
  type        = string
  default     = "RELEASE.2024-05-28T15-26-55Z"
  description = "MinIO版本"
}

variable "minio_namespace" {
  type        = string
  default     = "minio"
  description = "MinIO命名空间"
}

variable "minio_storage_size" {
  type        = string
  default     = "200Gi"
  description = "MinIO存储容量"
}

# Harbor配置
variable "harbor_version" {
  type        = string
  default     = "2.10.2"
  description = "Harbor版本"
}

variable "harbor_namespace" {
  type        = string
  default     = "harbor"
  description = "Harbor命名空间"
}

variable "harbor_domain" {
  type        = string
  default     = "harbor.example.com"
  description = "Harbor访问域名"
}

# NeuVector配置
variable "neuvector_version" {
  type        = string
  default     = "5.4.5"
  description = "NeuVector版本"
}

variable "neuvector_namespace" {
  type        = string
  default     = "neuvector"
  description = "NeuVector命名空间"
}

# Falco配置
variable "falco_version" {
  type        = string
  default     = "0.38.2"
  description = "Falco版本"
}

variable "falco_namespace" {
  type        = string
  default     = "falco"
  description = "Falco命名空间"
}

# OPA配置
variable "opa_version" {
  type        = string
  default     = "1.18.0"
  description = "OPA版本"
}

variable "opa_namespace" {
  type        = string
  default     = "opa"
  description = "OPA命名空间"
}

# Kyverno配置
variable "kyverno_version" {
  type        = string
  default     = "1.12.0"
  description = "Kyverno版本"
}

variable "kyverno_namespace" {
  type        = string
  default     = "kyverno"
  description = "Kyverno命名空间"
}

# Kubeflow配置
variable "kubeflow_version" {
  type        = string
  default     = "1.8.2"
  description = "Kubeflow版本"
}

variable "kubeflow_namespace" {
  type        = string
  default     = "kubeflow"
  description = "Kubeflow命名空间"
}

# MLflow配置
variable "mlflow_version" {
  type        = string
  default     = "2.11.0"
  description = "MLflow版本"
}

variable "mlflow_namespace" {
  type        = string
  default     = "mlflow"
  description = "MLflow命名空间"
}

# GitLab配置
variable "gitlab_version" {
  type        = string
  default     = "16.11.1"
  description = "GitLab版本"
}

variable "gitlab_namespace" {
  type        = string
  default     = "gitlab"
  description = "GitLab命名空间"
}

variable "gitlab_domain" {
  type        = string
  default     = "gitlab.example.com"
  description = "GitLab访问域名"
}

# ArgoCD配置
variable "argocd_version" {
  type        = string
  default     = "2.9.3"
  description = "ArgoCD版本"
}

variable "argocd_namespace" {
  type        = string
  default     = "argocd"
  description = "ArgoCD命名空间"
}

variable "argocd_domain" {
  type        = string
  default     = "argocd.example.com"
  description = "ArgoCD访问域名"
}
