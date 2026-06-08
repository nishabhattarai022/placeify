#!/usr/bin/env bash
set -euo pipefail

SERVER_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$SERVER_DIR"

if curl -sf http://127.0.0.1:8080/ >/dev/null 2>&1; then
  echo "✓ Server is already running on http://127.0.0.1:8080/"
  echo "  Do NOT start it again — that causes 'port 8081 already in use'."
  echo "  To restart: lsof -ti :8080 | xargs kill && $0"
  exit 0
fi

echo "==> Starting Docker (Postgres + Redis)"
docker compose up -d

echo "==> Starting Placeify server"
dart bin/main.dart --apply-migrations
