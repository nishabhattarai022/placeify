#!/usr/bin/env bash
# Overlay user-backend from origin/anubudhathoki while preserving rosikagajurel
# extensions: order lifecycle, in-app notifications, vendor 3D/AR, marketplace.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FLUTTER_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
REPO_ROOT="$(cd "$FLUTTER_DIR/.." && pwd)"
BRANCH="${ANUBUDH_BRANCH:-origin/anubudhathoki}"
BACKUP_BRANCH="backup/$(git branch --show-current)-pre-anubudh-$(date +%Y%m%d%H%M%S)"
PRESERVE_DIR="${PRESERVE_DIR:-/tmp/placeify-preserve-anubh-$$}"

# Server: consumer/user backend modules + docs + scripts + tests.
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
  "placeify_server/docs"
  "placeify_server/BACKEND_SETUP.md"
  "placeify_server/AUTH_QA_CHECKLIST.md"
  "placeify_server/PRODUCTION_AUTH.md"
  "placeify_server/scripts"
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

# Flutter user cart + live catalog wiring from anubudhathoki.
FLUTTER_PULL_PATHS=(
  "placeify_flutter/lib/features/cart/data/cart_api_errors.dart"
  "placeify_flutter/lib/features/cart/data/cart_display_config.dart"
  "placeify_flutter/lib/features/cart/domain/constants/cart_strings.dart"
  "placeify_flutter/lib/features/cart/data/serverpod_cart_repository.dart"
  "placeify_flutter/lib/features/cart/presentation/cart_actions.dart"
  "placeify_flutter/lib/features/cart/presentation/cart_screen.dart"
  "placeify_flutter/lib/features/cart/presentation/providers/cart_provider.dart"
  "placeify_flutter/lib/features/home/data/catalog_category_utils.dart"
  "placeify_flutter/lib/features/home/data/serverpod_product_repository.dart"
  "placeify_flutter/lib/features/home/presentation/widgets/chairs_catalog_grid.dart"
  "placeify_flutter/lib/features/home/presentation/widgets/home_live_products_row.dart"
  "placeify_flutter/lib/features/home/presentation/widgets/home_recommend_product_card.dart"
)

MIGRATION_ID="20260622153000000"

PRESERVE_PATHS=(
  "placeify_server/lib/src/models/product.spy.yaml"
  "placeify_server/lib/src/models/vendor_product_upload_input.spy.yaml"
  "placeify_server/lib/src/models/user_dashboard.spy.yaml"
  "placeify_server/lib/src/modules/vendor"
  "placeify_server/lib/src/modules/checkout/checkout_repository.dart"
  "placeify_server/lib/src/modules/payment/payment_repository.dart"
  "placeify_server/lib/src/modules/order/order_lifecycle_store.dart"
  "placeify_server/lib/src/modules/order/order_auto_cancel_service.dart"
  "placeify_server/lib/src/modules/order/order_auto_cancel_future_call.dart"
  "placeify_server/lib/src/modules/order/order_service.dart"
  "placeify_server/lib/src/modules/notification"
  "placeify_server/lib/src/modules/marketplace"
  "placeify_server/lib/src/models/in_app_notification.spy.yaml"
  "placeify_server/lib/src/models/in_app_notification_summary.spy.yaml"
  "placeify_server/lib/src/models/in_app_notification_type.spy.yaml"
  "placeify_server/lib/src/models/order_auto_cancel_trigger.spy.yaml"
  "placeify_server/lib/src/models/order_delivery_status.spy.yaml"
  "placeify_server/lib/src/models/order_payment_status.spy.yaml"
  "placeify_server/lib/src/models/order_status_history.spy.yaml"
  "placeify_server/lib/src/models/order_status_history_type.spy.yaml"
  "placeify_flutter/lib/features/home/data/catalog_product_mapper.dart"
  "placeify_flutter/lib/features/home/data/serverpod_product_repository.dart"
  "placeify_flutter/lib/features/cart/data/product_id_codec.dart"
  "placeify_flutter/lib/features/cart/presentation/cart_screen.dart"
  "placeify_flutter/lib/features/orders/data/order_api_mapper.dart"
  "placeify_flutter/lib/features/orders/presentation/providers/orders_provider.dart"
  "placeify_flutter/lib/features/orders/presentation/providers/customer_in_app_notifications_provider.dart"
  "placeify_flutter/lib/features/product_detail"
  "placeify_flutter/lib/features/vendor"
)

checkout_path() {
  local path="$1"
  if git cat-file -e "$BRANCH:$path" 2>/dev/null; then
    git checkout "$BRANCH" -- "$path"
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

echo "==> Pull user backend (server) from $BRANCH"
for path in "${SERVER_PULL_PATHS[@]}"; do
  checkout_path "$path"
done

echo "==> Pull user backend (Flutter wiring) from $BRANCH"
for path in "${FLUTTER_PULL_PATHS[@]}"; do
  checkout_path "$path"
done

if git cat-file -e "$BRANCH:placeify_server/migrations/$MIGRATION_ID/migration.sql" 2>/dev/null; then
  mkdir -p "$REPO_ROOT/placeify_server/migrations/$MIGRATION_ID"
  for f in migration.sql migration.json definition.sql definition.json definition_project.json; do
    if git cat-file -e "$BRANCH:placeify_server/migrations/$MIGRATION_ID/$f" 2>/dev/null; then
      git checkout "$BRANCH" -- "placeify_server/migrations/$MIGRATION_ID/$f"
    fi
  done
  if ! grep -q "$MIGRATION_ID" "$REPO_ROOT/placeify_server/migrations/migration_registry.txt"; then
    echo "$MIGRATION_ID" >> "$REPO_ROOT/placeify_server/migrations/migration_registry.txt"
    echo "  + migration registry: $MIGRATION_ID"
  fi
fi

echo "==> Restore preserved files"
for path in "${PRESERVE_PATHS[@]}"; do
  if [[ -e "$PRESERVE_DIR/$path" ]]; then
    mkdir -p "$REPO_ROOT/$(dirname "$path")"
    rm -rf "$REPO_ROOT/$path"
    cp -R "$PRESERVE_DIR/$path" "$REPO_ROOT/$path"
  fi
done

echo "==> Done. Next:"
echo "  cd placeify_server && serverpod generate"
echo "  cd placeify_flutter && dart run build_runner build --delete-conflicting-outputs"
echo "  cd placeify_server && dart bin/main.dart --apply-migrations"
echo "  Backup: git checkout $BACKUP_BRANCH -- <file>"
