#!/bin/bash

echo "=========================================="
echo "Ceph Storage Read/Write Test Script"
echo "=========================================="
echo ""

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

NAMESPACE="rook-ceph"

echo -e "${YELLOW}[Step 1] Creating StorageClasses...${NC}"
kubectl apply -f test-resources.yaml
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ StorageClasses created successfully${NC}"
else
    echo -e "${RED}✗ Failed to create StorageClasses${NC}"
    exit 1
fi
echo ""

echo -e "${YELLOW}[Step 2] Creating PVCs...${NC}"
echo ""

echo -e "${YELLOW}[Step 3] Waiting for PVCs to be Bound...${NC}"
echo "Waiting for ceph-rbd-test-pvc..."
kubectl wait --for=condition=bound pvc/ceph-rbd-test-pvc -n $NAMESPACE --timeout=120s
echo "Waiting for cephfs-test-pvc..."
kubectl wait --for=condition=bound pvc/cephfs-test-pvc -n $NAMESPACE --timeout=120s
echo ""

echo -e "${YELLOW}[Step 4] Creating test Pods...${NC}"
kubectl apply -f test-pod.yaml
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Test Pods created successfully${NC}"
else
    echo -e "${RED}✗ Failed to create test Pods${NC}"
    exit 1
fi
echo ""

echo -e "${YELLOW}[Step 5] Waiting for RBD test Pod to complete...${NC}"
kubectl wait --for=condition=Ready pod/ceph-rbd-test-pod -n $NAMESPACE --timeout=180s
echo ""

echo -e "${YELLOW}[Step 6] Getting RBD test results...${NC}"
kubectl logs -n $NAMESPACE ceph-rbd-test-pod
echo ""

echo -e "${YELLOW}[Step 7] Waiting for CephFS test Pod to complete...${NC}"
kubectl wait --for=condition=Ready pod/cephfs-test-pod -n $NAMESPACE --timeout=180s
echo ""

echo -e "${YELLOW}[Step 8] Getting CephFS test results...${NC}"
kubectl logs -n $NAMESPACE cephfs-test-pod
echo ""

echo -e "${YELLOW}[Step 9] Waiting for concurrent test Pods to complete...${NC}"
kubectl wait --for=condition=Ready pod/cephfs-concurrent-test-pod-1 -n $NAMESPACE --timeout=180s
kubectl wait --for=condition=Ready pod/cephfs-concurrent-test-pod-2 -n $NAMESPACE --timeout=180s
echo ""

echo -e "${YELLOW}[Step 10] Getting concurrent test results...${NC}"
echo "=== Pod 1 Results ==="
kubectl logs -n $NAMESPACE cephfs-concurrent-test-pod-1
echo ""
echo "=== Pod 2 Results ==="
kubectl logs -n $NAMESPACE cephfs-concurrent-test-pod-2
echo ""

echo -e "${YELLOW}[Step 11] Checking PVC status...${NC}"
kubectl get pvc -n $NAMESPACE
echo ""

echo -e "${YELLOW}[Step 12] Checking Pod status...${NC}"
kubectl get pods -n $NAMESPACE | grep test
echo ""

echo -e "${YELLOW}[Step 13] Checking Ceph cluster health...${NC}"
kubectl get cephcluster -n $NAMESPACE
echo ""

echo "=========================================="
echo -e "${GREEN}Test Script Execution Completed!${NC}"
echo "=========================================="
echo ""
echo "To clean up test resources, run:"
echo "  kubectl delete -f test-pod.yaml"
echo "  kubectl delete -f test-resources.yaml"
echo ""
