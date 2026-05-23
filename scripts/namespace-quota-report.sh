#!/bin/bash
# Report resource quota usage per namespace
echo "=== Namespace Resource Quota Report ==="
for ns in $(kubectl get ns --no-headers -o custom-columns=':metadata.name'); do
    QUOTA=$(kubectl get resourcequota -n "$ns" --no-headers 2>/dev/null)
    [ -z "$QUOTA" ] && continue
    echo ""
    echo "Namespace: $ns"
    kubectl describe resourcequota -n "$ns" | grep -E "Resource|requests|limits" | head -15
done
