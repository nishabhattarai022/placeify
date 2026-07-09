#!/usr/bin/env bash
# Idempotent schema repair for dev/test DBs (safe to run multiple times).
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SERVER_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
REPAIR_SQL="$SERVER_DIR/migrations/20260624150000000/migration.sql"

usage() {
  echo "Usage: $0 <postgres|postgres_test> [database_name]" >&2
  exit 1
}

service="${1:-}"
db_name="${2:-}"

[[ -n "$service" ]] || usage

case "$service" in
  postgres) db_name="${db_name:-placeify}" ;;
  postgres_test) db_name="${db_name:-placeify_test}" ;;
  *) usage ;;
esac

cd "$SERVER_DIR"
docker compose up -d "$service" >/dev/null

echo "==> Applying idempotent schema repair on $db_name"
docker compose exec -T "$service" psql -U postgres -d "$db_name" \
  -v ON_ERROR_STOP=1 -f - < "$REPAIR_SQL" >/dev/null

echo "✓ Schema repair applied on $db_name"
