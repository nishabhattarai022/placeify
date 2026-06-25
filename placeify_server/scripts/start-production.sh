#!/usr/bin/env bash
set -euo pipefail

# Start Placeify server in production mode with migrations.
# Required env vars: see PRODUCTION_AUTH.md

SERVER_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$SERVER_DIR"

: "${SERVERPOD_PASSWORD_database:?Set SERVERPOD_PASSWORD_database}"
: "${SERVERPOD_PASSWORD_serviceSecret:?Set SERVERPOD_PASSWORD_serviceSecret}"
: "${SERVERPOD_PASSWORD_emailSecretHashPepper:?Set SERVERPOD_PASSWORD_emailSecretHashPepper}"
: "${SERVERPOD_PASSWORD_jwtRefreshTokenHashPepper:?Set SERVERPOD_PASSWORD_jwtRefreshTokenHashPepper}"
: "${SERVERPOD_PASSWORD_jwtHmacSha512PrivateKey:?Set SERVERPOD_PASSWORD_jwtHmacSha512PrivateKey}"

echo "==> Starting Placeify server (production, apply migrations)"
dart bin/main.dart --mode production --apply-migrations
