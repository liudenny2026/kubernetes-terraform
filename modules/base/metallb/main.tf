# MetalLB 命名空间
resource "kubernetes_namespace_v1" "metallb" {
  metadata {
    name = var.namespace
    labels = merge({
      "app.kubernetes.io/name"       = "metallb"
      "app.kubernetes.io/instance"   = "metallb"
      "app.kubernetes.io/managed-by" = "terraform"
      "pod-security.kubernetes.io/audit"   = "privileged"
      "pod-security.kubernetes.io/enforce" = "privileged"
      "pod-security.kubernetes.io/warn"    = "privileged"
    }, var.tags)
  }
}

# MetalLB CRDs - 使用原生kubernetes_manifest资源
resource "kubernetes_manifest" "metallb_crds" {
  depends_on = [kubernetes_namespace_v1.metallb]
  
  manifest = {
    apiVersion = "apiextensions.k8s.io/v1"
    kind       = "CustomResourceDefinition"
    metadata = {
      name = "addresspools.metallb.io"
    }
    spec = {
      group = "metallb.io"
      names = {
        kind     = "AddressPool"
        plural   = "addresspools"
        singular = "addresspool"
      }
      scope = "Namespace"
      versions = [
        {
          name    = "v1beta1"
          served  = true
          storage = true
          schema = {
            openAPIV3Schema = {
              type      = "object"
              properties = {
                spec = {
                  type      = "object"
                  properties = {
                    addresses = {
                      type = "array"
                      items = {
                        type = "string"
                      }
                    }
                    protocol = {
                      type = "string"
                      enum = ["layer2", "bgp"]
                    }
                    autoAssign = {
                      type = "boolean"
                    }
                    avoidBuggyIPs = {
                      type = "boolean"
                    }
                  }
                  required = ["addresses"]
                }
              }
            }
          }
        }
      ]
    }
  }
}

# MetalLB IPAddressPool CRD
resource "kubernetes_manifest" "metallb_ipaddresspool_crd" {
  depends_on = [kubernetes_namespace_v1.metallb]
  
  manifest = {
    apiVersion = "apiextensions.k8s.io/v1"
    kind       = "CustomResourceDefinition"
    metadata = {
      name = "ipaddresspools.metallb.io"
    }
    spec = {
      group = "metallb.io"
      names = {
        kind     = "IPAddressPool"
        plural   = "ipaddresspools"
        singular = "ipaddresspool"
      }
      scope = "Namespace"
      versions = [
        {
          name    = "v1beta1"
          served  = true
          storage = true
          schema = {
            openAPIV3Schema = {
              type      = "object"
              properties = {
                spec = {
                  type      = "object"
                  properties = {
                    addresses = {
                      type = "array"
                      items = {
                        type = "string"
                      }
                    }
                    autoAssign = {
                      type = "boolean"
                    }
                    avoidBuggyIPs = {
                      type = "boolean"
                    }
                    blockSize = {
                      type = "integer"
                    }
                  }
                  required = ["addresses"]
                }
              }
            }
          }
        }
      ]
    }
  }
}

