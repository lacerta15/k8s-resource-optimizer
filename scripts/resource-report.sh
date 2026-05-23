#!/bin/bash
# Report on pod resource requests vs actual usage
echo "=== Kubernetes Resource Report ==="
echo ""

echo "--- Node Capacity & Allocatable ---"
kubectl get nodes -o custom-columns='NAME:.metadata.name,CPU-CAP:.status.capacity.cpu,MEM-CAP:.status.capacity.memory,CPU-ALLOC:.status.allocatable.cpu,MEM-ALLOC:.status.allocatable.memory'

echo ""
echo "--- Top Pods by CPU ---"
kubectl top pods --all-namespaces --sort-by=cpu 2>/dev/null | head -20

echo ""
echo "--- Top Pods by Memory ---"
kubectl top pods --all-namespaces --sort-by=memory 2>/dev/null | head -20

echo ""
echo "--- Pods with NO resource requests (namespace: ${1:-default}) ---"
kubectl get pods -n "${1:-default}" -o json |     jq -r '.items[] | select(.spec.containers[].resources.requests == null) |
            .metadata.name + " / " + .spec.containers[].name'
