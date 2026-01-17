# Kubeflow Module Variables

# ---------------------------------------------------------------------------
# Core Configuration Variables
# ---------------------------------------------------------------------------

variable "kube_config_path" {
  description = "Path to the kubeconfig file for connecting to Kubernetes cluster"
  type        = string
  default     = null
}

variable "kubeflow_version" {
  description = "Target Kubeflow version for deployment"
  type        = string
  default     = "1.9.1"
}

# ---------------------------------------------------------------------------
# Component Version References (Aligned with Kubeflow 1.9)
# These are for reference only and not used in actual deployment
# ---------------------------------------------------------------------------
# Istio and Cert Manager should be deployed separately
# - Istio recommended: 1.18.x
# - Cert-Manager recommended: v1.16.x
#
# Core Components:
# - KServe: v0.13.0
# - Katib: 0.16.0
# - Training Operator: 1.8.1
# - Spark Operator: 2.4.0
# - Kubeflow Pipelines: 2.3.0
# - Model Registry: v0.2.9
# - Jupyter Web App: v1.9.0
# - Central Dashboard: v1.9.0
# - Dex Authentication: v2.37.0
# - Profile Controller: v1.9.0
# ---------------------------------------------------------------------------

# ---------------------------------------------------------------------------
# Manifest File Paths
# ---------------------------------------------------------------------------

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

variable "jupyter_web_app_manifest" {
  description = "Path to the Jupyter Web App manifest file"
  type        = string
  default     = "./manifests/jupyter-web-app.yaml"
}

variable "centraldashboard_manifest" {
  description = "Path to the Central Dashboard manifest file"
  type        = string
  default     = "./manifests/centraldashboard.yaml"
}

variable "dex_manifest" {
  description = "Path to the Dex Authentication manifest file"
  type        = string
  default     = "./manifests/dex.yaml"
}

variable "profile_controller_manifest" {
  description = "Path to the Profile Controller manifest file"
  type        = string
  default     = "./manifests/profile-controller.yaml"
}
