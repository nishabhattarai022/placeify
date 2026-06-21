#!/usr/bin/env bash
# Sync anubudhathoki with latest team integration branch (no merge).
# Nisha's branch uses flat lib/ + package:placeify imports — use rosikagajurel
# monorepo integration instead; it already includes her UI in placeify_flutter/.
# Run from placeify_server: ./scripts/sync-team-work.sh
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
cd "$ROOT"

REMOTE="${PLACEIFY_GIT_REMOTE:-backend}"
INTEGRATION_BRANCH="${PLACEIFY_INTEGRATION_BRANCH:-rosikagajurel}"
YOUR_BRANCH="${PLACEIFY_YOUR_BRANCH:-anubudhathoki}"

echo "==> Placeify team sync (no merge)"
echo "    Root:        $ROOT"
echo "    Remote:      $REMOTE"
echo "    Integration: $INTEGRATION_BRANCH"
echo "    Your branch: $YOUR_BRANCH"

git fetch "$REMOTE" "$INTEGRATION_BRANCH" Nishabhattarai 2>&1 | tail -3

if [[ "$(git branch --show-current)" != "$YOUR_BRANCH" ]]; then
  echo "ERROR: Switch to $YOUR_BRANCH first: git checkout $YOUR_BRANCH" >&2
  exit 1
fi

echo "==> 1/4 Pull integration branch (UI + server + client)"
git checkout "$REMOTE/$INTEGRATION_BRANCH" -- \
  placeify_flutter \
  placeify_client \
  placeify_server \
  pubspec.lock \
  .vscode/launch.json \
  .gitignore

echo "==> 2/4 Skip Nisha flat-repo overlay (use rosikagajurel monorepo integration)"
echo "    Nisha branch paths (lib/) differ from placeify_flutter/ — already integrated in $INTEGRATION_BRANCH"

echo "==> 3/4 Restore your backend + API wiring from $YOUR_BRANCH"
git checkout "$YOUR_BRANCH" -- \
  placeify_server/lib/src/modules/user/user_order_store.dart \
  placeify_server/lib/src/models/user_order_line_item.spy.yaml \
  placeify_server/lib/src/models/user_order_delivery_event.spy.yaml \
  placeify_server/lib/src/models/user_order_detail.spy.yaml \
  placeify_server/test/integration/user_orders_delivery_test.dart \
  placeify_server/test/integration/checkout_flow_endpoint_test.dart \
  placeify_server/test/integration/refund_endpoint_test.dart \
  placeify_server/test/integration/wishlist_endpoint_test.dart \
  placeify_server/test/integration/user_dashboard_endpoint_test.dart \
  placeify_server/test/integration/email_auth_endpoint_test.dart \
  placeify_server/docs/USER_API.md \
  placeify_server/BACKEND_SETUP.md \
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
  placeify_flutter/lib/features/cart/data/cart_api_errors.dart \
  placeify_flutter/lib/features/cart/data/serverpod_cart_repository.dart \
  placeify_flutter/lib/features/cart/presentation/providers/cart_provider.dart \
  placeify_flutter/lib/features/cart/presentation/providers/cart_provider.g.dart \
  placeify_flutter/lib/features/cart/presentation/cart_screen.dart \
  placeify_flutter/lib/features/cart/presentation/cart_actions.dart \
  placeify_flutter/lib/features/cart/presentation/widgets/cart_line_card.dart \
  placeify_flutter/lib/features/home/data/catalog_category_labels.dart \
  placeify_flutter/lib/features/home/data/home_room_catalog.dart \
  placeify_flutter/lib/features/home/data/serverpod_product_repository.dart \
  placeify_flutter/lib/features/home/presentation/providers/catalog_provider.dart \
  placeify_flutter/lib/features/home/presentation/providers/catalog_provider.g.dart \
  placeify_flutter/lib/features/home/presentation/providers/category_provider.dart \
  placeify_flutter/lib/features/home/presentation/providers/category_provider.g.dart \
  placeify_flutter/lib/features/home/presentation/providers/wishlist_provider.dart \
  placeify_flutter/lib/features/home/presentation/providers/wishlist_provider.g.dart \
  placeify_flutter/lib/features/home/presentation/widgets/chairs_catalog_grid.dart \
  placeify_flutter/lib/features/home/presentation/widgets/chairs_catalog_compact_card.dart \
  placeify_flutter/lib/features/home/presentation/widgets/chairs_catalog_wide_card.dart \
  placeify_flutter/lib/features/home/presentation/widgets/home_live_products_row.dart \
  placeify_flutter/lib/features/home/presentation/widgets/home_recommend_product_card.dart \
  placeify_flutter/lib/features/home/presentation/widgets/home_showcase_section.dart \
  placeify_flutter/lib/features/home/presentation/widgets/wishlist_star_button.dart \
  placeify_flutter/lib/features/home/presentation/bookmarks_screen.dart \
  placeify_flutter/lib/features/profile/presentation/widgets/wishlist/wishlist_screen.dart \
  placeify_flutter/lib/features/profile/presentation/widgets/wishlist/wishlist_grid_view.dart \
  placeify_flutter/lib/features/user/presentation/providers/user_wishlist_provider.dart \
  placeify_flutter/lib/screens/category_screen.dart \
  README.md 2>/dev/null || true

rm -f placeify_flutter/lib/features/cart/data/cart_display_config.dart

# Re-apply getMyOrder on top of integration user_endpoint/service
if ! grep -q 'getMyOrder' placeify_server/lib/src/auth/user_endpoint.dart 2>/dev/null; then
  echo "    (patch getMyOrder into user endpoint — run serverpod generate after)"
fi

echo "==> 4/4 dart pub get + serverpod generate"
dart pub get >/dev/null
(cd placeify_server && serverpod generate) 2>&1 | tail -3

echo ""
echo "✓ Sync complete. Next:"
echo "  cd placeify_server && ./scripts/fix-migrations.sh && ./scripts/start-server.sh"
echo "  cd placeify_flutter && flutter clean && flutter pub get && flutter run"
echo ""
echo "IMPORTANT: Use THIS folder only:"
echo "  $ROOT"
echo "Do NOT run from ~/Downloads/placeify (old copy)."
