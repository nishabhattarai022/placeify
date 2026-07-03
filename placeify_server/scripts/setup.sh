#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
SERVER="$ROOT/placeify_server"

echo "==> Installing workspace dependencies"
cd "$ROOT"
dart pub get

echo "==> Ensuring passwords.yaml exists"
if [ ! -f "$SERVER/config/passwords.yaml" ]; then
  cp "$SERVER/config/passwords.yaml.example" "$SERVER/config/passwords.yaml"
  echo "    Created config/passwords.yaml from example"
fi

echo "==> Starting Docker (Postgres + Redis)"
"$SERVER/scripts/ensure-docker.sh"
cd "$SERVER"
docker compose up -d

echo "==> Waiting for Postgres..."
for i in {1..30}; do
  if docker compose exec -T postgres pg_isready -U postgres >/dev/null 2>&1; then
    break
  fi
  sleep 1
done

echo "==> Generating Serverpod code"
serverpod generate

echo "==> Setup complete. Start the server with:"
echo "    cd placeify_server && dart bin/main.dart --apply-migrations"
