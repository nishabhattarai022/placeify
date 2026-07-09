#!/usr/bin/env bash
# Run consumer API contract tests (canonical surface + full journey).
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR/.."

if [[ ! -f config/passwords.yaml ]]; then
  cp config/passwords.yaml.example config/passwords.yaml
fi

echo "==> Start Postgres (dev + test)"
docker compose up -d postgres postgres_test >/dev/null

echo "==> Reconcile dev migration registry (if needed)"
if [[ -x "$SCRIPT_DIR/reconcile-migrations.sh" ]]; then
  "$SCRIPT_DIR/reconcile-migrations.sh" || true
fi

echo "==> Apply migrations (dev database)"
"$SCRIPT_DIR/apply-migrations.sh"

echo "==> Apply migrations (test database)"
"$SCRIPT_DIR/apply-test-migrations.sh"

echo "==> Consumer API contract verification"
dart test \
  test/integration/canonical_api_surface_test.dart \
  test/integration/consumer_journey_contract_test.dart

echo "✓ Consumer API contract verified."
