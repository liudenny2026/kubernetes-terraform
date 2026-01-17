output "wazuh_namespace" {
  description = "Namespace where Wazuh was deployed"
  value       = kubernetes_namespace.wazuh.metadata[0].name
}

output "elasticsearch_service_name" {
  description = "Name of the Elasticsearch service"
  value       = var.install_elasticsearch ? kubernetes_service.wazuh_elasticsearch[0].metadata[0].name : null
}



output "wazuh_dashboard_service_name" {
  description = "Name of the Wazuh dashboard service"
  value       = var.install_dashboard ? kubernetes_service.wazuh_dashboard[0].metadata[0].name : null
}

output "wazuh_dashboard_url" {
  description = "URL for accessing Wazuh dashboard"
  value       = var.install_dashboard ? "${var.dashboard_service_type == "LoadBalancer" ? try(kubernetes_service.wazuh_dashboard[0].status[0].load_balancer[0].ingress[0].ip, kubernetes_service.wazuh_dashboard[0].spec[0].cluster_ip) : kubernetes_service.wazuh_dashboard[0].spec[0].cluster_ip}" : null
}
