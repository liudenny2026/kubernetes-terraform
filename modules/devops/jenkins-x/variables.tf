variable "namespace" {
  description = "Jenkins X namespace"
  type        = string
  default     = "jx"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "naming_prefix" {
  description = "Naming prefix for resources"
  type        = string
  default     = "cloud-native"
}

variable "jenkins_x_version" {
  description = "Jenkins X version to deploy"
  type        = string
  default     = "3.10.134"
}

variable "jenkins_x_chart_version" {
  description = "Jenkins X Helm chart version"
  type        = string
  default     = "0.0.134"
}

variable "jenkins_x_repository" {
  description = "Jenkins X Helm repository"
  type        = string
  default     = "https://jenkins-x-charts.s3-us-west-2.amazonaws.com/"
}

variable "jenkins_x_chart_name" {
  description = "Jenkins X Helm chart name"
  type        = string
  default     = "jx3"
}

variable "domain" {
  description = "Domain for Jenkins X services"
  type        = string
  default     = "jx.example.com"
}

variable "tls_email" {
  description = "Email for TLS certificate (Let's Encrypt)"
  type        = string
  default     = "admin@example.com"
}

variable "version_stream_ref" {
  description = "Version stream reference for Jenkins X"
  type        = string
  default     = "v3.10.134"
}

variable "cluster_name" {
  description = "Name of the Kubernetes cluster"
  type        = string
  default     = "jx-cluster"
}

variable "provider" {
  description = "Kubernetes provider (aks, eks, gke, minikube)"
  type        = string
  default     = "kubernetes"
}

variable "ingress_class" {
  description = "Ingress class for Jenkins X"
  type        = string
  default     = "nginx"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "cpu_request" {
  description = "CPU request for Jenkins X components"
  type        = string
  default     = "200m"
}

variable "memory_request" {
  description = "Memory request for Jenkins X components"
  type        = string
  default     = "512Mi"
}

variable "cpu_limit" {
  description = "CPU limit for Jenkins X components"
  type        = string
  default     = "1000m"
}

variable "memory_limit" {
  description = "Memory limit for Jenkins X components"
  type        = string
  default     = "2Gi"
}

variable "enable_preview_environments" {
  description = "Enable preview environments"
  type        = bool
  default     = true
}

variable "git_owner" {
  description = "Git owner for Jenkins X pipelines"
  type        = string
  default     = "my-org"
}

variable "git_token" {
  description = "Git token for Jenkins X"
  type        = string
  default     = ""
  sensitive   = true
}