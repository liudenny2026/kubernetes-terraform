resource "kubernetes_namespace" "wazuh" {
  metadata {
    name = var.wazuh_namespace
  }
}

resource "kubernetes_storage_class" "wazuh_elasticsearch" {
  count = var.create_storage_class ? 1 : 0
  metadata {
    name = var.storage_class_name
  }
  storage_provisioner = var.storage_provisioner
  parameters = var.storage_parameters
}

# 使用StatefulSet的volumeClaimTemplate替代单独的PVC资源
# resource "kubernetes_persistent_volume_claim" "wazuh_elasticsearch" {
#   count = var.elasticsearch_pvc_enabled ? var.elasticsearch_node_count : 0
#   
#   metadata {
#     name      = "${var.elasticsearch_cluster_name}-data-${count.index}"
#     namespace = kubernetes_namespace.wazuh.metadata[0].name
#   }

#   spec {
#     access_modes = var.pvc_access_modes

#     resources {
#       requests = {
#         storage = var.elasticsearch_storage_size
#       }
#     }

#     storage_class_name = var.create_storage_class ? kubernetes_storage_class.wazuh_elasticsearch[0].metadata[0].name : var.storage_class_name
#   }
# }

resource "kubernetes_secret" "wazuh_dashboard" {
  count = var.install_dashboard ? 1 : 0
  metadata {
    name      = "wazuh-dashboard-auth"
    namespace = kubernetes_namespace.wazuh.metadata[0].name
  }

  data = {
    "USERNAME" = var.dashboard_username
    "PASSWORD" = var.dashboard_password
  }

  type = "Opaque"
}



# Certificate generation is disabled for simplicity
# In production, use external certificate authority or manually create secrets
# resource "kubernetes_config_map" "wazuh_certs_config" { ... }
# resource "kubernetes_secret" "wazuh_certs" { ... }
# resource "kubernetes_job" "wazuh_certs_generator" { ... }

resource "kubernetes_stateful_set" "wazuh_elasticsearch" {
  count = var.install_elasticsearch ? 1 : 0
  metadata {
    name      = var.elasticsearch_cluster_name
    namespace = kubernetes_namespace.wazuh.metadata[0].name
    
    labels = {
      app = "wazuh-elasticsearch"
    }
  }

  spec {
    replicas  = var.elasticsearch_node_count
    pod_management_policy = "Parallel"

    selector {
      match_labels = {
        app = "wazuh-elasticsearch"
      }
    }

    template {
      metadata {
        labels = {
          app = "wazuh-elasticsearch"
        }
      }

      spec {
        init_container {
          name    = "configure-sysctl"
          image   = "busybox:1.31"
          command = ["sysctl", "-w", "vm.max_map_count=262144"]
          security_context {
            privileged = true
          }
        }

        container {
          name  = "elasticsearch"
          image = var.elasticsearch_image

          env {
            name  = "cluster.name"
            value = var.elasticsearch_cluster_name
          }

          env {
            name  = "node.name"
            value_from {
              field_ref {
                field_path = "metadata.name"
              }
            }
          }

          env {
            name  = "discovery.seed_hosts"
            value = var.elasticsearch_discovery_hosts
          }

          env {
            name  = "cluster.initial_master_nodes"
            value = var.elasticsearch_initial_master_nodes
          }

          env {
            name  = "ELASTIC_PASSWORD"
            value = var.elastic_user_password
          }

          env {
            name  = "bootstrap.memory_lock"
            value = "true"
          }

          env {
            name  = "ES_JAVA_OPTS"
            value = "-Xms${var.elasticsearch_heap_size} -Xmx${var.elasticsearch_heap_size}"
          }

          port {
            name           = "http"
            container_port = 9200
          }

          port {
            name           = "transport"
            container_port = 9300
          }

          volume_mount {
            name       = "elasticsearch-storage"
            mount_path = "/usr/share/elasticsearch/data"
          }

          resources {
            requests = {
              cpu    = var.elasticsearch_cpu_request
              memory = var.elasticsearch_memory_request
            }
            limits = {
              cpu    = var.elasticsearch_cpu_limit
              memory = var.elasticsearch_memory_limit
            }
          }
        }

        affinity {
          pod_anti_affinity {
            preferred_during_scheduling_ignored_during_execution {
              weight = 100
              pod_affinity_term {
                label_selector {
                  match_expressions {
                    key      = "app"
                    operator = "In"
                    values   = ["wazuh-elasticsearch"]
                  }
                }
                topology_key = "kubernetes.io/hostname"
              }
            }
          }
        }
      }
    }

    volume_claim_template {
      metadata {
        name = "elasticsearch-storage"
      }

      spec {
        access_modes = var.pvc_access_modes

        resources {
          requests = {
            storage = var.elasticsearch_storage_size
          }
        }

        storage_class_name = var.create_storage_class ? kubernetes_storage_class.wazuh_elasticsearch[0].metadata[0].name : var.storage_class_name
      }
    }

    service_name = kubernetes_service.wazuh_elasticsearch[0].metadata[0].name
  }
}