# MetalLB L2Advertisement CRD
resource "kubernetes_manifest" "metallb_l2advertisement_crd" {
  depends_on = [kubernetes_namespace_v1.metallb]
  
  manifest = {
    apiVersion = "apiextensions.k8s.io/v1"
    kind       = "CustomResourceDefinition"
    metadata = {
      name = "l2advertisements.metallb.io"
    }
    spec = {
      group = "metallb.io"
      names = {
        kind     = "L2Advertisement"
        plural   = "l2advertisements"
        singular = "l2advertisement"
      }
      scope = "Namespace"
      versions = [
        {
          name    = "v1beta1"
          served  = true
          storage = true
          schema = {
            openAPIV3Schema = {
              type      = "object"
              properties = {
                spec = {
                  type      = "object"
                  properties = {
                    ipAddressPools = {
                      type = "array"
                      items = {
                        type = "string"
                      }
                    }
                    ipAddressPoolSelectors = {
                      type = "array"
                      items = {
                        type = "object"
                        properties = {
                          matchLabels = {
                            type = "object"
                            additionalProperties = {
                              type = "string"
                            }
                          }
                        }
                      }
                    }
                    interfaces = {
                      type = "array"
                      items = {
                        type = "string"
                      }
                    }
                    nodeSelectors = {
                      type = "array"
                      items = {
                        type = "object"
                        properties = {
                          matchLabels = {
                            type = "object"
                            additionalProperties = {
                              type = "string"
                            }
                          }
                          matchExpressions = {
                            type = "array"
                            items = {
                              type = "object"
                              properties = {
                                key = {
                                  type = "string"
                                }
                                operator = {
                                  type = "string"
                                }
                                values = {
                                  type = "array"
                                  items = {
                                    type = "string"
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
        }
      ]
    }
  }
}

# MetalLB BGPAdvertisement CRD - 新增BGP模式支持
resource "kubernetes_manifest" "metallb_bgpadvertisement_crd" {
  depends_on = [kubernetes_namespace_v1.metallb]
  
  manifest = {
    apiVersion = "apiextensions.k8s.io/v1"
    kind       = "CustomResourceDefinition"
    metadata = {
      name = "bgpadvertisements.metallb.io"
    }
    spec = {
      group = "metallb.io"
      names = {
        kind     = "BGPAdvertisement"
        plural   = "bgpadvertisements"
        singular = "bgpadvertisement"
      }
      scope = "Namespace"
      versions = [
        {
          name    = "v1beta1"
          served  = true
          storage = true
          schema = {
            openAPIV3Schema = {
              type      = "object"
              properties = {
                spec = {
                  type      = "object"
                  properties = {
                    ipAddressPools = {
                      type = "array"
                      items = {
                        type = "string"
                      }
                    }
                    ipAddressPoolSelectors = {
                      type = "array"
                      items = {
                        type = "object"
                        properties = {
                          matchLabels = {
                            type = "object"
                            additionalProperties = {
                              type = "string"
                            }
                          }
                        }
                      }
                    }
                    aggregationLength = {
                      type = "integer"
                    }
                    aggregationLengthV6 = {
                      type = "integer"
                    }
                    localPref = {
                      type = "integer"
                    }
                    communities = {
                      type = "array"
                      items = {
                        type = "string"
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
}

# MetalLB BGPPeer CRD - 新增BGP模式支持
resource "kubernetes_manifest" "metallb_bgppeer_crd" {
  depends_on = [kubernetes_namespace_v1.metallb]
  
  manifest = {
    apiVersion = "apiextensions.k8s.io/v1"
    kind       = "CustomResourceDefinition"
    metadata = {
      name = "bgppeers.metallb.io"
    }
    spec = {
      group = "metallb.io"
      names = {
        kind     = "BGPPeer"
        plural   = "bgppeers"
        singular = "bgppeer"
      }
      scope = "Namespace"
      versions = [
        {
          name    = "v1beta1"
          served  = true
          storage = true
          schema = {
            openAPIV3Schema = {
              type      = "object"
              properties = {
                spec = {
                  type      = "object"
                  properties = {
                    myASN = {
                      type = "integer"
                    }
                    peerASN = {
                      type = "integer"
                    }
                    peerAddress = {
                      type = "string"
                    }
                    peerPort = {
                      type = "integer"
                    }
                    holdTime = {
                      type = "string"
                    }
                    keepaliveTime = {
                      type = "string"
                    }
                    routerID = {
                      type = "string"
                    }
                    nodeSelectors = {
                      type = "array"
                      items = {
                        type = "object"
                        properties = {
                          matchLabels = {
                            type = "object"
                            additionalProperties = {
                              type = "string"
                            }
                          }
                          matchExpressions = {
                            type = "array"
                            items = {
                              type = "object"
                              properties = {
                                key = {
                                  type = "string"
                                }
                                operator = {
                                  type = "string"
                                }
                                values = {
                                  type = "array"
                                  items = {
                                    type = "string"
                                  }
                                }
                              }
                            }
                          }
                        }
                      }
                    }
                    passwordSecret = {
                      type = "object"
                      properties = {
                        name = {
                          type = "string"
                        }
                        key = {
                          type = "string"
                        }
                      }
                    }
                  }
                  required = ["myASN", "peerASN", "peerAddress"]
                }
              }
            }
          }
        }
      ]
    }
  }
}

# MetalLB ServiceAccount
resource "kubernetes_manifest" "metallb_controller_sa" {
  depends_on = [kubernetes_namespace_v1.metallb]
  
  manifest = {
    apiVersion = "v1"
    kind = "ServiceAccount"
    metadata = {
      name = "controller"
      namespace = var.namespace
      labels = {
        "app.kubernetes.io/component" = "controller"
        "app.kubernetes.io/name" = "metallb"
      }
    }
  }
}

resource "kubernetes_manifest" "metallb_speaker_sa" {
  depends_on = [kubernetes_namespace_v1.metallb]
  
  manifest = {
    apiVersion = "v1"
    kind = "ServiceAccount"
    metadata = {
      name = "speaker"
      namespace = var.namespace
      labels = {
        "app.kubernetes.io/component" = "speaker"
        "app.kubernetes.io/name" = "metallb"
      }
    }
  }
}

# MetalLB ClusterRoles and ClusterRoleBindings
resource "kubernetes_manifest" "metallb_controller_clusterrole" {
  manifest = {
    apiVersion = "rbac.authorization.k8s.io/v1"
    kind = "ClusterRole"
    metadata = {
      name = "metallb-system:controller"
      labels = {
        "app.kubernetes.io/component" = "controller"
        "app.kubernetes.io/name" = "metallb"
      }
    }
    rules = [
      {
        apiGroups = [""]
        resources = ["services", "endpoints", "pods"]
        verbs = ["get", "list", "watch"]
      },
      {
        apiGroups = ["discovery.k8s.io"]
        resources = ["endpointslices"]
        verbs = ["get", "list", "watch"]
      },
      {
        apiGroups = [" metallb.io"]
        resources = [
          "addresspools",
          "ipaddresspools",
          "l2advertisements",
          "bgpadvertisements",
          "bgppeers"
        ]
        verbs = ["get", "list", "watch", "update", "patch"]
      },
      {
        apiGroups = [" metallb.io"]
        resources = [
          "addresspools/status",
          "ipaddresspools/status",
          "l2advertisements/status",
          "bgpadvertisements/status",
          "bgppeers/status"
        ]
        verbs = ["update", "patch"]
      },
      {
        apiGroups = ["coordination.k8s.io"]
        resources = ["leases"]
        verbs = ["get", "create", "update"]
      }
    ]
  }
}

resource "kubernetes_manifest" "metallb_speaker_clusterrole" {
  manifest = {
    apiVersion = "rbac.authorization.k8s.io/v1"
    kind = "ClusterRole"
    metadata = {
      name = "metallb-system:speaker"
      labels = {
        "app.kubernetes.io/component" = "speaker"
        "app.kubernetes.io/name" = "metallb"
      }
    }
    rules = [
      {
        apiGroups = [""]
        resources = ["services", "endpoints", "pods", "nodes", "namespaces"]
        verbs = ["get", "list", "watch"]
      },
      {
        apiGroups = ["discovery.k8s.io"]
        resources = ["endpointslices"]
        verbs = ["get", "list", "watch"]
      },
      {
        apiGroups = [" metallb.io"]
        resources = [
          "addresspools",
          "ipaddresspools",
          "l2advertisements",
          "bgpadvertisements",
          "bgppeers"
        ]
        verbs = ["get", "list", "watch"]
      },
      {
        apiGroups = [""]
        resources = ["events"]
        verbs = ["create", "patch"]
      },
      {
        apiGroups = [""]
        resources = ["nodes/status"]
        verbs = ["update", "patch"]
      }
    ]
  }
}

resource "kubernetes_manifest" "metallb_controller_clusterrolebinding" {
  depends_on = [kubernetes_manifest.metallb_controller_clusterrole, kubernetes_manifest.metallb_controller_sa]
  
  manifest = {
    apiVersion = "rbac.authorization.k8s.io/v1"
    kind = "ClusterRoleBinding"
    metadata = {
      name = "metallb-system:controller"
      labels = {
        "app.kubernetes.io/component" = "controller"
        "app.kubernetes.io/name" = "metallb"
      }
    }
    roleRef = {
      apiGroup = "rbac.authorization.k8s.io"
      kind = "ClusterRole"
      name = "metallb-system:controller"
    }
    subjects = [
      {
        kind = "ServiceAccount"
        name = "controller"
        namespace = var.namespace
      }
    ]
  }
}

resource "kubernetes_manifest" "metallb_speaker_clusterrolebinding" {
  depends_on = [kubernetes_manifest.metallb_speaker_clusterrole, kubernetes_manifest.metallb_speaker_sa]
  
  manifest = {
    apiVersion = "rbac.authorization.k8s.io/v1"
    kind = "ClusterRoleBinding"
    metadata = {
      name = "metallb-system:speaker"
      labels = {
        "app.kubernetes.io/component" = "speaker"
        "app.kubernetes.io/name" = "metallb"
      }
    }
    roleRef = {
      apiGroup = "rbac.authorization.k8s.io"
      kind = "ClusterRole"
      name = "metallb-system:speaker"
    }
    subjects = [
      {
        kind = "ServiceAccount"
        name = "speaker"
        namespace = var.namespace
      }
    ]
  }
}

# MetalLB Controller Deployment
resource "kubernetes_manifest" "metallb_controller_deployment" {
  depends_on = [
    kubernetes_manifest.metallb_crds,
    kubernetes_manifest.metallb_ipaddresspool_crd,
    kubernetes_manifest.metallb_l2advertisement_crd,
    kubernetes_manifest.metallb_bgpadvertisement_crd,
    kubernetes_manifest.metallb_bgppeer_crd,
    kubernetes_manifest.metallb_controller_clusterrolebinding
  ]
  
  manifest = {
    apiVersion = "apps/v1"
    kind = "Deployment"
    metadata = {
      name = "controller"
      namespace = var.namespace
      labels = {
        "app.kubernetes.io/component" = "controller"
        "app.kubernetes.io/name" = "metallb"
      }
    }
    spec = {
      selector = {
        matchLabels = {
          "app.kubernetes.io/component" = "controller"
          "app.kubernetes.io/name" = "metallb"
        }
      }
      template = {
        metadata = {
          labels = {
            "app.kubernetes.io/component" = "controller"
            "app.kubernetes.io/name" = "metallb"
          }
        }
        spec = {
          serviceAccountName = "controller"
          containers = [
            {
              name = "controller"
              image = "quay.io/metallb/controller:${var.metallb_version}"
              args = [
                "--port=7472",
                "--metrics-bind-address=:7472"
              ]
              ports = [
                {
                  name = "monitoring"
                  containerPort = 7472
                },
                {
                  name = "webhook-server"
                  containerPort = 9443
                  protocol = "TCP"
                }
              ]
              env = [
                {
                  name = "METALLB_ML_SECRET_NAME"
                  valueFrom = {
                    secretKeyRef = {
                      name = "memberlist"
                      key = "secretkey"
                    }
                  }
                }
              ]
              volumeMounts = [
                {
                  name = "webhook-cert"
                  readOnly = true
                  mountPath = "/tmp/k8s-webhook-server/serving-certs"
                }
              ]
              livenessProbe = {
                httpGet = {
                  path = "/healthz"
                  port = "monitoring"
                }
                initialDelaySeconds = 10
                periodSeconds = 10
              }
              readinessProbe = {
                httpGet = {
                  path = "/readyz"
                  port = "monitoring"
                }
                initialDelaySeconds = 5
                periodSeconds = 10
              }
            }
          ]
          volumes = [
            {
              name = "webhook-cert"
              secret = {
                secretName = "webhook-server-cert"
              }
            }
          ]
        }
      }
    }
  }
}

# MetalLB Speaker DaemonSet
resource "kubernetes_manifest" "metallb_speaker_daemonset" {
  depends_on = [
    kubernetes_manifest.metallb_crds,
    kubernetes_manifest.metallb_ipaddresspool_crd,
    kubernetes_manifest.metallb_l2advertisement_crd,
    kubernetes_manifest.metallb_bgpadvertisement_crd,
    kubernetes_manifest.metallb_bgppeer_crd,
    kubernetes_manifest.metallb_speaker_clusterrolebinding
  ]
  
  manifest = {
    apiVersion = "apps/v1"
    kind = "DaemonSet"
    metadata = {
      name = "speaker"
      namespace = var.namespace
      labels = {
        "app.kubernetes.io/component" = "speaker"
        "app.kubernetes.io/name" = "metallb"
      }
    }
    spec = {
      selector = {
        matchLabels = {
          "app.kubernetes.io/component" = "speaker"
          "app.kubernetes.io/name" = "metallb"
        }
      }
      template = {
        metadata = {
          labels = {
            "app.kubernetes.io/component" = "speaker"
            "app.kubernetes.io/name" = "metallb"
          }
        }
        spec = {
          serviceAccountName = "speaker"
          terminationGracePeriodSeconds = 0
          hostNetwork = true
          containers = [
            {
              name = "speaker"
              image = "quay.io/metallb/speaker:${var.metallb_version}"
              args = [
                "--port=7472",
                "--metrics-bind-address=:7472"
              ]
              ports = [
                {
                  name = "monitoring"
                  containerPort = 7472
                }
              ]
              env = [
                {
                  name = "METALLB_NODE_NAME"
                  valueFrom = {
                    fieldRef = {
                      fieldPath = "spec.nodeName"
                    }
                  }
                },
                {
                  name = "METALLB_ML_BIND_ADDR"
                  valueFrom = {
                    fieldRef = {
                      fieldPath = "status.hostIP"
                    }
                  }
                },
                {
                  name = "METALLB_ML_SECRET_NAME"
                  valueFrom = {
                    secretKeyRef = {
                      name = "memberlist"
                      key = "secretkey"
                    }
                  }
                },
                {
                  name = "METALLB_ML_LABELS"
                  value = "app.kubernetes.io/name=metallb,app.kubernetes.io/component=speaker"
                },
                {
                  name = "METALLB_ML_NAMESPACE"
                  valueFrom = {
                    fieldRef = {
                      fieldPath = "metadata.namespace"
                    }
                  }
                },
                {
                  name = "METALLB_ML_PEER_LISTEN_PORT"
                  value = "7946"
                }
              ]
              securityContext = {
                capabilities = {
                  add = [
                    "NET_ADMIN",
                    "NET_RAW"
                  ]
                }
              }
              livenessProbe = {
                httpGet = {
                  path = "/healthz"
                  port = "monitoring"
                  hostIP = "127.0.0.1"
                }
                initialDelaySeconds = 10
                periodSeconds = 10
              }
              readinessProbe = {
                httpGet = {
                  path = "/readyz"
                  port = "monitoring"
                  hostIP = "127.0.0.1"
                }
                initialDelaySeconds = 5
                periodSeconds = 10
              }
            }
          ]
        }
      }
    }
  }
}

# MetalLB Webhook Service and Secret
resource "kubernetes_manifest" "metallb_webhook_service" {
  depends_on = [kubernetes_namespace_v1.metallb]
  
  manifest = {
    apiVersion = "v1"
    kind = "Service"
    metadata = {
      name = "webhook-service"
      namespace = var.namespace
      labels = {
        "app.kubernetes.io/component" = "controller"
        "app.kubernetes.io/name" = "metallb"
      }
    }
    spec = {
      selector = {
        "app.kubernetes.io/component" = "controller"
        "app.kubernetes.io/name" = "metallb"
      }
      ports = [
        {
          port = 443
          targetPort = "webhook-server"
        }
      ]
    }
  }
}

resource "kubernetes_manifest" "metallb_webhook_secret" {
  depends_on = [kubernetes_namespace_v1.metallb]
  
  manifest = {
    apiVersion = "v1"
    kind = "Secret"
    metadata = {
      name = "webhook-server-cert"
      namespace = var.namespace
      labels = {
        "app.kubernetes.io/component" = "controller"
        "app.kubernetes.io/name" = "metallb"
      }
    }
    data = {
      "tls.crt" = ""
      "tls.key" = ""
    }
    type = "kubernetes.io/tls"
  }
}

# Random password for Memberlist
resource "random_password" "memberlist_secret" {
  length  = 32
  special = true
}

# MetalLB Memberlist Secret
resource "kubernetes_manifest" "metallb_memberlist_secret" {
  depends_on = [kubernetes_namespace_v1.metallb]
  
  manifest = {
    apiVersion = "v1"
    kind = "Secret"
    metadata = {
      name = "memberlist"
      namespace = var.namespace
      labels = {
        "app.kubernetes.io/name" = "metallb"
      }
    }
    data = {
      secretkey = "${base64encode(random_password.memberlist_secret.result)}"
    }
  }
}

# MetalLB ValidatingWebhookConfiguration
resource "kubernetes_manifest" "metallb_validatingwebhookconfiguration" {
  depends_on = [kubernetes_manifest.metallb_webhook_service]
  
  manifest = {
    apiVersion = "admissionregistration.k8s.io/v1"
    kind = "ValidatingWebhookConfiguration"
    metadata = {
      name = "metallb-webhook-configuration"
      labels = {
        "app.kubernetes.io/component" = "controller"
        "app.kubernetes.io/name" = "metallb"
      }
    }
    webhooks = [
      {
        name = "ipaddresspoolvalidationwebhook.metallb.io"
        rules = [
          {
            apiGroups = ["metallb.io"]
            apiVersions = ["v1beta1"]
            operations = ["CREATE", "UPDATE"]
            resources = ["ipaddresspools"]
            scope = "Namespaced"
          }
        ]
        clientConfig = {
          service = {
            namespace = var.namespace
            name = "webhook-service"
            path = "/validate-metallb-io-v1beta1-ipaddresspool"
          }
        }
        admissionReviewVersions = ["v1"]
        sideEffects = "None"
        timeoutSeconds = 10
      },
      {
        name = "l2advertisementvalidationwebhook.metallb.io"
        rules = [
          {
            apiGroups = ["metallb.io"]
            apiVersions = ["v1beta1"]
            operations = ["CREATE", "UPDATE"]
            resources = ["l2advertisements"]
            scope = "Namespaced"
          }
        ]
        clientConfig = {
          service = {
            namespace = var.namespace
            name = "webhook-service"
            path = "/validate-metallb-io-v1beta1-l2advertisement"
          }
        }
        admissionReviewVersions = ["v1"]
        sideEffects = "None"
        timeoutSeconds = 10
      },
      {
        name = "bgpadvertisementvalidationwebhook.metallb.io"
        rules = [
          {
            apiGroups = ["metallb.io"]
            apiVersions = ["v1beta1"]
            operations = ["CREATE", "UPDATE"]
            resources = ["bgpadvertisements"]
            scope = "Namespaced"
          }
        ]
        clientConfig = {
          service = {
            namespace = var.namespace
            name = "webhook-service"
            path = "/validate-metallb-io-v1beta1-bgpadvertisement"
          }
        }
        admissionReviewVersions = ["v1"]
        sideEffects = "None"
        timeoutSeconds = 10
      },
      {
        name = "bgppeervalidationwebhook.metallb.io"
        rules = [
          {
            apiGroups = ["metallb.io"]
            apiVersions = ["v1beta1"]
            operations = ["CREATE", "UPDATE"]
            resources = ["bgppeers"]
            scope = "Namespaced"
          }
        ]
        clientConfig = {
          service = {
            namespace = var.namespace
            name = "webhook-service"
            path = "/validate-metallb-io-v1beta1-bgppeer"
          }
        }
        admissionReviewVersions = ["v1"]
        sideEffects = "None"
        timeoutSeconds = 10
      }
    ]
  }
}

# Configure kube-proxy strictARP for L2 mode if needed - 使用原生kubernetes_manifest资源
resource "kubernetes_manifest" "kube_proxy_config" {
  count = var.configure_kube_proxy ? 1 : 0
  depends_on = [
    kubernetes_manifest.metallb_controller_deployment,
    kubernetes_manifest.metallb_speaker_daemonset
  ]
  
  manifest = {
    apiVersion = "v1"
    kind = "ConfigMap"
    metadata = {
      name = "kube-proxy"
      namespace = "kube-system"
    }
    data = {
      "config.conf" = <<-EOF
        apiVersion: kubeproxy.config.k8s.io/v1alpha1
        kind: KubeProxyConfiguration
        ipvs:
          strictARP: ${var.kube_proxy_strict_arp}
      EOF
    }
  }
}

# MetalLB IPAddressPools - 支持多IP池管理
resource "kubernetes_manifest" "ip_address_pools" {
  for_each = { for pool in var.ip_address_pools : pool.name => pool }
  depends_on = [
    kubernetes_manifest.metallb_controller_deployment,
    kubernetes_manifest.metallb_speaker_daemonset
  ]

  manifest = {
    apiVersion = "metallb.io/v1beta1"
    kind       = "IPAddressPool"
    metadata = {
      name      = each.value.name
      namespace = var.namespace
      labels = merge({
        "metallb.io/pool" = each.value.name
      }, var.tags)
    }
    spec = {
      addresses = each.value.addresses
      autoAssign = try(each.value.auto_assign, true)
      avoidBuggyIPs = try(each.value.avoid_buggy_ips, false)
      blockSize = try(each.value.block_size, 24)
    }
  }

  # Wait for webhook to be ready
  timeouts {
    create = "5m"
    update = "5m"
  }
}

# MetalLB L2Advertisements - 高级L2广告配置
resource "kubernetes_manifest" "l2_advertisements" {
  for_each = { for adv in var.l2_advertisements : adv.name => adv }
  depends_on = [
    kubernetes_manifest.ip_address_pools,
    kubernetes_manifest.metallb_controller_deployment,
    kubernetes_manifest.metallb_speaker_daemonset
  ]

  manifest = {
    apiVersion = "metallb.io/v1beta1"
    kind       = "L2Advertisement"
    metadata = {
      name      = each.value.name
      namespace = var.namespace
      labels = merge({
        "metallb.io/advertisement" = each.value.name
      }, var.tags)
    }
    spec = {
      ipAddressPools = try(each.value.ip_address_pools, [])
      ipAddressPoolSelectors = try(each.value.ip_address_pool_selectors, [])
      interfaces = try(each.value.interfaces, [])
      nodeSelectors = try(each.value.node_selectors, [])
    }
  }
}

# MetalLB BGP Peers - BGP模式支持
resource "kubernetes_manifest" "bgp_peers" {
  for_each = { for peer in var.bgp_peers : peer.name => peer }
  depends_on = [
    kubernetes_manifest.metallb_controller_deployment,
    kubernetes_manifest.metallb_speaker_daemonset
  ]

  manifest = {
    apiVersion = "metallb.io/v1beta1"
    kind       = "BGPPeer"
    metadata = {
      name      = each.value.name
      namespace = var.namespace
      labels = merge({
        "metallb.io/bgppeer" = each.value.name
      }, var.tags)
    }
    spec = {
      myASN = each.value.my_asn
      peerASN = each.value.peer_asn
      peerAddress = each.value.peer_address
      peerPort = try(each.value.peer_port, 179)
      holdTime = try(each.value.hold_time, "10s")
      keepaliveTime = try(each.value.keepalive_time, "30s")
      routerID = try(each.value.router_id, null)
      nodeSelectors = try(each.value.node_selectors, [])
      passwordSecret = try(each.value.password_secret, null)
    }
  }
}

# MetalLB BGP Advertisements - BGP广告配置
resource "kubernetes_manifest" "bgp_advertisements" {
  for_each = { for adv in var.bgp_advertisements : adv.name => adv }
  depends_on = [
    kubernetes_manifest.ip_address_pools,
    kubernetes_manifest.bgp_peers,
    kubernetes_manifest.metallb_controller_deployment,
    kubernetes_manifest.metallb_speaker_daemonset
  ]

  manifest = {
    apiVersion = "metallb.io/v1beta1"
    kind       = "BGPAdvertisement"
    metadata = {
      name      = each.value.name
      namespace = var.namespace
      labels = merge({
        "metallb.io/bgpadvertisement" = each.value.name
      }, var.tags)
    }
    spec = {
      ipAddressPools = try(each.value.ip_address_pools, [])
      ipAddressPoolSelectors = try(each.value.ip_address_pool_selectors, [])
      aggregationLength = try(each.value.aggregation_length, 32)
      aggregationLengthV6 = try(each.value.aggregation_length_v6, 128)
      localPref = try(each.value.local_pref, null)
      communities = try(each.value.communities, [])
    }
  }
}
