#!/usr/bin/env bash
# Repairs dev DB when an old migration id was applied but removed from the repo.
# Safe for local development; does not delete user data.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=migration-dev-utils.sh
source "$SCRIPT_DIR/migration-dev-utils.sh"

cd "$SERVER_DIR"

echo "==> Ensuring Docker Postgres is up"
docker compose up -d postgres >/dev/null
_wait_for_postgres
reconcile_dev_migrations