resource "kubernetes_service" "wazuh_elasticsearch" {
  count = var.install_elasticsearch ? 1 : 0
  metadata {
    name      = "${var.elasticsearch_cluster_name}-svc"
    namespace = kubernetes_namespace.wazuh.metadata[0].name
  }

  spec {
    selector = {
      app = "wazuh-elasticsearch"
    }

    port {
      name        = "http"
      port        = 9200
      target_port = 9200
    }

    port {
      name        = "transport"
      port        = 9300
      target_port = 9300
    }

    type = "ClusterIP"
  }
}



resource "kubernetes_deployment" "wazuh_indexer" {
  count = var.install_wazuh_indexer ? 1 : 0
  metadata {
    name      = "wazuh-indexer"
    namespace = kubernetes_namespace.wazuh.metadata[0].name
  }

  spec {
    replicas = var.wazuh_indexer_replicas

    selector {
      match_labels = {
        app = "wazuh-indexer"
      }
    }

    template {
      metadata {
        labels = {
          app = "wazuh-indexer"
        }
      }

      spec {
        container {
          name  = "wazuh-indexer"
          image = var.wazuh_indexer_image

          env {
            name  = "INDEXER_URL"
            value = "http://${kubernetes_service.wazuh_elasticsearch[0].metadata[0].name}:9200"
          }

          port {
            container_port = 9200
          }

          resources {
            requests = {
              cpu    = var.wazuh_indexer_cpu_request
              memory = var.wazuh_indexer_memory_request
            }
            limits = {
              cpu    = var.wazuh_indexer_cpu_limit
              memory = var.wazuh_indexer_memory_limit
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_deployment" "wazuh_dashboard" {
  count = var.install_dashboard ? 1 : 0
  metadata {
    name      = "wazuh-dashboard"
    namespace = kubernetes_namespace.wazuh.metadata[0].name
  }

  spec {
    replicas = var.wazuh_dashboard_replicas

    selector {
      match_labels = {
        app = "wazuh-dashboard"
      }
    }

    template {
      metadata {
        labels = {
          app = "wazuh-dashboard"
        }
      }

      spec {
        container {
          name  = "wazuh-dashboard"
          image = var.wazuh_dashboard_image

          env {
            name  = "DASHBOARD_USERNAME"
            value = var.dashboard_username
          }

          env {
            name  = "DASHBOARD_PASSWORD"
            value = var.dashboard_password
          }

          env {
            name  = "ELASTICSEARCH_URL"
            value = "http://${kubernetes_service.wazuh_elasticsearch[0].metadata[0].name}:9200"
          }

          port {
            container_port = 443
          }

          resources {
            requests = {
              cpu    = var.wazuh_dashboard_cpu_request
              memory = var.wazuh_dashboard_memory_request
            }
            limits = {
              cpu    = var.wazuh_dashboard_cpu_limit
              memory = var.wazuh_dashboard_memory_limit
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "wazuh_dashboard" {
  count = var.install_dashboard ? 1 : 0
  metadata {
    name      = "wazuh-dashboard-svc"
    namespace = kubernetes_namespace.wazuh.metadata[0].name
  }

  spec {
    selector = {
      app = "wazuh-dashboard"
    }

    port {
      name        = "https"
      port        = 443
      target_port = 443
    }

    type = var.dashboard_service_type
  }
}

