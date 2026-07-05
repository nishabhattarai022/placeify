#!/usr/bin/env bash
# Full consumer-backend readiness gate before frontend wiring.
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

echo "==> Consumer API contract"
dart test \
  test/integration/canonical_api_surface_test.dart \
  test/integration/consumer_journey_contract_test.dart

echo "==> Catalog seed + ratings + shops"
dart test \
  test/integration/catalog_seed_contract_test.dart \
  test/integration/product_catalog_ratings_test.dart \
  test/integration/list_approved_shops_test.dart

echo "==> Cart policy + checkout/orders"
dart test \
  test/integration/vendor_own_shop_cart_test.dart \
  test/integration/user_orders_delivery_test.dart \
  test/integration/user_payment_flow_test.dart

echo "==> Wishlist + profile"
dart test \
  test/integration/wishlist_endpoint_test.dart \
  test/integration/profile_image_upload_test.dart

echo "==> End-to-end consumer readiness"
dart test test/integration/consumer_backend_readiness_test.dart

echo "✓ Backend ready for frontend wiring."
