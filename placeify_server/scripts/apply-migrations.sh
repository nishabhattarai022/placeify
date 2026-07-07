#!/usr/bin/env bash
# Applies pending migrations by briefly starting Serverpod, then stops it.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SERVER_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$SERVER_DIR"

if [[ ! -f config/passwords.yaml ]]; then
  cp config/passwords.yaml.example config/passwords.yaml
fi

echo "==> Applying database migrations"
dart bin/main.dart --apply-migrations &
server_pid=$!

cleanup() {
  if kill -0 "$server_pid" 2>/dev/null; then
    kill "$server_pid" 2>/dev/null || true
    wait "$server_pid" 2>/dev/null || true
  fi
  "$SCRIPT_DIR/stop-server.sh" >/dev/null 2>&1 || true
}
trap cleanup EXIT

for _ in $(seq 1 90); do
  if curl -sf http://127.0.0.1:8080/ >/dev/null 2>&1; then
    echo "✓ Migrations applied"
    exit 0
  fi
  if ! kill -0 "$server_pid" 2>/dev/null; then
    echo "ERROR: Server exited before migrations finished." >&2
    exit 1
  fi
  sleep 1
done

echo "ERROR: Timed out waiting for migrations." >&2
exit 1
