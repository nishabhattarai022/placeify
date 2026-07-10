#!/usr/bin/env bash
# Re-apply Serverpod backend integration after any UI port (Nisha/Rosika).
# Run from repo root: bash placeify_server/scripts/restore-backend-wiring.sh
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
cd "$ROOT"

REF="${PLACEIFY_WIRING_REF:-HEAD}"

echo "==> Restore backend wiring from $REF"

WIRING_FILES=(
  placeify_flutter/lib/main.dart
  placeify_flutter/lib/core/config/placeify_server_client.dart
  placeify_flutter/lib/core/config/resolve_media_url.dart
  placeify_flutter/lib/core/config/resolve_server_url.dart
  placeify_flutter/assets/config.json
  placeify_flutter/lib/features/auth/domain/models/app_user.dart
  placeify_flutter/lib/features/auth/data/mock_auth_repository.dart
  placeify_flutter/lib/features/auth/domain/repositories/auth_repository.dart
  placeify_flutter/lib/features/auth/data/serverpod_auth_repository.dart
  placeify_flutter/lib/features/auth/presentation/providers/auth_provider.dart
  placeify_flutter/lib/features/auth/presentation/providers/auth_provider.g.dart
  placeify_flutter/lib/features/cart/data/cart_api_errors.dart
  placeify_flutter/lib/features/cart/data/serverpod_cart_repository.dart
  placeify_flutter/lib/features/cart/data/product_id_codec.dart
  placeify_flutter/lib/features/cart/domain/constants/cart_strings.dart
  placeify_flutter/lib/features/home/presentation/providers/category_provider.dart
  placeify_flutter/lib/features/home/presentation/providers/category_provider.g.dart
  placeify_flutter/lib/features/home/presentation/providers/wishlist_provider.dart
  placeify_flutter/lib/features/home/presentation/providers/wishlist_toggle_result.dart
  placeify_flutter/lib/features/home/presentation/providers/wishlist_count.dart
  placeify_flutter/lib/features/home/presentation/providers/wishlist_provider.g.dart
  placeify_flutter/lib/features/orders/data/serverpod_order_repository.dart
  placeify_flutter/lib/features/profile/data/serverpod_wishlist_repository.dart
  placeify_flutter/lib/features/profile/data/wishlist_api_errors.dart
  placeify_flutter/lib/features/profile/presentation/widgets/wishlist/wishlist_grid_view.dart
  placeify_flutter/lib/features/profile/presentation/widgets/wishlist/wishlist_screen.dart
  placeify_flutter/lib/features/home/presentation/widgets/wishlist_star_button.dart
  placeify_flutter/lib/features/product_detail/presentation/widgets/product_detail_header.dart
  placeify_flutter/lib/features/product_detail/presentation/product_detail_screen.dart
  placeify_flutter/lib/features/product_detail/presentation/widgets/product_detail_gallery.dart
  placeify_flutter/lib/features/product_detail/presentation/widgets/product_3d_preview.dart
  placeify_flutter/lib/features/product_detail/data/product_3d_model_loader.dart
  placeify_flutter/lib/features/product_detail/data/product_3d_model_resolver.dart
  placeify_server/lib/src/modules/user/user_repository.dart
  placeify_server/lib/src/modules/product/catalog_seed.dart
  placeify_server/docs/CONSUMER_API_CONTRACT.md
  placeify_flutter/lib/features/cart/presentation/providers/cart_provider.dart
  placeify_flutter/lib/features/cart/presentation/providers/cart_provider.g.dart
  placeify_flutter/lib/features/cart/presentation/cart_actions.dart
  placeify_flutter/lib/features/cart/presentation/widgets/cart_line_card.dart
  placeify_flutter/lib/features/home/data/catalog_category_utils.dart
  placeify_flutter/lib/features/home/data/catalog_product_mapper.dart
  placeify_flutter/lib/features/home/data/serverpod_product_repository.dart
  placeify_flutter/lib/features/home/presentation/providers/catalog_provider.dart
  placeify_flutter/lib/features/home/presentation/providers/catalog_provider.g.dart
  placeify_flutter/lib/features/home/presentation/providers/home_room_provider.dart
  placeify_flutter/lib/features/home/presentation/providers/home_room_provider.g.dart
  placeify_flutter/lib/screens/category_screen.dart
  placeify_flutter/lib/screens/browse_screen.dart
  placeify_flutter/lib/core/router/app_router.dart
  placeify_flutter/lib/features/auth/presentation/login_screen.dart
  placeify_server/lib/src/modules/admin/admin_endpoint.dart
  placeify_server/lib/src/modules/admin/admin_service.dart
  placeify_server/lib/src/modules/admin/admin_platform_repository.dart
  placeify_server/lib/src/modules/admin/admin_moderation_repository.dart
  placeify_flutter/lib/features/orders/data/order_api_mapper.dart
  placeify_flutter/lib/features/orders/presentation/providers/orders_provider.dart
  placeify_flutter/lib/features/orders/presentation/providers/orders_provider.g.dart
  placeify_flutter/lib/features/profile/presentation/providers/profile_dashboard_provider.dart
  placeify_flutter/lib/features/profile/presentation/providers/profile_dashboard_provider.g.dart
  placeify_flutter/lib/features/profile/data/profile_refund_mapper.dart
  placeify_flutter/lib/features/profile/data/profile_dashboard_mapper.dart
  placeify_flutter/lib/features/profile/data/profile_ar_session_mapper.dart
  placeify_flutter/lib/features/profile/data/profile_notification_mapper.dart
  placeify_flutter/lib/features/profile/presentation/profile_refund_screen.dart
  placeify_flutter/lib/features/profile/presentation/profile_notifications_screen.dart
  placeify_flutter/lib/features/profile/presentation/profile_ar_history_screen.dart
  placeify_flutter/lib/features/profile/presentation/profile_home_screen.dart
  placeify_flutter/lib/features/profile/presentation/widgets/profile_stats_strip.dart
  placeify_flutter/lib/features/profile/presentation/widgets/refund/refund_summary_card.dart
  placeify_flutter/lib/features/profile/presentation/providers/profile_refunds_provider.dart
  placeify_flutter/lib/features/profile/presentation/providers/profile_notifications_provider.dart
  placeify_flutter/lib/features/user/presentation/providers/user_wishlist_provider.dart
  placeify_flutter/lib/features/user/presentation/providers/user_wishlist_provider.g.dart
  placeify_flutter/lib/features/vendor/presentation/providers/vendor_orders_provider.dart
  placeify_flutter/lib/features/vendor/presentation/providers/vendor_orders_provider.g.dart
  placeify_flutter/lib/features/vendor/presentation/providers/vendor_profile_provider.dart
  placeify_flutter/lib/features/vendor/data/hybrid_vendor_repository.dart
  placeify_flutter/lib/features/vendor/data/serverpod_vendor_repository.dart
  placeify_flutter/lib/features/vendor/data/serverpod_vendor_order_repository.dart
  placeify_flutter/lib/features/vendor/data/serverpod_vendor_profile_repository.dart
  placeify_flutter/lib/features/vendor/data/serverpod_vendor_product_repository.dart
  placeify_flutter/lib/features/vendor/domain/models/vendor_profile.dart
  placeify_flutter/lib/features/vendor/domain/models/vendor_profile.freezed.dart
  placeify_flutter/lib/features/vendor/domain/models/vendor_profile.g.dart
  placeify_server/BACKEND_SETUP.md
  placeify_server/docs/USER_API.md
  placeify_server/lib/src/modules/user/user_order_store.dart
  placeify_server/scripts/fix-migrations.sh
  placeify_server/scripts/migration-dev-utils.sh
  placeify_server/scripts/apply-migrations.sh
  placeify_server/scripts/apply-test-migrations.sh
  placeify_server/scripts/ensure-schema-repair.sh
  placeify_server/scripts/verify-consumer-contract.sh
  placeify_server/migrations/migration_registry.txt
  placeify_server/scripts/start-server.sh
)

restored=0
for path in "${WIRING_FILES[@]}"; do
  if git cat-file -e "$REF:$path" 2>/dev/null; then
    git checkout "$REF" -- "$path"
    restored=$((restored + 1))
  fi
done

rm -f placeify_flutter/lib/features/cart/data/cart_display_config.dart

bash "$SCRIPT_DIR/wire-cart-checkout.sh"

echo "    Restored $restored files from $REF"
echo "✓ Backend wiring restored."
