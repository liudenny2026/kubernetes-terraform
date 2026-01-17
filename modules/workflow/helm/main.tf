# ============================================================================
# Helm Workflow Module - Main Configuration
# 三级架构: 资源�?- Workflow Deployment/Service
# 命名规范: ${var.environment}-${var.naming_prefix}-workflow-helm-{resource-type}
# ============================================================================

# 注意：现代Helm不再需要Tiller服务端，此模块主要提供Helm客户端配置和示例
# 创建示例命名空间
resource "kubernetes_namespace" "helm_example" {
  metadata {
    name = "${var.environment}-${var.naming_prefix}-helm-example"
    labels = merge(
      var.tags,
      {
        "name"                          = "${var.environment}-${var.naming_prefix}-helm-example"
        "prod-cloud-native-component"  = "helm"
        "prod-cloud-native-resource"   = "namespace"
      }
    )
  }
}

# 创建示例ConfigMap用于存储Helm仓库配置
resource "kubernetes_config_map" "helm_repos" {
  metadata {
    name      = "${var.environment}-${var.naming_prefix}-workflow-helm-repos"
    namespace = kubernetes_namespace.helm_example.metadata[0].name
    labels = merge(
      var.tags,
      {
        "prod-cloud-native-component"  = "helm"
        "prod-cloud-native-resource"   = "configmap"
      }
    )
  }

  data = {
    "repositories.yaml" = <<EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: ${var.environment}-${var.naming_prefix}-workflow-helm-repos
  namespace: ${kubernetes_namespace.helm_example.metadata[0].name}
data:
  repositories.yaml: |
    repositories:
      - name: stable
        url: https://charts.helm.sh/stable
      - name: bitnami
        url: https://charts.bitnami.com/bitnami
      - name: prometheus-community
        url: https://prometheus-community.github.io/helm-charts
      - name: grafana
        url: https://grafana.github.io/helm-charts
EOF
  }
}

# 创建示例Helm Release（使用Helm provider部署示例应用�?resource "helm_release" "helm_example_app" {
  name       = "${var.environment}-${var.naming_prefix}-helm-example-nginx"
  namespace  = kubernetes_namespace.helm_example.metadata[0].name
  repository = "bitnami"
  chart      = "nginx"
  version    = var.nginx_chart_version
  timeout    = 300

  set {
    name  = "image.repository"
    value = var.nginx_image_repository
  }

  set {
    name  = "image.tag"
    value = var.nginx_image_tag
  }

  set {
    name  = "service.type"
    value = var.nginx_service_type
  }

  depends_on = [
    kubernetes_namespace.helm_example
  ]
}
