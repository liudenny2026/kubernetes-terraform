variable "wazuh_namespace" {
  description = "Namespace for Wazuh deployment"
  type        = string
  default     = "wazuh"
}

variable "install_elasticsearch" {
  description = "Whether to install Elasticsearch for Wazuh"
  type        = bool
  default     = true
}

variable "install_wazuh" {
  description = "Whether to install Wazuh manager"
  type        = bool
  default     = true
}

variable "install_wazuh_indexer" {
  description = "Whether to install Wazuh indexer"
  type        = bool
  default     = true
}

variable "install_dashboard" {
  description = "Whether to install Wazuh dashboard"
  type        = bool
  default     = true
}

variable "elasticsearch_image" {
  description = "Elasticsearch Docker image"
  type        = string
  default     = "docker.elastic.co/elasticsearch/elasticsearch:7.17.3"
}



variable "wazuh_indexer_image" {
  description = "Wazuh Indexer Docker image"
  type        = string
  default     = "wazuh/wazuh-indexer:4.12.0"
}

variable "wazuh_dashboard_image" {
  description = "Wazuh Dashboard Docker image"
  type        = string
  default     = "wazuh/wazuh-dashboard:4.12.0"
}

variable "wazuh_certs_generator_image" {
  description = "Wazuh Certificates Generator Docker image"
  type        = string
  default     = "wazuh/certs-generator:0.0.2"
}

variable "generate_certs" {
  description = "Whether to generate certificates using cert generator"
  type        = bool
  default     = true
}

variable "certs_validity_days" {
  description = "Certificate validity in days"
  type        = number
  default     = 365
}

variable "elasticsearch_cluster_name" {
  description = "Elasticsearch cluster name"
  type        = string
  default     = "wazuh-cluster"
}

variable "elasticsearch_node_count" {
  description = "Number of Elasticsearch nodes"
  type        = number
  default     = 1
}

variable "elasticsearch_heap_size" {
  description = "Elasticsearch heap size"
  type        = string
  default     = "1g"
}

variable "elasticsearch_storage_size" {
  description = "Storage size for Elasticsearch"
  type        = string
  default     = "10Gi"
}

variable "elasticsearch_cpu_request" {
  description = "CPU request for Elasticsearch"
  type        = string
  default = '1000m'
}

variable "elasticsearch_cpu_limit" {
  description = "CPU limit for Elasticsearch"
  type        = string
  default = '2000m'
}

variable "elasticsearch_memory_request" {
  description = "Memory request for Elasticsearch"
  type        = string
  default = '2Gi'
}

variable "elasticsearch_memory_limit" {
  description = "Memory limit for Elasticsearch"
  type        = string
  default = '4Gi'
}



variable "wazuh_indexer_replicas" {
  description = "Number of Wazuh indexer replicas"
  type        = number
  default     = 1
}

variable "wazuh_indexer_cpu_request" {
  description = "CPU request for Wazuh indexer"
  type        = string
  default = '400m'
}

variable "wazuh_indexer_cpu_limit" {
  description = "CPU limit for Wazuh indexer"
  type        = string
  default = '1000m'
}

variable "wazuh_indexer_memory_request" {
  description = "Memory request for Wazuh indexer"
  type        = string
  default = '1024Mi'
}

variable "wazuh_indexer_memory_limit" {
  description = "Memory limit for Wazuh indexer"
  type        = string
  default = '2Gi'
}

variable "wazuh_dashboard_replicas" {
  description = "Number of Wazuh dashboard replicas"
  type        = number
  default     = 1
}

variable "wazuh_dashboard_cpu_request" {
  description = "CPU request for Wazuh dashboard"
  type        = string
  default = '400m'
}

variable "wazuh_dashboard_cpu_limit" {
  description = "CPU limit for Wazuh dashboard"
  type        = string
  default = '1000m'
}

variable "wazuh_dashboard_memory_request" {
  description = "Memory request for Wazuh dashboard"
  type        = string
  default = '1024Mi'
}

variable "wazuh_dashboard_memory_limit" {
  description = "Memory limit for Wazuh dashboard"
  type        = string
  default = '2Gi'
}

variable "dashboard_username" {
  description = "Username for Wazuh dashboard"
  type        = string
  default     = "admin"
}

variable "dashboard_password" {
  description = "Password for Wazuh dashboard"
  type        = string
  default     = "SecretPassword123!"
}



variable "elastic_user_password" {
  description = "Password for Elasticsearch elastic user"
  type        = string
  default     = "SecretPassword123!"
}

variable "elasticsearch_discovery_hosts" {
  description = "Elasticsearch discovery hosts"
  type        = string
  default     = "wazuh-cluster-svc"
}

variable "elasticsearch_initial_master_nodes" {
  description = "Initial master nodes for Elasticsearch"
  type        = string
  default     = "wazuh-cluster-0"
}

variable "elasticsearch_pvc_enabled" {
  description = "Whether to enable PVC for Elasticsearch"
  type        = bool
  default     = true
}

variable "create_storage_class" {
  description = "Whether to create a storage class"
  type        = bool
  default     = false
}

variable "storage_class_name" {
  description = "Name of the storage class to use"
  type        = string
  default     = "standard"
}

variable "storage_provisioner" {
  description = "Storage provisioner to use"
  type        = string
  default     = "kubernetes.io/aws-ebs"
}

variable "storage_parameters" {
  description = "Parameters for the storage class"
  type        = map(string)
  default     = {}
}

variable "pvc_access_modes" {
  description = "Access modes for PVCs"
  type        = list(string)
  default     = ["ReadWriteOnce"]
}



variable "dashboard_service_type" {
  description = "Service type for Wazuh dashboard"
  type        = string
  default     = "LoadBalancer"
}
