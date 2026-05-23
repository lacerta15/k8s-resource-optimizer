#!/bin/bash
# Find pods where requests >> actual usage (overprovisioned)
NS="${1:---all-namespaces}"
echo "=== Overprovisioned Pods (requests >> usage) ==="

if [ "$NS" = "--all-namespaces" ]; then
    kubectl top pods --all-namespaces --no-headers 2>/dev/null
else
    kubectl top pods -n "$NS" --no-headers 2>/dev/null
fi | awk '
{
    cpu=$3; mem=$4
    gsub(/m/,"",cpu); gsub(/Mi/,"",mem)
    if (cpu+0 < 50 || mem+0 < 64) {
        print "[LOW-USAGE] " $1 "/" $2 " CPU:" $3 " MEM:" $4
    }
}'
