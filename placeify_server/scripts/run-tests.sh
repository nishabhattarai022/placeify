#!/usr/bin/env bash
# Runs integration tests with Docker Postgres/Redis up and dev DB repaired first.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SERVER_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$SERVER_DIR"

echo "==> Starting Docker (Postgres + Redis for dev and test)"
docker compose up -d

echo "==> Repairing dev database migrations (if needed)"
"$SCRIPT_DIR/fix-migrations.sh"

echo "==> Running tests"
exec dart test "$@"
