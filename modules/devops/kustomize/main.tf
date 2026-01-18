# ============================================================================
# Kustomize Workflow Module - Main Configuration
# 三级架构: 资源�?- Workflow Configuration
# 命名规范: ${var.environment}-${var.naming_prefix}-workflow-kustomize-{resource-type}
# ============================================================================

# 注意：Kustomize是命令行工具，不需要部署服务。此模块提供Kustomize配置示例�?# 创建示例命名空间
resource "kubernetes_namespace" "kustomize_example" {
  metadata {
    name = "${var.environment}-${var.naming_prefix}-kustomize-example"
    labels = merge(
      var.tags,
      {
        "name"                          = "${var.environment}-${var.naming_prefix}-kustomize-example"
        "prod-cloud-native-component"  = "kustomize"
        "prod-cloud-native-resource"   = "namespace"
      }
    )
  }
}

# 创建ConfigMap存储Kustomize基础配置示例
resource "kubernetes_config_map" "kustomize_base" {
  metadata {
    name      = "${var.environment}-${var.naming_prefix}-workflow-kustomize-base"
    namespace = kubernetes_namespace.kustomize_example.metadata[0].name
    labels = merge(
      var.tags,
      {
        "prod-cloud-native-component"  = "kustomize"
        "prod-cloud-native-resource"   = "configmap"
      }
    )
  }

  data = {
    "kustomization.yaml" = <<EOF
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
metadata:
  name: base

resources:
  - deployment.yaml
  - service.yaml

commonLabels:
  app: nginx
  environment: ${var.environment}
  managed-by: kustomize
EOF
    "deployment.yaml" = <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: ${var.nginx_image_repository}:${var.nginx_image_tag}
        ports:
        - containerPort: 80
        resources:
          requests:
            memory: "64Mi"
            cpu: "250m"
          limits:
            memory: "128Mi"
            cpu: "500m"
EOF
    "service.yaml" = <<EOF
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  selector:
    app: nginx
  ports:
  - port: 80
    targetPort: 80
  type: ClusterIP
EOF
  }
}

# 创建ConfigMap存储Kustomize覆盖配置示例（开发环境）
resource "kubernetes_config_map" "kustomize_dev_overlay" {
  metadata {
    name      = "${var.environment}-${var.naming_prefix}-workflow-kustomize-dev-overlay"
    namespace = kubernetes_namespace.kustomize_example.metadata[0].name
    labels = merge(
      var.tags,
      {
        "prod-cloud-native-component"  = "kustomize"
        "prod-cloud-native-resource"   = "configmap"
      }
    )
  }

  data = {
    "kustomization.yaml" = <<EOF
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
metadata:
  name: dev

bases:
  - ../base

patchesStrategicMerge:
  - deployment-patch.yaml

patchesJson6902:
- target:
    version: v1
    kind: Service
    name: nginx-service
  patch: |-
    - op: replace
      path: /spec/type
      value: NodePort

commonAnnotations:
  environment: dev
  deployment-date: "2026-01-17"
EOF
    "deployment-patch.yaml" = <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  replicas: 2  # 开发环境减少副本数
  template:
    spec:
      containers:
      - name: nginx
        resources:
          requests:
            memory: "32Mi"  # 开发环境减少资源请�?            cpu: "100m"
          limits:
            memory: "64Mi"  # 开发环境减少资源限�?            cpu: "250m"
EOF
  }
}

# 创建ConfigMap存储Kustomize覆盖配置示例（生产环境）
resource "kubernetes_config_map" "kustomize_prod_overlay" {
  metadata {
    name      = "${var.environment}-${var.naming_prefix}-workflow-kustomize-prod-overlay"
    namespace = kubernetes_namespace.kustomize_example.metadata[0].name
    labels = merge(
      var.tags,
      {
        "prod-cloud-native-component"  = "kustomize"
        "prod-cloud-native-resource"   = "configmap"
      }
    )
  }

  data = {
    "kustomization.yaml" = <<EOF
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
metadata:
  name: prod

bases:
  - ../base

patchesStrategicMerge:
  - deployment-patch.yaml

commonAnnotations:
  environment: prod
  criticality: high
EOF
    "deployment-patch.yaml" = <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  replicas: 5  # 生产环境增加副本�?  template:
    spec:
      containers:
      - name: nginx
        resources:
          requests:
            memory: "128Mi"  # 生产环境增加资源请求
            cpu: "500m"
          limits:
            memory: "256Mi"  # 生产环境增加资源限制
            cpu: "1000m"
EOF
  }
}
