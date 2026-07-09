#!/usr/bin/env bash
# Applies pending migrations to the test database (placeify_test on port 9090).
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SERVER_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$SERVER_DIR"

LATEST_MIGRATION="$(grep -E '^[0-9]+$' migrations/migration_registry.txt | tail -1)"

if [[ ! -f config/passwords.yaml ]]; then
  cp config/passwords.yaml.example config/passwords.yaml
fi

echo "==> Ensuring Postgres test container is running"
docker compose up -d postgres_test >/dev/null

echo "==> Recreating test database for a clean migration apply"
docker compose exec -T postgres_test psql -U postgres -c \
  "DROP DATABASE IF EXISTS placeify_test WITH (FORCE);" >/dev/null
docker compose exec -T postgres_test psql -U postgres -c \
  "CREATE DATABASE placeify_test;" >/dev/null

echo "==> Applying test database migrations"
dart bin/main.dart --mode test --apply-migrations &
server_pid=$!

cleanup() {
  if kill -0 "$server_pid" 2>/dev/null; then
    kill "$server_pid" 2>/dev/null || true
    wait "$server_pid" 2>/dev/null || true
  fi
}
trap cleanup EXIT

for _ in $(seq 1 90); do
  version="$(
    docker compose exec -T postgres_test psql -U postgres -d placeify_test -tAc \
      "SELECT version FROM serverpod_migrations WHERE module = 'placeify' LIMIT 1;" \
      2>/dev/null | tr -d '[:space:]' || true
  )"
  if [[ "$version" == "$LATEST_MIGRATION" ]]; then
    echo "✓ Test migrations applied ($version)"
    "$SCRIPT_DIR/ensure-schema-repair.sh" postgres_test placeify_test
    exit 0
  fi
  if ! kill -0 "$server_pid" 2>/dev/null; then
    echo "ERROR: Test migration server exited early." >&2
    exit 1
  fi
  sleep 1
done

echo "ERROR: Timed out waiting for test migrations (expected $LATEST_MIGRATION)." >&2
exit 1
