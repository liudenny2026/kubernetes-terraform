# ============================================================================
# CoreDNS Module - Main Configuration
# 三级架构: 模块�?- 组合CoreDNS相关资源
# 命名规范: {env}-{component}-coredns-{resource-type}
# 示例: prod-cloud-native-coredns-deployment
# ============================================================================

# 传入安全标签标准
locals {
  standard_labels = merge(var.tags, {
    app       = "coredns"
    component = "dns"
    version   = var.coredns_version
  })
}

# 调用资源层定�?- ConfigMap
module "coredns_configmap" {
  source = "../../../resources/coredns/configmap"

  name             = "${var.environment}-${var.component}-coredns-configmap"
  namespace        = var.namespace
  cluster_domain   = var.cluster_domain
  upstream_dns     = var.upstream_dns_servers
  labels           = local.standard_labels
  enable_stub_domains = var.enable_stub_domains
  stub_domains     = var.stub_domains
}

# 调用资源层定�?- Deployment
module "coredns_deployment" {
  source = "../../../resources/coredns/deployment"

  name             = "${var.environment}-${var.component}-coredns-deployment"
  namespace        = var.namespace
  image            = "coredns/coredns:${var.coredns_version}"
  replicas         = var.coredns_replicas
  labels           = local.standard_labels
  service_account  = "${var.environment}-${var.component}-coredns-sa"
  
  cpu_request      = var.coredns_cpu_request
  cpu_limit        = var.coredns_cpu_limit
  memory_request   = var.coredns_memory_request
  memory_limit     = var.coredns_memory_limit

  depends_on = [module.coredns_service_account]
}

# 调用资源层定�?- Service
module "coredns_service" {
  source = "../../../resources/coredns/service"

  name             = "${var.environment}-${var.component}-coredns-service"
  namespace        = var.namespace
  selector_labels  = local.standard_labels
  labels           = local.standard_labels
  enable_metrics   = true
}

# 调用资源层定�?- ServiceAccount
module "coredns_service_account" {
  source = "../../../resources/coredns/serviceaccount"

  name      = "${var.environment}-${var.component}-coredns-sa"
  namespace = var.namespace
  labels    = local.standard_labels
}

# 调用资源层定�?- ClusterRole
module "coredns_clusterrole" {
  source = "../../../resources/coredns/clusterrole"

  name   = "${var.environment}-${var.component}-coredns-clusterrole"
  labels = local.standard_labels
}

# 调用资源层定�?- ClusterRoleBinding
module "coredns_clusterrolebinding" {
  source = "../../../resources/coredns/clusterrolebinding"

  name              = "${var.environment}-${var.component}-coredns-clusterrolebinding"
  labels            = local.standard_labels
  clusterrole_name  = module.coredns_clusterrole.name
  serviceaccount_name = module.coredns_service_account.name
  namespace         = var.namespace
}
