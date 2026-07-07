#!/usr/bin/env bash
# Run consumer API contract tests (canonical surface + full journey).
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR/.."

echo "==> Start Postgres (dev + test)"
docker compose up -d postgres postgres_test >/dev/null

echo "==> Apply migrations (dev database)"
dart bin/main.dart --apply-migrations 2>/dev/null || true

echo "==> Consumer API contract verification"
dart test \
  test/integration/canonical_api_surface_test.dart \
  test/integration/consumer_journey_contract_test.dart

echo "✓ Consumer API contract verified."
