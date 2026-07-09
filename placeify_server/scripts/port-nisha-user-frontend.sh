#!/usr/bin/env bash
# Port LATEST origin/Nishabhattarai consumer UI into placeify_flutter.
# Preserves rosika admin, vendor, and Serverpod data wiring only.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
cd "$ROOT"

REMOTE="${PLACEIFY_GIT_REMOTE:-origin}"
BRANCH="${PLACEIFY_UI_BRANCH:-Nishabhattarai}"
REF="$REMOTE/$BRANCH"
PRESERVE_DIR="${PRESERVE_DIR:-/tmp/placeify-preserve-user-$$}"
BACKUP_BRANCH="backup/rosikagajurel-pre-nisha-user-$(date +%Y%m%d%H%M%S)"

WIRING_FILES=(
  placeify_flutter/lib/main.dart
  placeify_flutter/lib/core/config/placeify_server_client.dart
  placeify_flutter/lib/core/config/resolve_media_url.dart
  placeify_flutter/lib/core/config/resolve_server_url.dart
  placeify_flutter/lib/core/config/resolve_server_platform.dart
  placeify_flutter/lib/core/config/resolve_server_url_io.dart
  placeify_flutter/lib/core/config/resolve_server_url_web.dart
  placeify_flutter/assets/config.json
  placeify_flutter/lib/core/services/background_removal_service.dart
  placeify_flutter/lib/features/auth/constants/demo_credentials.dart
  placeify_flutter/lib/features/auth/domain/models/app_user.dart
  placeify_flutter/lib/features/auth/data/mock_auth_repository.dart
  placeify_flutter/lib/features/auth/domain/repositories/auth_repository.dart
  placeify_flutter/lib/features/auth/data/serverpod_auth_repository.dart
  placeify_flutter/lib/features/auth/presentation/providers/auth_provider.dart
  placeify_flutter/lib/features/auth/presentation/providers/auth_provider.g.dart
  placeify_flutter/lib/features/cart/data/cart_api_errors.dart
  placeify_flutter/lib/features/cart/data/serverpod_cart_repository.dart
  placeify_flutter/lib/features/cart/data/product_id_codec.dart
  placeify_flutter/lib/features/cart/presentation/providers/cart_provider.dart
  placeify_flutter/lib/features/cart/presentation/providers/cart_provider.g.dart
  placeify_flutter/lib/features/cart/presentation/cart_actions.dart
  placeify_flutter/lib/features/home/data/catalog_category_utils.dart
  placeify_flutter/lib/features/home/data/catalog_product_mapper.dart
  placeify_flutter/lib/features/home/data/serverpod_product_repository.dart
  placeify_flutter/lib/features/home/data/vendor_product_catalog_mapper.dart
  placeify_flutter/lib/features/home/presentation/providers/catalog_provider.dart
  placeify_flutter/lib/features/home/presentation/providers/catalog_provider.g.dart
  placeify_flutter/lib/features/home/presentation/providers/category_provider.dart
  placeify_flutter/lib/features/home/presentation/providers/category_provider.g.dart
  placeify_flutter/lib/features/home/presentation/providers/wishlist_provider.dart
  placeify_flutter/lib/features/home/presentation/providers/wishlist_toggle_result.dart
  placeify_flutter/lib/features/home/presentation/providers/wishlist_count.dart
  placeify_flutter/lib/features/home/presentation/providers/wishlist_provider.g.dart
  placeify_flutter/lib/features/home/presentation/providers/home_room_provider.dart
  placeify_flutter/lib/features/home/presentation/providers/home_room_provider.g.dart
  placeify_flutter/lib/screens/category_screen.dart
  placeify_flutter/lib/screens/browse_screen.dart
  placeify_flutter/lib/features/orders/data/serverpod_order_repository.dart
  placeify_flutter/lib/features/orders/data/order_api_mapper.dart
  placeify_flutter/lib/features/orders/presentation/providers/orders_provider.dart
  placeify_flutter/lib/features/orders/presentation/providers/orders_provider.g.dart
  placeify_flutter/lib/features/profile/data/serverpod_wishlist_repository.dart
  placeify_flutter/lib/features/profile/data/wishlist_api_errors.dart
  placeify_flutter/lib/features/profile/data/profile_refund_mapper.dart
  placeify_flutter/lib/features/profile/data/profile_dashboard_mapper.dart
  placeify_flutter/lib/features/profile/data/profile_ar_session_mapper.dart
  placeify_flutter/lib/features/profile/data/profile_notification_mapper.dart
  placeify_flutter/lib/features/profile/presentation/providers/profile_dashboard_provider.dart
  placeify_flutter/lib/features/profile/presentation/providers/profile_dashboard_provider.g.dart
  placeify_flutter/lib/features/profile/presentation/providers/profile_refunds_provider.dart
  placeify_flutter/lib/features/profile/presentation/providers/profile_notifications_provider.dart
  placeify_flutter/lib/features/shops/data/serverpod_consumer_shop_repository.dart
  placeify_flutter/lib/features/shops/data/vendor_product_mapper.dart
  placeify_flutter/lib/features/shops/presentation/providers/consumer_shop_provider.dart
  placeify_flutter/lib/features/shops/presentation/providers/consumer_shop_provider.g.dart
  placeify_flutter/lib/features/product_detail/data/product_3d_model_loader.dart
  placeify_flutter/lib/features/product_detail/data/product_3d_model_resolver.dart
  placeify_flutter/lib/features/user/presentation/providers/user_wishlist_provider.dart
  placeify_flutter/lib/features/user/presentation/providers/user_wishlist_provider.g.dart
  placeify_flutter/lib/features/vendor/domain/models/vendor_review.dart
  placeify_flutter/lib/core/router/app_router.dart
  placeify_flutter/lib/features/auth/presentation/login_screen.dart
)

