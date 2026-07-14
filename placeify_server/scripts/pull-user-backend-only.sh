#!/usr/bin/env bash
# Pull only user-related backend code from origin/anubudhathoki.
# Preserves vendor, order lifecycle, notifications, marketplace, checkout/payment stores.
set -euo pipefail

SERVER_DIR="$(cd "$(dirname "$0")/.." && pwd)"
REPO_ROOT="$(cd "$SERVER_DIR/.." && pwd)"
BRANCH="${ANUBUDH_BRANCH:-origin/anubudhathoki}"
BACKUP_BRANCH="backup/$(git -C "$REPO_ROOT" branch --show-current)-pre-user-backend-$(date +%Y%m%d%H%M%S)"
PRESERVE_DIR="${PRESERVE_DIR:-/tmp/placeify-preserve-user-backend-$$}"

PRESERVE_PATHS=(
  "placeify_server/lib/src/modules/vendor"
  "placeify_server/lib/src/modules/checkout/checkout_repository.dart"
  "placeify_server/lib/src/modules/payment/payment_repository.dart"
  "placeify_server/lib/src/modules/order/order_lifecycle_store.dart"
  "placeify_server/lib/src/modules/order/order_auto_cancel_service.dart"
  "placeify_server/lib/src/modules/order/order_auto_cancel_future_call.dart"
  "placeify_server/lib/src/modules/order/order_service.dart"
  "placeify_server/lib/src/modules/notification"
  "placeify_server/lib/src/modules/marketplace"
)

SERVER_PULL_PATHS=(
  "placeify_server/lib/src/auth/user_endpoint.dart"
  "placeify_server/lib/src/modules/user"
  "placeify_server/lib/src/modules/cart"
  "placeify_server/lib/src/modules/wishlist"
  "placeify_server/lib/src/modules/refund"
  "placeify_server/lib/src/modules/checkout/checkout_endpoint.dart"
  "placeify_server/lib/src/modules/checkout/checkout_service.dart"
  "placeify_server/lib/src/modules/checkout/checkout_order_setup.dart"
  "placeify_server/lib/src/modules/order/order_endpoint.dart"
  "placeify_server/test/integration/user_dashboard_endpoint_test.dart"
  "placeify_server/test/integration/user_orders_delivery_test.dart"
  "placeify_server/test/integration/user_payment_flow_test.dart"
  "placeify_server/test/integration/user_endpoint_test.dart"
  "placeify_server/test/integration/wishlist_endpoint_test.dart"
  "placeify_server/test/integration/checkout_flow_endpoint_test.dart"
  "placeify_server/test/integration/refund_endpoint_test.dart"
  "placeify_server/test/integration/consumer_journey_contract_test.dart"
  "placeify_server/test/integration/email_auth_endpoint_test.dart"
  "placeify_server/test/integration/test_tools/user_test_helpers.dart"
)

checkout_path() {
  local path="$1"
  if git -C "$REPO_ROOT" cat-file -e "$BRANCH:$path" 2>/dev/null; then
    git -C "$REPO_ROOT" checkout "$BRANCH" -- "$path"
    echo "  + $path"
  else
    echo "  ! missing: $path" >&2
  fi
}

cd "$REPO_ROOT"

echo "==> Fetching $BRANCH"
git fetch origin anubudhathoki

echo "==> Backup branch: $BACKUP_BRANCH"
git branch "$BACKUP_BRANCH" HEAD 2>/dev/null || true

echo "==> Preserve rosikagajurel extensions"
mkdir -p "$PRESERVE_DIR"
for path in "${PRESERVE_PATHS[@]}"; do
  if [[ -e "$REPO_ROOT/$path" ]]; then
    mkdir -p "$PRESERVE_DIR/$(dirname "$path")"
    cp -R "$REPO_ROOT/$path" "$PRESERVE_DIR/$path"
  fi
done

echo "==> Pull user backend (server only) from $BRANCH"
for path in "${SERVER_PULL_PATHS[@]}"; do
  checkout_path "$path"
done

echo "==> Restore preserved files"
for path in "${PRESERVE_PATHS[@]}"; do
  if [[ -e "$PRESERVE_DIR/$path" ]]; then
    mkdir -p "$REPO_ROOT/$(dirname "$path")"
    rm -rf "$REPO_ROOT/$path"
    cp -R "$PRESERVE_DIR/$path" "$REPO_ROOT/$path"
    echo "  restored $path"
  fi
done

echo "==> Done. Backup branch: $BACKUP_BRANCH"
