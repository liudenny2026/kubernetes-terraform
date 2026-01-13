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
storage_class = "standard"

# 国内镜像源配置
registry_mirror = "docker.mirrors.ustc.edu.cn"
