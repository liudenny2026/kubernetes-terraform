# MetalLB 模块变更测试流程

## 概述
本文档描述了在修改 MetalLB 模块时的测试流程，旨在确保变更不会影响其他组件，同时验证修改的正确性和稳定性。

## 测试环境
使用独立的测试环境进行变更验证：
- 路径：`environments/metallb-test/`
- 配置：仅包含 MetalLB 模块的最小化配置
- 目的：隔离测试，避免影响生产环境

## 测试步骤

### 1. 环境准备
```bash
# 进入测试环境目录
cd environments/metallb-test

# 初始化 Terraform
terraform init

# 查看计划（确认不会影响其他资源）
terraform plan
```

### 2. 基础功能测试
```bash
# 部署 MetalLB 模块
terraform apply -auto-approve

# 验证 MetalLB 命名空间创建
kubectl get namespace metallb-system

# 验证 MetalLB 组件运行状态
kubectl get pods -n metallb-system

# 验证 IPAddressPool 和 L2Advertisement 配置
kubectl get ipaddresspool -n metallb-system
kubectl get l2advertisement -n metallb-system
```

### 3. 集成测试
```bash
# 创建一个测试服务验证 LoadBalancer 功能
cat > test-service.yaml <<EOF
apiVersion: v1
kind: Service
metadata:
  name: test-nginx
  namespace: default
spec:
  selector:
    app: nginx
  ports:
  - port: 80
    targetPort: 80
  type: LoadBalancer
EOF

# 部署测试服务
kubectl apply -f test-service.yaml

# 验证服务获得外部 IP
kubectl get service test-nginx -w
```

### 4. 兼容性测试
```bash
# 检查与其他网络组件的兼容性
kubectl get pods -n kube-system | grep -E "calico|flannel|coredns"

# 验证 DNS 解析正常
kubectl run -it --rm --restart=Never busybox --image=busybox:1.28 -- nslookup kubernetes.default
```

### 5. 清理测试环境
```bash
# 删除测试服务
kubectl delete -f test-service.yaml

# 销毁 MetalLB 模块
terraform destroy -auto-approve

# 验证清理完成
kubectl get namespace metallb-system 2>/dev/null || echo "Namespace deleted successfully"
```

## 变更验证清单

### 核心功能
- [ ] MetalLB 命名空间正确创建
- [ ] MetalLB 组件正常运行
- [ ] IP 地址池配置正确
- [ ] L2 广告配置正确
- [ ] LoadBalancer 服务能获得外部 IP

### 兼容性检查
- [ ] 不影响现有网络组件（Calico/CoredDNS 等）
- [ ] 不影响集群内通信
- [ ] 不影响 DNS 解析
- [ ] 不影响其他 LoadBalancer 服务

### 安全检查
- [ ] 资源隔离正确（命名空间、标签）
- [ ] 权限配置合理
- [ ] 无安全策略冲突

## 回滚策略

### 自动化回滚
```bash
# 使用 Terraform 状态回滚到上一个稳定版本
terraform apply -auto-approve -var-file=../prod.tfvars
```

### 手动回滚
```bash
# 手动删除 MetalLB 资源
kubectl delete -f https://raw.githubusercontent.com/metallb/metallb/v0.15.3/config/manifests/metallb-native.yaml

# 恢复 kube-proxy 配置
kubectl patch configmap kube-proxy -n kube-system --type merge -p '{"data": {"config.conf": "apiVersion: kubeproxy.config.k8s.io/v1alpha1\nkind: KubeProxyConfiguration\nipvs:\n  strictARP: false\n"}}'
```

## 变更发布流程

1. **开发阶段**：在独立测试环境中验证变更
2. **预发布阶段**：在 staging 环境中进行集成测试
3. **发布阶段**：在生产环境中逐步部署
4. **监控阶段**：密切监控 24 小时，确保无异常

## 常见问题与解决方案

### 1. kube-proxy 配置冲突
**问题**：修改 strictARP 后影响其他网络功能
**解决方案**：使用条件配置 `configure_kube_proxy = false` 跳过 kube-proxy 配置

### 2. IP 地址范围冲突
**问题**：MetalLB IP 范围与集群其他组件冲突
**解决方案**：在变量验证中添加 IP 范围检查，确保不与已知范围重叠

### 3. 组件依赖问题
**问题**：MetalLB 依赖的 CRD 未正确安装
**解决方案**：增加安装后等待时间，确保 CRD 可用

## 版本变更记录
| 版本 | 日期 | 变更内容 | 测试状态 |
|------|------|----------|----------|
| 0.1.0 | 2026-01-18 | 初始版本 | ✅ 通过 |
