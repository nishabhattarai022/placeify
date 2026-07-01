#!/usr/bin/env bash
# Verify admin backend APIs used by the Flutter admin panel.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SERVER_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$SERVER_DIR"
echo "==> Running admin endpoint integration tests"
dart test test/integration/admin_endpoint_test.dart

echo "==> Admin backend verification passed"
