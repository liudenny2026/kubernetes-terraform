terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = ">= 2.0"
    }
    null = {
      source = "hashicorp/null"
      version = ">= 3.0"
    }
    local = {
      source = "hashicorp/local"
      version = ">= 2.0"
    }
    random = {
      source = "hashicorp/random"
      version = ">= 3.0"
    }
  }
}

# Ceph cluster module

# Create node configuration for cluster template
locals {
  node_list = [for node_name in var.node_names : {
    name = node_name
    devices = [for device in var.storage_devices : {
      name = device
    }]
  }]
}

# Generate random password for dashboard
resource "random_password" "dashboard_password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

# Apply Ceph cluster configuration
resource "null_resource" "ceph_cluster" {
  triggers = {
    cluster_config = "${var.cluster_name}-${var.namespace}"
  }

  provisioner "local-exec" {
    command = "kubectl apply -f ${local_file.ceph_cluster_yaml.filename}"
  }

  depends_on = [
    local_file.ceph_cluster_yaml
  ]
}

# Create temporary YAML file for Ceph cluster
resource "local_file" "ceph_cluster_yaml" {
  content = templatefile("${path.module}/templates/cluster.yaml", {
    namespace     = var.namespace
    cluster_name  = var.cluster_name
    monitor_count = var.monitor_count
    node_list     = local.node_list
  })
  filename = "${path.module}/.temp-ceph-cluster-${var.namespace}.yaml"
  file_permission = "0644"
}

# Create dashboard secret
resource "kubernetes_secret" "dashboard" {
  metadata {
    name      = "rook-ceph-dashboard-password"
    namespace = var.namespace
  }

  type = "kubernetes.io/rook"

  data = {
    password = random_password.dashboard_password.result
    username = "admin"
  }

  depends_on = [null_resource.ceph_cluster]
}

# Apply LoadBalancer for dashboard if enabled
resource "kubernetes_service" "dashboard_lb" {
  count = var.enable_dashboard && var.dashboard_loadbalancer_enabled ? 1 : 0

  metadata {
    name      = "rook-ceph-mgr-dashboard-lb"
    namespace = var.namespace
  }

  spec {
    selector = {
      app   = "rook-ceph-mgr"
      rook_cluster = var.cluster_name
    }

    port {
      name        = "dashboard"
      port        = 8443
      target_port = 8443
      protocol    = "TCP"
    }

    type = "LoadBalancer"

    dynamic "load_balancer_ip_mode" {
      for_each = var.dashboard_loadbalancer_ip_mode != "" ? [1] : []
      content {
        mode = var.dashboard_loadbalancer_ip_mode
      }
    }
  }

  depends_on = [null_resource.ceph_cluster]
}

# Apply Ceph block storage configuration
resource "null_resource" "ceph_block_storage" {
  triggers = {
    block_storage_config = "${var.cluster_name}-${var.namespace}"
  }

  provisioner "local-exec" {
    command = "kubectl apply -f ${local_file.ceph_block_storage_yaml.filename}"
  }

  depends_on = [null_resource.ceph_cluster, local_file.ceph_block_storage_yaml]
}

# Create temporary YAML file for Ceph block storage
resource "local_file" "ceph_block_storage_yaml" {
  content = templatefile("${path.module}/templates/block-storage.yaml", {
    namespace    = var.namespace
    cluster_name = var.cluster_name
  })
  filename = "${path.module}/.temp-ceph-block-storage-${var.namespace}.yaml"
  file_permission = "0644"

  depends_on = [null_resource.ceph_cluster]
}

# Apply LoadBalancer for dashboard if enabled
resource "kubernetes_service" "dashboard_lb" {
  count = var.enable_dashboard && var.dashboard_loadbalancer_enabled ? 1 : 0

  metadata {
    name      = "rook-ceph-mgr-dashboard-lb"
    namespace = var.namespace
  }

  spec {
    selector = {
      app   = "rook-ceph-mgr"
      rook_cluster = var.cluster_name
    }

    port {
      name        = "dashboard"
      port        = 8443
      target_port = 8443
      protocol    = "TCP"
    }

    type = "LoadBalancer"

    dynamic "load_balancer_ip_mode" {
      for_each = var.dashboard_loadbalancer_ip_mode != "" ? [1] : []
      content {
        mode = var.dashboard_loadbalancer_ip_mode
      }
    }
  }

  depends_on = [null_resource.ceph_cluster]
}

# Apply Ceph filesystem configuration
resource "null_resource" "ceph_filesystem" {
  triggers = {
    filesystem_config = "${var.cluster_name}-${var.namespace}"
  }

  provisioner "local-exec" {
    command = "kubectl apply -f ${local_file.ceph_filesystem_yaml.filename}"
  }

  depends_on = [null_resource.ceph_cluster, local_file.ceph_filesystem_yaml]
}

