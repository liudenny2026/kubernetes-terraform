@echo off
chcp 65001 > nul
echo ==========================================
echo Ceph Storage Read/Write Test Script
echo ==========================================
echo.

set NAMESPACE=rook-ceph

echo [Step 1] Creating StorageClasses...
kubectl apply -f test-resources.yaml
if %errorlevel% neq 0 (
    echo ✗ Failed to create StorageClasses
    exit /b 1
)
echo ✓ StorageClasses created successfully
echo.

echo [Step 2] Creating PVCs...
echo.

echo [Step 3] Waiting for PVCs to be Bound...
echo Waiting for ceph-rbd-test-pvc...
kubectl wait --for=condition=bound pvc/ceph-rbd-test-pvc -n %NAMESPACE% --timeout=120s
echo Waiting for cephfs-test-pvc...
kubectl wait --for=condition=bound pvc/cephfs-test-pvc -n %NAMESPACE% --timeout=120s
echo.

echo [Step 4] Creating test Pods...
kubectl apply -f test-pod.yaml
if %errorlevel% neq 0 (
    echo ✗ Failed to create test Pods
    exit /b 1
)
echo ✓ Test Pods created successfully
echo.

echo [Step 5] Waiting for RBD test Pod to complete...
kubectl wait --for=condition=Ready pod/ceph-rbd-test-pod -n %NAMESPACE% --timeout=180s
echo.

echo [Step 6] Getting RBD test results...
kubectl logs -n %NAMESPACE% ceph-rbd-test-pod
echo.

echo [Step 7] Waiting for CephFS test Pod to complete...
kubectl wait --for=condition=Ready pod/cephfs-test-pod -n %NAMESPACE% --timeout=180s
echo.

echo [Step 8] Getting CephFS test results...
kubectl logs -n %NAMESPACE% cephfs-test-pod
echo.

echo [Step 9] Waiting for concurrent test Pods to complete...
kubectl wait --for=condition=Ready pod/cephfs-concurrent-test-pod-1 -n %NAMESPACE% --timeout=180s
kubectl wait --for=condition=Ready pod/cephfs-concurrent-test-pod-2 -n %NAMESPACE% --timeout=180s
echo.

echo [Step 10] Getting concurrent test results...
echo === Pod 1 Results ===
kubectl logs -n %NAMESPACE% cephfs-concurrent-test-pod-1
echo.
echo === Pod 2 Results ===
kubectl logs -n %NAMESPACE% cephfs-concurrent-test-pod-2
echo.

echo [Step 11] Checking PVC status...
kubectl get pvc -n %NAMESPACE%
echo.

echo [Step 12] Checking Pod status...
kubectl get pods -n %NAMESPACE% | findstr test
echo.

echo [Step 13] Checking Ceph cluster health...
kubectl get cephcluster -n %NAMESPACE%
echo.

echo ==========================================
echo Test Script Execution Completed!
echo ==========================================
echo.
echo To clean up test resources, run:
echo   kubectl delete -f test-pod.yaml
echo   kubectl delete -f test-resources.yaml
echo.
