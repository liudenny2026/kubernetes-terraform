# Kubeflow Module Variables

variable "kube_config_path" {
  description = "Path to the kubeconfig file"
  type        = string
  default     = null
}

variable "kubeflow_version" {
  description = "Target Kubeflow version for reference"
  type        = string
  default     = "1.9.1"
}

# Component Versions (Aligned with Kubeflow 1.9)
variable "istio_version" {
  description = "Istio version to deploy"
  type        = string
  default     = "1.28.0"
}

variable "deploy_istio" {
  description = "Whether to deploy Istio using Terraform. Set to false if Istio is already installed."
  type        = bool
  default     = false
}

variable "cert_manager_version" {
  description = "Cert-Manager version"
  type        = string
  default     = "v1.16.1"
}

variable "kserve_version" {
  description = "KServe version (for reference)"
  type        = string
  default     = "v0.13.0"
}

variable "katib_version" {
  description = "Katib version (for reference)"
  type        = string
  default     = "0.16.0"
}

variable "training_operator_version" {
  description = "Training Operator version (for reference)"
  type        = string
  default     = "1.8.1"
}

variable "spark_operator_version" {
  description = "Spark Operator version (for reference)"
  type        = string
  default     = "2.4.0"
}

variable "spark_operator_chart" {
  description = "Path to the Spark Operator chart file"
  type        = string
  default     = "./manifests/spark-operator.tgz"
}

variable "kfp_version" {
  description = "Kubeflow Pipelines version (for reference)"
  type        = string
  default     = "2.3.0"
}

variable "model_registry_version" {
  description = "Model Registry version (for reference)"
  type        = string
  default     = "v0.2.9"
}

# Manifest Paths
variable "training_operator_manifest" {
  description = "Path to the Training Operator manifest file"
  type        = string
  default     = "./manifests/training-operator.yaml"
}

variable "katib_manifest" {
  description = "Path to the Katib manifest file"
  type        = string
  default     = "./manifests/katib-operator.yaml"
}

variable "kserve_manifest" {
  description = "Path to the KServe CRD manifest file"
  type        = string
  default     = "./manifests/kserve.yaml"
}

variable "kserve_runtimes_manifest" {
  description = "Path to the KServe Runtimes manifest file"
  type        = string
  default     = "./manifests/kserve-runtimes.yaml"
}

variable "kfp_manifest" {
  description = "Path to the Kubeflow Pipelines manifest file"
  type        = string
  default     = "./manifests/kfp.yaml"
}

variable "model_registry_manifest" {
  description = "Path to the Model Registry manifest file"
  type        = string
  default     = "./manifests/model-registry.yaml"
}
