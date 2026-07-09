#!/usr/bin/env bash
# Overlay user-side backend from origin/anubudhathoki while preserving vendor 3D,
# multiview uploads, and other rosikagajurel server extensions.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FLUTTER_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
REPO_ROOT="$(cd "$FLUTTER_DIR/.." && pwd)"
SERVER_DIR="$REPO_ROOT/placeify_server"
ANUBH_WORKTREE="${ANUBH_WORKTREE:-/tmp/placeify-anubudhathoki}"
PRESERVE_DIR="${PRESERVE_DIR:-/tmp/placeify-preserve-anubh-$$}"
BACKUP_BRANCH="backup/rosikagajurel-pre-anubudh-$(date +%Y%m%d%H%M%S)"

if [[ ! -d "$ANUBH_WORKTREE/placeify_server" ]]; then
  echo "Worktree missing at $ANUBH_WORKTREE"
  echo "Run: git fetch origin anubudhathoki && git worktree add -f $ANUBH_WORKTREE origin/anubudhathoki"
  exit 1
fi

cd "$REPO_ROOT"
CURRENT_BRANCH="$(git branch --show-current)"
echo "==> Backup branch: $BACKUP_BRANCH"
git branch "$BACKUP_BRANCH" 2>/dev/null || true

PRESERVE_PATHS=(
  "placeify_server/lib/src/models/product.spy.yaml"
  "placeify_server/lib/src/modules/vendor"
  "placeify_flutter/lib/core/config"
  "placeify_flutter/lib/features/vendor/data/serverpod_vendor_product_repository.dart"
  "placeify_flutter/lib/features/vendor/data/product_image_service.dart"
  "placeify_flutter/lib/features/product_detail"
  "placeify_flutter/assets/config.json"
  "placeify_flutter/scripts"
  ".vscode"
)

echo "==> Save preserved files"
mkdir -p "$PRESERVE_DIR"
for path in "${PRESERVE_PATHS[@]}"; do
  if [[ -e "$REPO_ROOT/$path" ]]; then
    mkdir -p "$PRESERVE_DIR/$(dirname "$path")"
    cp -R "$REPO_ROOT/$path" "$PRESERVE_DIR/$path"
  fi
done

echo "==> Copy anubudhathoki user backend artifacts"
ANUB_SERVER="$ANUBH_WORKTREE/placeify_server"
DEST_SERVER="$SERVER_DIR"

for f in \
  lib/src/models/payment_method.spy.yaml \
  lib/src/models/user_order_detail.spy.yaml \
  lib/src/models/user_order_delivery_event.spy.yaml \
  lib/src/models/user_order_line_item.spy.yaml \
  lib/src/models/user_order_payment_summary.spy.yaml \
  lib/src/modules/user/user_order_store.dart \
  lib/src/modules/user/user_payment_store.dart \
  lib/src/modules/checkout/checkout_order_setup.dart; do
  cp "$ANUB_SERVER/$f" "$DEST_SERVER/$f"
done

cp "$ANUBH_WORKTREE/placeify_flutter/lib/features/orders/data/serverpod_order_repository.dart" \
  "$FLUTTER_DIR/lib/features/orders/data/"
cp "$ANUBH_WORKTREE/placeify_flutter/lib/features/orders/data/order_api_mapper.dart" \
  "$FLUTTER_DIR/lib/features/orders/data/"

if [[ "$(uname)" == "Darwin" ]]; then
  find "$FLUTTER_DIR/lib/features/orders/data" -name 'serverpod_order_repository.dart' -o -name 'order_api_mapper.dart' | \
    xargs sed -i '' 's/package:placeify\//package:placeify_flutter\//g'
else
  find "$FLUTTER_DIR/lib/features/orders/data" -name 'serverpod_order_repository.dart' -o -name 'order_api_mapper.dart' | \
    xargs sed -i 's/package:placeify\//package:placeify_flutter\//g'
fi

if [[ -d "$ANUB_SERVER/migrations/20260622042659795" ]]; then
  cp -R "$ANUB_SERVER/migrations/20260622042659795" "$DEST_SERVER/migrations/"
  if ! grep -q 20260622042659795 "$DEST_SERVER/migrations/migration_registry.txt"; then
    echo "20260622042659795" >> "$DEST_SERVER/migrations/migration_registry.txt"
  fi
fi

echo "==> Restore preserved vendor / AR files"
for path in "${PRESERVE_PATHS[@]}"; do
  if [[ -e "$PRESERVE_DIR/$path" ]]; then
    mkdir -p "$REPO_ROOT/$(dirname "$path")"
    cp -R "$PRESERVE_DIR/$path" "$REPO_ROOT/$path"
  fi
done

echo "==> Regenerate protocol + client"
cd "$SERVER_DIR"
serverpod generate
cd "$REPO_ROOT"
dart pub get
cd "$FLUTTER_DIR"
dart run build_runner build

echo
echo "Done on branch $CURRENT_BRANCH (backup: $BACKUP_BRANCH)"
echo "Apply DB migration: cd placeify_server && dart bin/main.dart --apply-migrations"
