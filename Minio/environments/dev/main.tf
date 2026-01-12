module "minio" {
  source = "../../modules/minio"

  node_name           = var.node_name
  storage_capacity    = var.storage_capacity
  replicas            = var.minio_replicas
  minio_root_user     = var.minio_root_user
  minio_root_password = var.minio_root_password
  service_type        = var.service_type
}
