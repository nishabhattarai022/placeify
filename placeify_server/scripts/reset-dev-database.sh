#!/usr/bin/env bash
# Wipes local Docker Postgres/Redis volumes and restarts with a clean schema.
# Use when reconcile-migrations.sh is not enough or you want a fresh demo DB.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=migration-dev-utils.sh
source "$SCRIPT_DIR/migration-dev-utils.sh"

cd "$SERVER_DIR"

echo "==> Stopping server processes"
"$SCRIPT_DIR/stop-server.sh"

echo "==> Removing Docker volumes (ALL local dev data will be deleted)"
docker compose down -v

echo "==> Starting fresh Postgres + Redis"
docker compose up -d postgres redis
_wait_for_postgres

echo "==> Starting Placeify server with migrations (Ctrl+C to stop)"
exec dart bin/main.dart --apply-migrations
