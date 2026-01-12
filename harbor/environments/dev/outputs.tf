# Terraform outputs for Harbor deployment
output "harbor_namespace" {
  description = "Harbor 部署的命名空间"
  value       = helm_release.harbor.namespace
}

output "harbor_admin_password" {
  description = "Harbor 管理员密码"
  value       = random_password.harbor_admin_password.result
  sensitive   = true
}

output "harbor_loadbalancer_ip" {
  description = "Harbor LoadBalancer 外部 IP"
  value       = var.loadbalancer_ip != "" ? var.loadbalancer_ip : "分配中...请运行: kubectl get svc -n harbor"
}

output "harbor_access_url" {
  description = "Harbor Web 界面访问地址"
  value       = var.loadbalancer_ip != "" ? "http://${var.loadbalancer_ip}" : "请运行 kubectl get svc -n harbor 获取 IP"
}

output "docker_login_command" {
  description = "Docker 登录命令"
  value       = var.loadbalancer_ip != "" ? "docker login ${var.loadbalancer_ip} -u admin -p ${random_password.harbor_admin_password.result}" : "请先获取 LoadBalancer IP"
  sensitive   = true
}

output "harbor_version" {
  description = "部署的 Harbor 版本"
  value       = "v2.14.1"
}
