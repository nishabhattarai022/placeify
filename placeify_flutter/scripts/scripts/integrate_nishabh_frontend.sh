#!/usr/bin/env bash
# Full overlay of origin/Nishabhattarai Flutter frontend into placeify_flutter.
# Preserves Serverpod backend wiring, networking, AR/3D, and dev tooling only.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FLUTTER_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
REPO_ROOT="$(cd "$FLUTTER_DIR/.." && pwd)"
NISHABH_SRC="${NISHABH_SRC:-/tmp/nishabh-full-src}"
PRESERVE_DIR="${PRESERVE_DIR:-/tmp/placeify-preserve-$$}"
BACKUP_BRANCH="backup/rosikagajurel-pre-nishabh-$(date +%Y%m%d%H%M%S)"

# Backend + integration files — never take these from Nishabh (mock-based branch).
BACKEND_PRESERVE_PATHS=(
  "placeify_flutter/lib/core/config"
  "placeify_flutter/lib/core/utils/local_image_path.dart"
  "placeify_flutter/lib/core/utils/persist_picked_image.dart"
  "placeify_flutter/lib/main.dart"
  "placeify_flutter/lib/features/auth/data/serverpod_auth_repository.dart"
  "placeify_flutter/lib/features/auth/data/mock_auth_repository.dart"
  "placeify_flutter/lib/features/auth/domain/repositories/auth_repository.dart"
  "placeify_flutter/lib/features/home/data/catalog_product_mapper.dart"
  "placeify_flutter/lib/features/home/data/vendor_product_catalog_mapper.dart"
  "placeify_flutter/lib/features/home/data/serverpod_product_repository.dart"
  "placeify_flutter/lib/features/cart/data/serverpod_cart_repository.dart"
  "placeify_flutter/lib/features/cart/data/product_id_codec.dart"
  "placeify_flutter/lib/features/orders/data/serverpod_order_repository.dart"
  "placeify_flutter/lib/features/orders/data/order_api_mapper.dart"
  "placeify_flutter/lib/features/shops/data/serverpod_consumer_shop_repository.dart"
  "placeify_flutter/lib/features/profile/data/serverpod_profile_repository.dart"
  "placeify_flutter/lib/features/profile/data/serverpod_refund_repository.dart"
  "placeify_flutter/lib/features/profile/data/serverpod_wishlist_repository.dart"
  "placeify_flutter/lib/features/profile/data/profile_refund_mapper.dart"
  "placeify_flutter/lib/features/profile/domain"
  "placeify_flutter/lib/features/admin/data/serverpod_admin_api.dart"
  "placeify_flutter/lib/features/admin/data/serverpod_admin_repository.dart"
  "placeify_flutter/lib/features/admin/data/serverpod_vendor_application_repository.dart"
  "placeify_flutter/lib/features/admin/data/hybrid_admin_repository.dart"
  "placeify_flutter/lib/features/admin/data/admin_platform_mapper.dart"
  "placeify_flutter/lib/features/admin/presentation/guards/admin_auth_guard.dart"
  "placeify_flutter/lib/features/vendor/data/serverpod_vendor_document_repository.dart"
  "placeify_flutter/lib/features/vendor/data/serverpod_vendor_order_repository.dart"
  "placeify_flutter/lib/features/vendor/data/serverpod_vendor_payment_repository.dart"
  "placeify_flutter/lib/features/vendor/data/serverpod_vendor_product_repository.dart"
  "placeify_flutter/lib/features/vendor/data/serverpod_vendor_profile_repository.dart"
  "placeify_flutter/lib/features/vendor/data/serverpod_vendor_registration_repository.dart"
  "placeify_flutter/lib/features/vendor/data/serverpod_vendor_repository.dart"
  "placeify_flutter/lib/features/vendor/data/hybrid_vendor_repository.dart"
  "placeify_flutter/lib/features/vendor/data/vendor_bank_details_mapper.dart"
  "placeify_flutter/lib/features/vendor/data/vendor_dashboard_mapper.dart"
  "placeify_flutter/lib/features/vendor/data/vendor_notification_mapper.dart"
  "placeify_flutter/lib/features/vendor/data/vendor_order_mapper.dart"
  "placeify_flutter/lib/features/vendor/data/vendor_order_exceptions.dart"
  "placeify_flutter/lib/features/vendor/data/vendor_payment_mapper.dart"
  "placeify_flutter/lib/features/vendor/data/vendor_product_mapper.dart"
  "placeify_flutter/lib/features/vendor/data/vendor_profile_mapper.dart"
  "placeify_flutter/lib/features/vendor/data/vendor_shop_category_codec.dart"
  "placeify_flutter/lib/features/vendor/data/product_image_service.dart"
  "placeify_flutter/lib/features/vendor/domain/constants/vendor_registration_field_keys.dart"
  "placeify_flutter/lib/features/vendor/domain/repositories/vendor_product_repository.dart"
  "placeify_flutter/lib/features/vendor/data/mock_vendor_product_repository.dart"
  "placeify_flutter/lib/features/vendor/presentation/widgets/product_multiview_photo_picker.dart"
  "placeify_flutter/lib/features/product_detail/data/product_3d_model_loader.dart"
  "placeify_flutter/lib/features/product_detail/data/product_3d_model_resolver.dart"
  "placeify_flutter/lib/features/product_detail/presentation/ar_room_screen.dart"
  "placeify_flutter/lib/features/product_detail/presentation/webcam_ar_room_screen.dart"
  "placeify_flutter/assets/config.json"
  "placeify_flutter/pubspec.yaml"
  "placeify_flutter/scripts"
  ".vscode"
)

