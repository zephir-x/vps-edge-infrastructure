#!/usr/bin/env bash
# Host-level UFW Firewall & SSH Hardening Baseline

set -euo pipefail

SSH_NAT_PORT="10117"
TCP_RELAY_PORT="20117"

echo "==> Setting default UFW policies..."
ufw default deny incoming
ufw default allow outgoing

echo "==> Allowing SSH access (IPv6 Standard & IPv4 NAT Port)..."
ufw allow 22/tcp comment 'SSH over IPv6'
ufw allow "${SSH_NAT_PORT}/tcp" comment 'SSH over IPv4 NAT'

echo "==> Allowing HTTP/HTTPS Edge traffic from Cloudflare..."
ufw allow 80/tcp comment 'HTTP Nginx Reverse Proxy'
ufw allow 443/tcp comment 'HTTPS Reserved'

echo "==> Allowing Custom L4 TCP Game Relay port..."
ufw allow "${TCP_RELAY_PORT}/tcp" comment 'Billiards Multiplayer TCP Relay'

echo "==> Verifying SSH PasswordAuthentication policy..."
if grep -q "^PasswordAuthentication no" /etc/ssh/sshd_config; then
    echo "[OK] SSH PasswordAuthentication is disabled (Key-only access)."
else
    echo "[WARN] Ensure 'PasswordAuthentication no' is set in /etc/ssh/sshd_config"
fi

ufw status numbered