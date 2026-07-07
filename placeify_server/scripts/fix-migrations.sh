#!/usr/bin/env bash
# One-shot fix for "migration registered but not found in project files".
# Run from placeify_server: ./scripts/fix-migrations.sh
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=migration-dev-utils.sh
source "$SCRIPT_DIR/migration-dev-utils.sh"

cd "$SERVER_DIR"

echo "==> placeify_server at: $SERVER_DIR"
echo "==> Starting Postgres (if needed)"
docker compose up -d postgres >/dev/null
_wait_for_postgres

if reconcile_dev_migrations; then
  echo ""
  echo "Done. Start the server with:"
  echo "  ./scripts/start-server.sh"
  echo "or:"
  echo "  dart bin/main.dart --apply-migrations"
else
  echo ""
  echo "Reconcile failed. Reset everything with:"
  echo "  ./scripts/reset-dev-database.sh"
  exit 1
fi
