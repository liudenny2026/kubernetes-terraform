# Manual Steps Required

Due to network restrictions, some Kubeflow components could not be downloaded automatically.
Please manually download the following files and place them in the `manifests/` directory:

1.  **Training Operator**
    *   **URL**: `https://github.com/kubeflow/training-operator/releases/download/v1.8.0/training-operator.yaml`
    *   **Save as**: `manifests/training-operator.yaml`

2.  **Katib**
    *   **URL**: `https://github.com/kubeflow/katib/releases/download/v0.17.0/katib-standalone-operator.yaml`
    *   **Save as**: `manifests/katib-operator.yaml`

3.  **KServe Runtimes**
    *   **URL**: `https://github.com/kserve/kserve/releases/download/v0.13.0/kserve-runtimes.yaml`
    *   **Save as**: `manifests/kserve-runtimes.yaml`

4.  **Kubeflow Pipelines (KFP)**
    *   **URL**: `https://github.com/kubeflow/pipelines/releases/download/2.2.0/kfp-platform.yaml`
    *   **Save as**: `manifests/kfp-platform.yaml`

5.  **Model Registry**
    *   **URL**: `https://github.com/kubeflow/model-registry/releases/download/v0.2.0/model-registry.yaml`
    *   **Save as**: `manifests/model-registry.yaml`

## After Downloading

1.  Navigate to your environment directory: `cd environments/dev` (or prod/stage)
2.  Run `terraform plan` to verify all manifests are present
3.  Run `terraform apply` to deploy

## Currently Ready to Deploy

*   Cert Manager (Helm)
*   Istio (Helm) - Optional
*   Spark Operator (Local Chart)
*   KServe CRDs (Local Manifest)