# Create temporary YAML file for Ceph filesystem
resource "local_file" "ceph_filesystem_yaml" {
  content = templatefile("${path.module}/templates/filesystem.yaml", {
    namespace    = var.namespace
    cluster_name = var.cluster_name
  })
  filename = "${path.module}/.temp-ceph-filesystem-${var.namespace}.yaml"
  file_permission = "0644"

  depends_on = [null_resource.ceph_cluster]
}

# Apply LoadBalancer for dashboard if enabled
resource "kubernetes_service" "dashboard_lb" {
  count = var.enable_dashboard && var.dashboard_loadbalancer_enabled ? 1 : 0

  metadata {
    name      = "rook-ceph-mgr-dashboard-lb"
    namespace = var.namespace
  }

  spec {
    selector = {
      app   = "rook-ceph-mgr"
      rook_cluster = var.cluster_name
    }

    port {
      name        = "dashboard"
      port        = 8443
      target_port = 8443
      protocol    = "TCP"
    }

    type = "LoadBalancer"

    dynamic "load_balancer_ip_mode" {
      for_each = var.dashboard_loadbalancer_ip_mode != "" ? [1] : []
      content {
        mode = var.dashboard_loadbalancer_ip_mode
      }
    }
  }

  depends_on = [null_resource.ceph_cluster]
}

# Apply Ceph object store configuration
resource "null_resource" "ceph_object_store" {
  triggers = {
    object_store_config = "${var.cluster_name}-${var.namespace}"
  }

  provisioner "local-exec" {
    command = "kubectl apply -f ${local_file.ceph_object_store_yaml.filename}"
  }

  depends_on = [null_resource.ceph_cluster, local_file.ceph_object_store_yaml]
}

# Create temporary YAML file for Ceph object store
resource "local_file" "ceph_object_store_yaml" {
  content = templatefile("${path.module}/templates/object-store.yaml", {
    namespace    = var.namespace
    cluster_name = var.cluster_name
  })
  filename = "${path.module}/.temp-ceph-object-store-${var.namespace}.yaml"
  file_permission = "0644"

  depends_on = [null_resource.ceph_cluster]
}

# Apply LoadBalancer for dashboard if enabled
resource "kubernetes_service" "dashboard_lb" {
  count = var.enable_dashboard && var.dashboard_loadbalancer_enabled ? 1 : 0

  metadata {
    name      = "rook-ceph-mgr-dashboard-lb"
    namespace = var.namespace
  }

  spec {
    selector = {
      app   = "rook-ceph-mgr"
      rook_cluster = var.cluster_name
    }

    port {
      name        = "dashboard"
      port        = 8443
      target_port = 8443
      protocol    = "TCP"
    }

    type = "LoadBalancer"

    dynamic "load_balancer_ip_mode" {
      for_each = var.dashboard_loadbalancer_ip_mode != "" ? [1] : []
      content {
        mode = var.dashboard_loadbalancer_ip_mode
      }
    }
  }

  depends_on = [null_resource.ceph_cluster]
}

# Create Ingress for dashboard if enabled
resource "null_resource" "ceph_dashboard_ingress" {
  count = var.ingress_enabled ? 1 : 0

  triggers = {
    ingress_config = "${var.cluster_name}-${var.ingress_host}"
  }

  provisioner "local-exec" {
    command = "kubectl apply -f ${local_file.ceph_ingress_yaml[0].filename}"
  }

  depends_on = [null_resource.ceph_cluster, local_file.ceph_ingress_yaml]
}

# Create temporary YAML file for Ceph dashboard ingress
resource "local_file" "ceph_ingress_yaml" {
  count = var.ingress_enabled ? 1 : 0

  content = templatefile("${path.module}/templates/ingress.yaml", {
    namespace    = var.namespace
    cluster_name = var.cluster_name
    ingress_host = var.ingress_host
  })
  filename = "${path.module}/.temp-ceph-ingress-${var.namespace}.yaml"
  file_permission = "0644"

  depends_on = [null_resource.ceph_cluster]
}

# Apply LoadBalancer for dashboard if enabled
resource "kubernetes_service" "dashboard_lb" {
  count = var.enable_dashboard && var.dashboard_loadbalancer_enabled ? 1 : 0

  metadata {
    name      = "rook-ceph-mgr-dashboard-lb"
    namespace = var.namespace
  }

  spec {
    selector = {
      app   = "rook-ceph-mgr"
      rook_cluster = var.cluster_name
    }

    port {
      name        = "dashboard"
      port        = 8443
      target_port = 8443
      protocol    = "TCP"
    }

    type = "LoadBalancer"

    dynamic "load_balancer_ip_mode" {
      for_each = var.dashboard_loadbalancer_ip_mode != "" ? [1] : []
      content {
        mode = var.dashboard_loadbalancer_ip_mode
      }
    }
  }

  depends_on = [null_resource.ceph_cluster]
}