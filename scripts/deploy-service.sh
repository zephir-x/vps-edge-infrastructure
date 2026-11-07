#!/usr/bin/env bash
# Zero-Build Deployment & Disk Reclamation Script
# Usage: ./deploy-service.sh <path-to-service-directory>

set -euo pipefail

SERVICE_DIR="${1:-}"

if [[ -z "$SERVICE_DIR" || ! -d "$SERVICE_DIR" ]]; then
    echo "Error: Provide a valid service directory path (e.g., ../apps/projecthub)"
    exit 1
fi

echo "==> [1/4] Navigating to ${SERVICE_DIR} and pulling latest GHCR images..."
cd "$SERVICE_DIR"
docker compose pull

echo "==> [2/4] Recreating updated containers..."
docker compose up -d

echo "==> [3/4] Pruning dangling and unused Docker images to preserve VPS disk quota..."
docker image prune -a -f

echo "==> [4/4] Auditing Docker storage and host filesystem utilization..."
docker system df
echo "---------------------------------------------------"
df -h /