#!/bin/sh
set -e

HOSTNAME="$(hostname)"
CONF="/etc/babeld/${HOSTNAME}.conf"

echo "[*] $HOSTNAME: initialising routing settings"

# Enable IPv4 & IPv6 forwarding
sysctl -w net.ipv4.ip_forward=1 >/dev/null 2>&1 || true
sysctl -w net.ipv6.conf.all.disable_ipv6=0 >/dev/null 2>&1 || true
sysctl -w net.ipv6.conf.default.disable_ipv6=0 >/dev/null 2>&1 || true

# Disable ICMP redirects
for IF in all default eth0 eth1 eth2; do
  sysctl -w net.ipv4.conf.$IF.send_redirects=0 >/dev/null 2>&1 || true
done

# Remove Docker's default route
ip route del default 2>/dev/null || true

# Add IPv6 link-local addresses for Babel on mesh interfaces
case "$HOSTNAME" in
  mesh1)
    ip -6 addr add fe80::1/64 dev eth0 2>/dev/null || true
    ;;

  mesh2_ap)
    # link_12
    ip -6 addr add fe80::2/64 dev eth0 2>/dev/null || true
    # link_23
    ip -6 addr add fe80::3/64 dev eth1 2>/dev/null || true
    ;;

  mesh3)
    # link_23
    ip -6 addr add fe80::4/64 dev eth0 2>/dev/null || true
    # link_34
    ip -6 addr add fe80::5/64 dev eth1 2>/dev/null || true
    ;;

  mesh4)
    # link_34
    ip -6 addr add fe80::6/64 dev eth0 2>/dev/null || true
    # link_4u
    ip -6 addr add fe80::7/64 dev eth1 2>/dev/null || true
    ;;

  uplink)
    # link_4u
    ip -6 addr add fe80::8/64 dev eth0 2>/dev/null || true
    # uplink_net
    ip -6 addr add fe80::9/64 dev eth1 2>/dev/null || true
    ;;
esac

echo "$HOSTNAME: IPv6 link-local addresses configured"
echo "$HOSTNAME: starting babeld with $CONF"

babeld -c "$CONF" -d 1 &

# 5) NAT on uplink
if [ "$HOSTNAME" = "uplink" ]; then
  echo "[*] $HOSTNAME: configuring NAT on uplink (eth1 -> uplink_net)"
  iptables -t nat -A POSTROUTING -o eth1 -j MASQUERADE
fi

# Keep container alive
tail -f /dev/null
