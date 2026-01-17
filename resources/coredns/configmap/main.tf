# ============================================================================
# Resource Layer: CoreDNS ConfigMap
# 三级架构: 资源层 - 单个Kubernetes资源定义
# ============================================================================

resource "kubernetes_config_map" "coredns" {
  metadata {
    name      = var.name
    namespace = var.namespace
    labels    = var.labels
  }

  data = {
    Corefile = var.enable_stub_domains ? templatefile("${path.module}/templates/Corefile_with_stub.tpl", {
      cluster_domain = var.cluster_domain
      upstream_dns   = join(" ", var.upstream_dns)
    }) : templatefile("${path.module}/templates/Corefile.tpl", {
      cluster_domain = var.cluster_domain
      upstream_dns   = join(" ", var.upstream_dns)
    })
  }
}
