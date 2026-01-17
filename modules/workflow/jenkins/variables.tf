# ============================================================================
# Jenkins Workflow Module - Variables
# 三级架构: 资源�?- Workflow Variables
# 命名规范: ${var.environment}-${var.naming_prefix}-workflow-jenkins-{resource-type}
# ============================================================================

# 环境标识
variable "environment" {
  description = "Environment name (dev/stage/prod)"
  type        = string
  default     = "dev"
}

# 组件前缀
variable "naming_prefix" {
  description = "Naming prefix for resources"
  type        = string
  default     = "cloud-native"
}

# 命名空间
variable "namespace" {
  description = "Namespace for Jenkins deployment"
  type        = string
  default     = "jenkins"
}

# 镜像配置
variable "jenkins_image_repository" {
  description = "Jenkins image repository"
  type        = string
  default     = "jenkins/jenkins"
}

variable "jenkins_image_tag" {
  description = "Jenkins image tag"
  type        = string
  default     = "lts"
}

variable "image_pull_policy" {
  description = "Image pull policy"
  type        = string
  default     = "IfNotPresent"
}

# Helm配置
variable "jenkins_repository" {
  description = "Helm repository for Jenkins"
  type        = string
  default     = "https://charts.jenkins.io"
}

variable "jenkins_chart_name" {
  description = "Helm chart name for Jenkins"
  type        = string
  default     = "jenkins"
}

variable "jenkins_chart_version" {
  description = "Helm chart version for Jenkins"
  type        = string
  default     = "5.2.2"
}

# 服务配置
variable "service_type" {
  description = "Service type (ClusterIP, NodePort, LoadBalancer)"
  type        = string
  default     = "LoadBalancer"
}

variable "service_port" {
  description = "Service port for Jenkins UI"
  type        = number
  default     = 8080
}

variable "jnlp_port" {
  description = "JNLP port for Jenkins agents"
  type        = number
  default     = 50000
}

# 存储配置
variable "storage_size" {
  description = "Storage size for Jenkins data"
  type        = string
  default     = "50Gi"
}

variable "storage_class" {
  description = "Storage class for Jenkins data"
  type        = string
  default     = "local-path"
}

# 资源请求和限�?variable "resources_requests_cpu" {
  description = "CPU requests for Jenkins pods"
  type        = string
  default     = "500m"
}

variable "resources_requests_memory" {
  description = "Memory requests for Jenkins pods"
  type        = string
  default     = "1Gi"
}

variable "resources_limits_cpu" {
  description = "CPU limits for Jenkins pods"
  type        = string
  default     = "2000m"
}

variable "resources_limits_memory" {
  description = "Memory limits for Jenkins pods"
  type        = string
  default     = "4Gi"
}

# Jenkins配置
variable "jenkins_plugins" {
  description = "Jenkins plugins to install"
  type        = string
  default     = "kubernetes:3901.v51ca_636a_245b_,git:5.2.0,docker-workflow:2.45,workflow-aggregator:596.v8c21c963d92d,credentials-binding:642.v7b_517b_3a_380c"
}

variable "admin_user" {
  description = "Jenkins admin username"
  type        = string
  default     = "admin"
}

variable "admin_password" {
  description = "Jenkins admin password"
  type        = string
  sensitive   = true
  default     = "admin123"
}

# 安全标签
variable "tags" {
  description = "Standard tags to apply to all resources"
  type        = map(string)
  default = {
    Environment  = "dev"
    CostCenter   = "12345"
    Security     = "cloud-native"
    ManagedBy    = "terraform"
    Project      = "cloud-native-infrastructure"
  }
}
