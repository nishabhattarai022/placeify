#!/usr/bin/env bash
set -euo pipefail

SERVER_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$SERVER_DIR"

if curl -sf http://127.0.0.1:8080/ >/dev/null 2>&1; then
  echo "✓ Server is already running on http://127.0.0.1:8080/"
  echo "  To restart: ./scripts/stop-server.sh && $0"
  exit 0
fi

# Ports held by a crashed/zombie process block a new start.
_stale=0
for port in 8080 8081 8082; do
  if lsof -ti ":$port" >/dev/null 2>&1; then
    _stale=1
    break
  fi
done
if [[ "$_stale" -eq 1 ]]; then
  echo "==> Ports 8080–8082 are in use but API is not responding — cleaning up"
  "$(dirname "$0")/stop-server.sh"
fi

if [[ ! -f config/passwords.yaml ]]; then
  echo "==> Creating config/passwords.yaml from example"
  cp config/passwords.yaml.example config/passwords.yaml
fi

echo "==> Starting Docker (Postgres + Redis)"
docker compose up -d

echo "==> Starting Placeify server (Ctrl+C to stop)"
dart bin/main.dart --apply-migrations
