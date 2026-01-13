# Kubeconfig 配置
kubeconfig_path = "~/.kube/config"

# 命名空间
namespace = "monitoring"

# 启用监控组件
enable_istio_monitoring    = true
enable_ceph_monitoring     = true
enable_metallb_monitoring  = true
enable_kubeflow_monitoring = true
enable_mlflow_monitoring   = true
enable_minio_monitoring    = true

# 存储类配置
storage_class = "local-path"

# 国内镜像源配置
registry_mirror = "registry.cn-hangzhou.aliyuncs.com"

# Helm Chart 配置（使用阿里云镜像）
prometheus_repository = "https://aliacs-app-catalog.oss-cn-hangzhou.aliyuncs.com/charts-incubator/"
prometheus_chart_name = "ack-prometheus-operator"
prometheus_chart_version = "65.1.1"
