#!/bin/sh
set -e

# Set default route to the mesh2_ap node instead of the default docker bridge
ip route del default 2>/dev/null || true
ip route add default via 192.168.117.2 dev eth0

echo "$(hostname): default route set to 192.168.117.2(node mesh2_ap) via eth0"

# Keep container running indefinitly
tail -f /dev/null