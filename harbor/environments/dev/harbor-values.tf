# Harbor Helm Values Template (Terraform rendered)
locals {
  harbor_values_content = templatefile("${path.module}/values.tftpl", {
    harbor_admin_password = random_password.harbor_admin_password.result
    storage_class         = var.storage_class
  })
}

resource "local_file" "harbor_values" {
  content  = local.harbor_values_content
  filename = "${path.module}/harbor-values-rendered.yaml"
}
