#!/usr/bin/env bash
# Pull latest rosikagajurel monorepo (no git merge). Preserves anubudhathoki
# server tooling, migration helpers, and sync scripts.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
cd "$ROOT"

REMOTE="${PLACEIFY_GIT_REMOTE:-backend}"
INTEGRATION_BRANCH="${PLACEIFY_INTEGRATION_BRANCH:-rosikagajurel}"
YOUR_BRANCH="${PLACEIFY_YOUR_BRANCH:-anubudhathoki}"
REF="$REMOTE/$INTEGRATION_BRANCH"
PRESERVE_DIR="${ROOT}/.sync-preserve-rosika-$(date +%Y%m%d%H%M%S)"

echo "==> Pull $REF into $YOUR_BRANCH (no merge)"
echo "    Preserve dir: $PRESERVE_DIR"

git fetch "$REMOTE" "$INTEGRATION_BRANCH"

if [[ "$(git branch --show-current)" != "$YOUR_BRANCH" ]]; then
  echo "ERROR: Switch to $YOUR_BRANCH first" >&2
  exit 1
fi

mkdir -p "$PRESERVE_DIR/placeify_server/scripts"
for f in placeify_server/scripts/*.sh; do
  [[ -f "$f" ]] && cp "$f" "$PRESERVE_DIR/placeify_server/scripts/"
done
[[ -f placeify_server/BACKEND_SETUP.md ]] && \
  cp placeify_server/BACKEND_SETUP.md "$PRESERVE_DIR/placeify_server/"

echo "==> Checkout monorepo from $REF"
git checkout "$REF" -- \
  placeify_flutter \
  placeify_client \
  placeify_server \
  pubspec.lock \
  .vscode/launch.json \
  .gitignore

echo "==> Restore anubudhathoki server scripts + docs"
mkdir -p placeify_server/scripts
if compgen -G "$PRESERVE_DIR/placeify_server/scripts/*.sh" > /dev/null; then
  cp -R "$PRESERVE_DIR/placeify_server/scripts/." placeify_server/scripts/
fi
[[ -f "$PRESERVE_DIR/placeify_server/BACKEND_SETUP.md" ]] && \
  cp "$PRESERVE_DIR/placeify_server/BACKEND_SETUP.md" placeify_server/BACKEND_SETUP.md

git checkout "$YOUR_BRANCH" -- \
  placeify_server/docs/USER_API.md \
  placeify_server/scripts/fix-migrations.sh \
  placeify_server/scripts/migration-dev-utils.sh \
  placeify_server/scripts/reconcile-migrations.sh \
  placeify_server/scripts/reset-dev-database.sh \
  placeify_server/scripts/start-server.sh \
  placeify_server/scripts/stop-server.sh \
  placeify_server/scripts/setup.sh \
  placeify_server/scripts/start-production.sh \
  placeify_server/scripts/apply-migrations.sh \
  placeify_server/scripts/run-tests.sh \
  2>/dev/null || true

echo "==> dart pub get + serverpod generate + build_runner"
dart pub get >/dev/null
(cd placeify_server && dart pub global run serverpod_cli generate) 2>&1 | tail -5
(cd placeify_flutter && dart run build_runner build) 2>&1 | tail -5

echo ""
echo "✓ Rosika integration pull complete."
echo "  Backup: $PRESERVE_DIR"
