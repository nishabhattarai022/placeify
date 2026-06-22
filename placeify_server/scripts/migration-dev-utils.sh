#!/usr/bin/env bash
# Shared helpers for local Postgres migration repair (development only).
set -euo pipefail

MIGRATION_UTILS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SERVER_DIR="$(cd "$MIGRATION_UTILS_DIR/.." && pwd)"
REGISTRY_FILE="$SERVER_DIR/migrations/migration_registry.txt"
COMPOSE_FILE="$SERVER_DIR/docker-compose.yaml"
PLACEIFY_MODULE="placeify"

PG_USER="${PLACEIFY_PG_USER:-postgres}"
PG_DB="${PLACEIFY_PG_DB:-placeify}"

_run_psql() {
  docker compose -f "$COMPOSE_FILE" exec -T postgres \
    psql -U "$PG_USER" -d "$PG_DB" -v ON_ERROR_STOP=1 "$@"
}

_wait_for_postgres() {
  local attempt
  for attempt in $(seq 1 40); do
    if docker compose -f "$COMPOSE_FILE" exec -T postgres \
      pg_isready -U "$PG_USER" -d "$PG_DB" >/dev/null 2>&1; then
      return 0
    fi
    sleep 1
  done
  echo "ERROR: Postgres container is not ready." >&2
  return 1
}

_read_registry_versions() {
  if [[ ! -f "$REGISTRY_FILE" ]]; then
    echo "ERROR: Missing $REGISTRY_FILE" >&2
    return 1
  fi
  grep -E '^[0-9]+$' "$REGISTRY_FILE"
}

_latest_registry_version() {
  _read_registry_versions | tail -1
}

_query_placeify_db_version() {
  local result
  if ! result="$(
    _run_psql -tAc \
      "SELECT version FROM serverpod_migrations WHERE module = '$PLACEIFY_MODULE' LIMIT 1;"
  )"; then
    echo "ERROR: Could not query serverpod_migrations (is Postgres running?)" >&2
    return 1
  fi
  echo "${result//[[:space:]]/}"
}

_print_migration_state() {
  echo "==> Current serverpod_migrations rows:"
  _run_psql -c "SELECT module, version FROM serverpod_migrations ORDER BY module;"
}

_table_exists() {
  local table="$1"
  _run_psql -tAc \
    "SELECT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = '$table');" \
    | tr -d '[:space:]'
}

# Returns 0 when version exists in migration_registry.txt.
migration_registry_matches_db() {
  local db_version="$1"
  local version
  while IFS= read -r version; do
    if [[ "$version" == "$db_version" ]]; then
      return 0
    fi
  done < <(_read_registry_versions)
  return 1
}

_find_rollback_target() {
  local orphan="$1"
  local target=""
  local version
  while IFS= read -r version; do
    if [[ "$version" < "$orphan" ]]; then
      if [[ -z "$target" || "$version" > "$target" ]]; then
        target="$version"
      fi
    fi
  done < <(_read_registry_versions)
  echo "$target"
}

_bump_placeify_version() {
  local target="$1"
  _run_psql -c \
    "UPDATE serverpod_migrations SET version = '$target', timestamp = NOW() WHERE module = '$PLACEIFY_MODULE';"
}

# Fix local dev DB when an old migration id was removed from the repo or when
# schema objects already exist (e.g. refund_request from migration 20260613181356657).
reconcile_orphan_placeify_migration() {
  local db_version latest rollback_target

  latest="$(_latest_registry_version)"
  db_version="$(_query_placeify_db_version)" || return 1

  if [[ -z "$db_version" ]]; then
    echo "==> No '$PLACEIFY_MODULE' row in serverpod_migrations (fresh database)"
    _print_migration_state
    return 0
  fi

  if [[ "$db_version" == "$latest" ]]; then
    echo "==> placeify migration is already at latest ($latest)"
    return 0
  fi

  if migration_registry_matches_db "$db_version"; then
    echo "==> DB migration $db_version matches project registry (pending apply is OK)"
    return 0
  fi

  # Orphan id (e.g. 20260613181356657) — schema may already include refund_request.
  if [[ "$(_table_exists refund_request)" == "t" ]]; then
    echo "==> Orphan migration $db_version but refund_request table already exists"
    echo "    Marking placeify as latest ($latest) without re-running SQL"
    _bump_placeify_version "$latest"
    echo "✓ Migration registry aligned to $latest"
    return 0
  fi

  rollback_target="$(_find_rollback_target "$db_version")"
  if [[ -z "$rollback_target" ]]; then
    echo "ERROR: Orphan migration $db_version with no rollback target." >&2
    _print_migration_state
    echo "       Run: ./scripts/reset-dev-database.sh" >&2
    return 1
  fi

  echo "==> Fixing migration mismatch (dev only)"
  echo "    DB registered:  $db_version (removed from this branch)"
  echo "    Rewinding to:   $rollback_target"
  echo "    Then applying:  migrations after $rollback_target"

  _bump_placeify_version "$rollback_target"

  local after
  after="$(_query_placeify_db_version)"
  echo "✓ Migration registry reconciled (placeify is now at $after)"
}

# After a rewind, forward migrations may fail if tables already exist. Align to latest.
reconcile_schema_ahead_of_registry() {
  local db_version latest

  latest="$(_latest_registry_version)"
  db_version="$(_query_placeify_db_version)" || return 1

  if [[ -z "$db_version" || "$db_version" == "$latest" ]]; then
    return 0
  fi

  if [[ "$(_table_exists refund_request)" != "t" ]]; then
    return 0
  fi

  if migration_registry_matches_db "$db_version"; then
    echo "==> Schema ahead of registry: refund_request exists but version is $db_version"
    echo "    Marking placeify as latest ($latest)"
    _bump_placeify_version "$latest"
    echo "✓ Migration registry aligned to $latest"
  fi
}

_column_exists() {
  local table="$1"
  local column="$2"
  _run_psql -tAc \
    "SELECT EXISTS (
       SELECT 1
       FROM information_schema.columns
       WHERE table_schema = 'public'
         AND table_name = '$table'
         AND column_name = '$column'
     );" \
    | tr -d '[:space:]'
}

# Some dev databases registered 20260622042659795 without applying paymentMethod ALTER.
reconcile_payment_method_column() {
  if [[ "$(_table_exists payment_transaction)" != "t" ]]; then
    return 0
  fi

  if [[ "$(_column_exists payment_transaction paymentMethod)" == "t" ]]; then
    return 0
  fi

  echo "==> Repairing payment_transaction.paymentMethod column (checkout 500 fix)"
  _run_psql -c \
    'ALTER TABLE "payment_transaction" ADD COLUMN IF NOT EXISTS "paymentMethod" text NOT NULL DEFAULT '\''mockOnline'\''::text;'
  echo "✓ paymentMethod column restored"
}

reconcile_dev_migrations() {
  reconcile_orphan_placeify_migration || return 1
  reconcile_schema_ahead_of_registry || return 1
  reconcile_payment_method_column || return 1
}
