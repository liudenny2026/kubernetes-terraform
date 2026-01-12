# 模块输出定义
# 文件：modules/pvcs/outputs.tf

output "database_pvc_name" {
  value = kubernetes_persistent_volume_claim_v1.harbor_database.metadata[0].name
  description = "数据库 PVC 名称"
}

output "redis_pvc_name" {
  value = kubernetes_persistent_volume_claim_v1.harbor_redis.metadata[0].name
  description = "Redis PVC 名称"
}

output "registry_pvc_name" {
  value = kubernetes_persistent_volume_claim_v1.harbor_registry.metadata[0].name
  description = "Registry PVC 名称"
}

output "chartmuseum_pvc_name" {
  value = kubernetes_persistent_volume_claim_v1.harbor_chartmuseum.metadata[0].name
  description = "ChartMuseum PVC 名称"
}

output "all_pvc_names" {
  value = {
    database = kubernetes_persistent_volume_claim_v1.harbor_database.metadata[0].name
    redis = kubernetes_persistent_volume_claim_v1.harbor_redis.metadata[0].name
    registry = kubernetes_persistent_volume_claim_v1.harbor_registry.metadata[0].name
    chartmuseum = kubernetes_persistent_volume_claim_v1.harbor_chartmuseum.metadata[0].name
  }
  description = "所有 PVC 名称"
}