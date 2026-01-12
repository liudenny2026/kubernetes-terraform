# MetalLB 命名空间
resource "kubernetes_namespace_v1" "metallb" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/name"       = "metallb"
      "app.kubernetes.io/instance"   = "metallb"
      "app.kubernetes.io/managed-by" = "terraform"
      "pod-security.kubernetes.io/audit"   = "privileged"
      "pod-security.kubernetes.io/enforce" = "privileged"
      "pod-security.kubernetes.io/warn"    = "privileged"
    }
  }
}

# Install MetalLB using kubectl apply
resource "null_resource" "install_metallb" {
  depends_on = [kubernetes_namespace_v1.metallb]

  triggers = {
    metallb_version = var.metallb_version
  }

  provisioner "local-exec" {
    interpreter = ["PowerShell", "-Command"]
    command = <<-EOH
      $version = "${var.metallb_version}"
      $url = "https://raw.githubusercontent.com/metallb/metallb/$version/config/manifests/metallb-native.yaml"
      $tempFile = [System.IO.Path]::GetTempFileName() + ".yaml"
      Invoke-WebRequest -Uri $url -OutFile $tempFile
      kubectl apply -f $tempFile
      Remove-Item $tempFile
      Write-Host "Waiting for MetalLB webhook to be ready..."
      Start-Sleep -Seconds 30
    EOH
  }
}

# Configure kube-proxy strictARP for L2 mode using null_resource to patch existing ConfigMap
resource "null_resource" "configure_kube_proxy_strict_arp" {
  count      = var.configure_kube_proxy ? 1 : 0
  depends_on = [null_resource.install_metallb]

  triggers = {
    kube_proxy_strict_arp = var.kube_proxy_strict_arp
  }

  provisioner "local-exec" {
    interpreter = ["PowerShell", "-Command"]
    command = <<-EOH
      $config = @'
apiVersion: kubeproxy.config.k8s.io/v1alpha1
kind: KubeProxyConfiguration
ipvs:
  strictARP: ${var.kube_proxy_strict_arp}
'@
      $tempFile = [System.IO.Path]::GetTempFileName() + ".yaml"
      $config | Out-File -FilePath $tempFile -Encoding utf8
      kubectl patch configmap kube-proxy -n kube-system --type merge -p "{\"data\": {\"config.conf\": \"$(Get-Content $tempFile -Raw)\"}}"
      Remove-Item $tempFile
    EOH
  }
}

# MetalLB IPAddressPool 配置
resource "kubernetes_manifest" "ip_address_pool" {
  depends_on = [
    null_resource.install_metallb,
    null_resource.configure_kube_proxy_strict_arp
  ]

  manifest = {
    apiVersion = "metallb.io/v1beta1"
    kind       = "IPAddressPool"
    metadata = {
      name      = var.ip_address_pool_name
      namespace = var.namespace
    }
    spec = {
      addresses = var.ip_addresses
    }
  }

  # Wait for webhook to be ready
  timeouts {
    create = "5m"
    update = "5m"
  }
}

# MetalLB L2Advertisement 配置
resource "kubernetes_manifest" "l2_advertisement" {
  depends_on = [kubernetes_manifest.ip_address_pool]

  manifest = {
    apiVersion = "metallb.io/v1beta1"
    kind       = "L2Advertisement"
    metadata = {
      name      = var.l2_advertisement_name
      namespace = var.namespace
    }
    spec = {
      ipAddressPools = [var.ip_address_pool_name]
    }
  }
}
