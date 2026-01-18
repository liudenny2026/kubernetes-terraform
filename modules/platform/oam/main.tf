# Open Application Model (OAM) Module - Main Configuration
# Using Crossplane as OAM implementation
# Naming convention: ${var.environment}-${var.naming_prefix}-plt-oam-{resource-type}

# Create OAM namespace
resource "kubernetes_namespace" "oam" {
  metadata {
    name = var.namespace
    labels = merge(
      var.tags,
      {
        "name"                          = var.namespace
        "prod-cloud-native-component"  = "oam"
        "prod-cloud-native-resource"   = "namespace"
      }
    )
  }
}

# Deploy Crossplane as OAM runtime using Helm Chart
resource "helm_release" "oam_runtime" {
  name       = "${var.environment}-${var.naming_prefix}-plt-oam-runtime"
  repository = var.crossplane_repository
  chart      = var.crossplane_chart_name
  version    = var.crossplane_chart_version
  namespace  = kubernetes_namespace.oam.metadata[0].name
  timeout    = 600

  set {
    name  = "resources.requests.cpu"
    value = var.cpu_request
  }

  set {
    name  = "resources.requests.memory"
    value = var.memory_request
  }

  set {
    name  = "resources.limits.cpu"
    value = var.cpu_limit
  }

  set {
    name  = "resources.limits.memory"
    value = var.memory_limit
  }

  set {
    name  = "args"
    value = "[--enable-external-secret-stores=false,--enable-structured-merge-diff=false]"
  }

  set {
    name  = "provider.packages[0]"
    value = var.enable_provider_kubernetes ? "xpkg.upbound.io/crossplane-contrib/provider-kubernetes:v0.12.0" : ""
  }

  set {
    name  = "configuration.packages[0]"
    value = var.enable_configuration_packages ? "xpkg.upbound.io/crossplane-contrib/config-aws-eks:v0.5.0" : ""
  }

  depends_on = [kubernetes_namespace.oam]
}

# Create sample OAM ApplicationConfiguration if enabled
resource "kubernetes_manifest" "oam_sample_appconfig" {
  count = var.enable_configuration_packages ? 1 : 0
  
  manifest = {
    apiVersion = "apiextensions.k8s.io/v1"
    kind       = "CustomResourceDefinition"
    metadata = {
      name = "applications.core.oam.dev"
    }
    spec = {
      group = "core.oam.dev"
      names = {
        kind     = "Application"
        listKind = "ApplicationList"
        plural   = "applications"
        singular = "application"
      }
      scope = "Namespaced"
      versions = [
        {
          name    = "v1alpha2"
          served  = true
          storage = true
          schema = {
            openAPIV3Schema = {
              type = "object"
              properties = {
                spec = {
                  type = "object"
                  properties = {
                    components = {
                      type = "array"
                      items = {
                        type = "object"
                        properties = {
                          name = {
                            type = "string"
                          }
                          type = {
                            type = "string"
                          }
                          properties = {
                            type = "object"
                          }
                          traits = {
                            type = "array"
                            items = {
                              type = "object"
                              properties = {
                                type = {
                                  type = "string"
                                }
                                properties = {
                                  type = "object"
                                }
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      ]
    }
  }

  depends_on = [helm_release.oam_runtime]
}