# Serverpod provider wiring — keep live API hooks, not Nishabh mocks.
WIRE_PRESERVE_PATHS=(
  "placeify_flutter/lib/features/auth/presentation/providers/auth_provider.dart"
  "placeify_flutter/lib/features/cart/presentation/providers/cart_provider.dart"
  "placeify_flutter/lib/features/home/presentation/providers/catalog_provider.dart"
  "placeify_flutter/lib/features/home/presentation/providers/category_provider.dart"
  "placeify_flutter/lib/features/orders/presentation/providers/orders_provider.dart"
  "placeify_flutter/lib/features/shops/presentation/providers/consumer_shop_provider.dart"
  "placeify_flutter/lib/features/profile/presentation/providers/profile_dashboard_provider.dart"
  "placeify_flutter/lib/features/profile/presentation/providers/profile_refunds_provider.dart"
  "placeify_flutter/lib/features/vendor/presentation/providers/vendor_profile_provider.dart"
  "placeify_flutter/lib/features/vendor/presentation/providers/vendor_products_provider.dart"
  "placeify_flutter/lib/features/vendor/presentation/providers/vendor_registration_repository_provider.dart"
  "placeify_flutter/lib/features/vendor/presentation/providers/vendor_payments_provider.dart"
  "placeify_flutter/lib/features/vendor/presentation/providers/vendor_document_repository_provider.dart"
  "placeify_flutter/lib/features/admin/presentation/providers/admin_repository_provider.dart"
  "placeify_flutter/lib/features/admin/presentation/providers/vendor_application_repository_provider.dart"
)

if [[ ! -d "$NISHABH_SRC/lib" ]]; then
  echo "Extracting origin/Nishabhattarai..."
  rm -rf "$NISHABH_SRC"
  mkdir -p "$NISHABH_SRC"
  cd "$REPO_ROOT"
  git archive origin/Nishabhattarai lib assets test | tar -x -C "$NISHABH_SRC"
fi

cd "$REPO_ROOT"
CURRENT_BRANCH="$(git branch --show-current)"

echo "==> Backup branch: $BACKUP_BRANCH"
git branch "$BACKUP_BRANCH" 2>/dev/null || true

echo "==> Save backend + provider wiring"
mkdir -p "$PRESERVE_DIR"
for path in "${BACKEND_PRESERVE_PATHS[@]}" "${WIRE_PRESERVE_PATHS[@]}"; do
  if [[ -e "$REPO_ROOT/$path" ]]; then
    mkdir -p "$PRESERVE_DIR/$(dirname "$path")"
    cp -R "$REPO_ROOT/$path" "$PRESERVE_DIR/$path"
  fi
done

echo "==> Stash uncommitted work (server/client restored after)"
git stash push -u -m "pre-nishabh-frontend-$(date +%Y%m%d%H%M%S)" || true

echo "==> Full overlay: lib + assets + test"
rsync -a --delete \
  --exclude 'config.json' \
  "$NISHABH_SRC/lib/" "$FLUTTER_DIR/lib/"
