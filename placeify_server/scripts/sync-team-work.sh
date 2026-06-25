#!/usr/bin/env bash
# Sync anubudhathoki with latest team work (no merge).
# 1) rosikagajurel — integrated monorepo (UI + server + client)
# 2) Nishabhattarai — curated newer UI (shops masonry, vendor reg, admin approvals)
# 3) Your branch — order delivery, tests, migration scripts, live cart API
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
cd "$ROOT"

REMOTE="${PLACEIFY_GIT_REMOTE:-backend}"
INTEGRATION_BRANCH="${PLACEIFY_INTEGRATION_BRANCH:-rosikagajurel}"
NISHA_BRANCH="${PLACEIFY_UI_BRANCH:-Nishabhattarai}"
YOUR_BRANCH="${PLACEIFY_YOUR_BRANCH:-anubudhathoki}"

echo "==> Placeify team sync (no merge)"
echo "    Root:        $ROOT"
echo "    Integration: $REMOTE/$INTEGRATION_BRANCH"
echo "    UI updates:  $REMOTE/$NISHA_BRANCH (curated)"
echo "    Your branch: $YOUR_BRANCH"

git fetch "$REMOTE" "$INTEGRATION_BRANCH" "$NISHA_BRANCH" 2>&1 | tail -5

if [[ "$(git branch --show-current)" != "$YOUR_BRANCH" ]]; then
  echo "ERROR: Switch to $YOUR_BRANCH first: git checkout $YOUR_BRANCH" >&2
  exit 1
fi

echo "==> 1/5 Pull integration branch (monorepo UI + server + client)"
git checkout "$REMOTE/$INTEGRATION_BRANCH" -- \
  placeify_flutter \
  placeify_client \
  placeify_server \
  pubspec.lock \
  .vscode/launch.json \
  .gitignore

echo "==> 2/5 Port curated newer UI from $NISHA_BRANCH"
NISHA_FILES=(
  core/widgets/phone_input_field.dart
  core/widgets/placeify_bottom_sheet.dart
  data/furniture_categories.dart
  features/admin/presentation/vendor_approvals/vendor_application_detail_screen.dart
  features/admin/presentation/vendor_approvals/widgets/vendor_application_approve_sheet.dart
  features/admin/presentation/vendor_approvals/widgets/vendor_application_decline_sheet.dart
  features/admin/presentation/vendor_approvals/widgets/application_detail_sections.dart
  features/admin/presentation/widgets/admin_application_row.dart
  features/profile/presentation/widgets/shared/profile_form_field.dart
  features/shops/data/shop_listing_images.dart
  features/shops/presentation/widgets/shop_listing_image.dart
  features/shops/presentation/widgets/vendor_card_compact.dart
  features/shops/presentation/widgets/vendor_card_full.dart
  features/shops/presentation/widgets/vendor_card_minimal.dart
  features/shops/presentation/widgets/vendor_grid_shimmer.dart
  features/shops/presentation/widgets/vendor_masonry_grid.dart
  features/shops/presentation/shops_screen.dart
  features/shops/domain/constants/shop_strings.dart
  features/vendor/domain/constants/vendor_strings.dart
  features/vendor/domain/validators/vendor_registration_validator.dart
  features/vendor/presentation/registration/vendor_registration_screen.dart
  features/vendor/presentation/registration/steps/address_step.dart
  features/vendor/presentation/registration/steps/bank_details_step.dart
  features/vendor/presentation/registration/steps/business_info_step.dart
  features/vendor/presentation/registration/steps/category_step.dart
  features/vendor/presentation/registration/steps/document_upload_step.dart
  features/vendor/presentation/registration/steps/review_submit_step.dart
  features/vendor/presentation/registration/widgets/vendor_registration_error_banner.dart
  features/vendor/presentation/registration/widgets/vendor_registration_hero.dart
  features/vendor/presentation/providers/vendor_registration_provider.dart
  features/vendor/domain/models/vendor_registration.dart
  features/vendor/domain/models/vendor_registration.freezed.dart
  features/vendor/domain/models/vendor_registration.g.dart
  features/vendor/presentation/profile/vendor_profile_screen.dart
  features/vendor/presentation/vendor_settings_screen.dart
)

ported=0
for rel in "${NISHA_FILES[@]}"; do
  src="lib/$rel"
  dest="placeify_flutter/lib/$rel"
  if git cat-file -e "$REMOTE/$NISHA_BRANCH:$src" 2>/dev/null; then
    mkdir -p "$(dirname "$dest")"
    git show "$REMOTE/$NISHA_BRANCH:$src" \
      | sed -e 's|package:placeify/|package:placeify_flutter/|g' \
      > "$dest"
    ported=$((ported + 1))
  fi
done
echo "    Ported $ported curated UI files"

echo "==> 3/5 Restore your backend + live API wiring"
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
  README.md \
  WORKSPACE.md 2>/dev/null || true

rm -f placeify_flutter/lib/features/cart/data/cart_display_config.dart

echo "==> 4/5 dart pub get + serverpod generate + build_runner"
dart pub get >/dev/null
(cd placeify_server && serverpod generate) 2>&1 | tail -3
(cd placeify_flutter && dart run build_runner build) 2>&1 | tail -3

echo "==> 5/5 Re-apply patches (getMyOrder, admin actions, registration repo)"
# Patches are committed in repo; re-run after sync if needed:
# - user_service/user_endpoint getMyOrder
# - vendor_applications_provider (sync repo + Nisha mounted checks)
# - vendor_registration_provider (sync repo, not .future)

echo ""
echo "✓ Sync complete."
echo ""
echo "Next:"
echo "  cd placeify_server && ./scripts/fix-migrations.sh && ./scripts/start-server.sh"
echo "  cd placeify_flutter && flutter clean && flutter pub get && flutter run -d chrome"
echo ""
echo "Use ONLY: $ROOT"
echo "NOT ~/Downloads/placeify (stale copy)."
