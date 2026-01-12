# Ceph 存储测试说明

## 测试文件

- **test-resources.yaml**: StorageClass 和 PVC 定义
- **test-pod.yaml**: 测试 Pod 定义
- **run-tests.sh** / **run-tests.bat**: 自动化测试脚本

## 测试内容

### 1. RBD 块存储测试
- 文件写入和读取
- 性能测试（100MB）
- 文件列表查看

### 2. CephFS 文件系统测试
- 文件写入和读取
- 性能测试（100MB）
- 文件列表查看

### 3. 并发访问测试
- 两个 Pod 同时写入同一文件
- 验证 ReadWriteMany 访问模式

## 运行测试

### 自动化脚本

**Linux/Mac:**
```bash
cd modules/ceph
chmod +x run-tests.sh
./run-tests.sh
```

**Windows:**
```bash
cd modules\ceph
run-tests.bat
```

### 手动运行

```bash
# 创建资源
kubectl apply -f modules/ceph/test-resources.yaml
kubectl apply -f modules/ceph/test-pod.yaml

# 等待 PVC 绑定
kubectl wait --for=condition=bound pvc/ceph-rbd-test-pvc -n rook-ceph --timeout=120s

# 查看测试结果
kubectl logs -n rook-ceph ceph-rbd-test-pod
kubectl logs -n rook-ceph cephfs-test-pod
```

## 清理测试资源

```bash
kubectl delete -f modules/ceph/test-pod.yaml
kubectl delete -f modules/ceph/test-resources.yaml
```

## 性能参考

- **写入性能**: 应该 > 50 MB/s
- **读取性能**: 应该 > 100 MB/s

## 故障排查

```bash
# 检查 PVC 状态
kubectl describe pvc -n rook-ceph

# 检查 Ceph 集群
kubectl get cephcluster -n rook-ceph

# 查看 Pod 日志
kubectl logs -n rook-ceph <pod-name>
```