rsync -a --delete \
  --exclude 'config.json' \
  "$NISHABH_SRC/assets/" "$FLUTTER_DIR/assets/"
if [[ -d "$NISHABH_SRC/test" ]]; then
  rsync -a --delete "$NISHABH_SRC/test/" "$FLUTTER_DIR/test/"
fi

echo "==> Restore backend + Serverpod wiring"
for path in "${BACKEND_PRESERVE_PATHS[@]}" "${WIRE_PRESERVE_PATHS[@]}"; do
  if [[ -e "$PRESERVE_DIR/$path" ]]; then
    mkdir -p "$REPO_ROOT/$(dirname "$path")"
    cp -R "$PRESERVE_DIR/$path" "$REPO_ROOT/$path"
  fi
done

echo "==> Fix package imports (placeify -> placeify_flutter)"
if [[ "$(uname)" == "Darwin" ]]; then
  find "$FLUTTER_DIR/lib" "$FLUTTER_DIR/test" -name '*.dart' -print0 2>/dev/null | \
    xargs -0 sed -i '' 's/package:placeify\//package:placeify_flutter\//g'
else
  find "$FLUTTER_DIR/lib" "$FLUTTER_DIR/test" -name '*.dart' -print0 2>/dev/null | \
    xargs -0 sed -i 's/package:placeify\//package:placeify_flutter\//g'
fi

echo "==> Patch admin auth redirect in app_router"
APP_ROUTER="$FLUTTER_DIR/lib/core/router/app_router.dart"
if grep -q 'if (adminRedirect != null) return adminRedirect;' "$APP_ROUTER"; then
  python3 - "$APP_ROUTER" <<'PY'
import sys
from pathlib import Path
path = Path(sys.argv[1])
text = path.read_text()
old = "      if (adminRedirect != null) return adminRedirect;"
new = """      if (adminRedirect != null) {
        if (adminRedirect.toastMessage != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final ctx = rootNavigatorKey.currentContext;
            if (ctx != null) {
              PlaceifyToast.show(ctx, adminRedirect.toastMessage!);
            }
          });
        }
        return adminRedirect.location;
      }"""
path.write_text(text.replace(old, new, 1))
PY
fi

echo "==> Patch vendor product form for Serverpod product notifier API"
FORM_PROVIDER="$FLUTTER_DIR/lib/features/vendor/presentation/providers/vendor_product_form_provider.dart"
if [[ -f "$FORM_PROVIDER" ]] && grep -q 'final String? error;' "$FORM_PROVIDER"; then
  sed -i '' \
    -e 's/final String? error;/final ({VendorProduct? product, String? error}) result;/' \
    -e 's/error = await productsNotifier.updateProduct(product);/result = await productsNotifier.updateProduct(product);/' \
    -e 's/error = await productsNotifier.createProduct(product);/result = await productsNotifier.createProduct(product);/' \
    -e 's/if (error != null) {/if (result.error != null) {/' \
    -e 's/submitError: error/submitError: result.error/' \
    "$FORM_PROVIDER" 2>/dev/null || sed -i \
    -e 's/final String? error;/final ({VendorProduct? product, String? error}) result;/' \
    -e 's/error = await productsNotifier.updateProduct(product);/result = await productsNotifier.updateProduct(product);/' \
    -e 's/error = await productsNotifier.createProduct(product);/result = await productsNotifier.createProduct(product);/' \
    -e 's/if (error != null) {/if (result.error != null) {/' \
    -e 's/submitError: error/submitError: result.error/' \
    "$FORM_PROVIDER"
fi

echo "==> Dependencies + codegen"
cd "$REPO_ROOT"
dart pub get
cd "$FLUTTER_DIR"
dart run build_runner build --delete-conflicting-outputs

echo "==> Restore server / client from stash if present"
cd "$REPO_ROOT"
if git stash list | head -1 | grep -q "pre-nishabh-frontend"; then
  git stash pop || echo "Stash pop had conflicts — resolve manually: git stash list"
fi

rm -rf "$PRESERVE_DIR"

echo
echo "Done. Branch: $CURRENT_BRANCH | Backup: $BACKUP_BRANCH"
echo "Nishabh source: $NISHABH_SRC ($(cd $REPO_ROOT && git rev-parse --short origin/Nishabhattarai))"
echo "Run: cd placeify_flutter && flutter analyze"