echo "==> Fetch latest $REF"
git fetch "$REMOTE" "$BRANCH"

echo "==> Backup branch: $BACKUP_BRANCH"
git branch "$BACKUP_BRANCH" HEAD 2>/dev/null || true

echo "==> Backup admin + vendor BEFORE stash"
mkdir -p "$PRESERVE_DIR/placeify_flutter/lib/features"
cp -R placeify_flutter/lib/features/admin "$PRESERVE_DIR/placeify_flutter/lib/features/"
cp -R placeify_flutter/lib/features/vendor "$PRESERVE_DIR/placeify_flutter/lib/features/"

mkdir -p "$PRESERVE_DIR/wiring"
for path in "${WIRING_FILES[@]}"; do
  if [[ -f "$ROOT/$path" ]]; then
    mkdir -p "$PRESERVE_DIR/wiring/$(dirname "$path")"
    cp "$ROOT/$path" "$PRESERVE_DIR/wiring/$path"
  fi
done

echo "==> Stash uncommitted work"
git stash push -u -m "pre-nisha-user-frontend-$(date +%Y%m%d%H%M%S)" || true

echo "==> Port ALL consumer/user dart from $REF (skip admin + vendor)"
ported=0
while IFS= read -r src; do
  case "$src" in
    lib/features/admin/*|lib/features/vendor/*) continue ;;
  esac
  rel="${src#lib/}"
  dest="placeify_flutter/lib/$rel"
  mkdir -p "$(dirname "$dest")"
  git show "$REF:$src" | sed 's/package:placeify\//package:placeify_flutter\//g' >"$dest"
  ported=$((ported + 1))
done < <(git ls-tree -r --name-only "$REF" -- lib/ | grep '\.dart$')
echo "    Ported $ported dart files from $(git rev-parse --short "$REF")"

echo "==> Sync assets from $REF"
asset_count=0
while IFS= read -r src; do
  dest="placeify_flutter/$src"
  mkdir -p "$(dirname "$dest")"
  git show "$REF:$src" >"$dest"
  asset_count=$((asset_count + 1))
done < <(git ls-tree -r --name-only "$REF" -- assets/)
echo "    Synced $asset_count asset files"

echo "==> Restore admin + vendor"
rsync -a "$PRESERVE_DIR/placeify_flutter/lib/features/admin/" placeify_flutter/lib/features/admin/
rsync -a "$PRESERVE_DIR/placeify_flutter/lib/features/vendor/" placeify_flutter/lib/features/vendor/

echo "==> Restore Serverpod wiring (data layer only)"
for path in "${WIRING_FILES[@]}"; do
  if [[ -f "$PRESERVE_DIR/wiring/$path" ]]; then
    mkdir -p "$(dirname "$path")"
    cp "$PRESERVE_DIR/wiring/$path" "$path"
  fi
done

echo "==> Patch cart checkout wiring"
bash "$SCRIPT_DIR/wire-cart-checkout.sh"

echo "==> build_runner"
dart pub get >/dev/null
(cd placeify_flutter && dart run build_runner build --delete-conflicting-outputs) 2>&1 | tail -5

echo ""
echo "✓ Latest Nishabh user UI sync complete."
echo "  Source:        $REF ($(git rev-parse --short "$REF"))"
echo "  Backup branch: $BACKUP_BRANCH"
echo "  Next: cd placeify_flutter && flutter analyze lib"
