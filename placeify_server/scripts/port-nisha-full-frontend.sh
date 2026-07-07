#!/usr/bin/env bash
# Full frontend sync from Nishabhattarai branch (flat lib/) into placeify_flutter/.
# Preserves Serverpod integration files and re-applies wired profile/cart/orders layers.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
cd "$ROOT"

# Prefer local Nishabhattarai — remote backend/Nishabhattarai can lag behind her latest UI.
REF="${PLACEIFY_UI_REF:-Nishabhattarai}"
PRESERVE_DIR="${ROOT}/.sync-preserve-$(date +%Y%m%d%H%M%S)"

if [[ "$REF" == */* ]]; then
  echo "==> Fetch $REF"
  git fetch "${REF%%/*}" "${REF#*/}"
else
  echo "==> Use local branch/ref $REF"
fi

echo "==> Backup integration-only files to $PRESERVE_DIR"
mkdir -p "$PRESERVE_DIR"
git ls-tree -r --name-only "$REF" -- lib/ | sed 's|^lib/||' | sort > /tmp/nisha_files.txt
find placeify_flutter/lib -name '*.dart' | sed 's|placeify_flutter/lib/||' | sort > /tmp/ours_files.txt
while IFS= read -r rel; do
  src="placeify_flutter/lib/$rel"
  [[ -f "$src" ]] || continue
  mkdir -p "$PRESERVE_DIR/$(dirname "$rel")"
  cp "$src" "$PRESERVE_DIR/$rel"
done < <(comm -13 /tmp/nisha_files.txt /tmp/ours_files.txt)

echo "==> Port ALL dart UI from $REF (lib/ -> placeify_flutter/lib/)"
ported=0
while IFS= read -r src; do
  rel="${src#lib/}"
  dest="placeify_flutter/lib/$rel"
  mkdir -p "$(dirname "$dest")"
  git show "$REF:$src" | sed 's/package:placeify\//package:placeify_flutter\//g' >"$dest"
  ported=$((ported + 1))
done < <(git ls-tree -r --name-only "$REF" -- lib/ | grep '\.dart$')
echo "    Ported $ported dart files"

echo "==> Sync assets/"
asset_count=0
while IFS= read -r src; do
  dest="placeify_flutter/$src"
  mkdir -p "$(dirname "$dest")"
  git show "$REF:$src" >"$dest"
  asset_count=$((asset_count + 1))
done < <(git ls-tree -r --name-only "$REF" -- assets/)
echo "    Synced $asset_count asset files"

echo "==> Restore integration layer from backup"
while IFS= read -r rel; do
  cp "$PRESERVE_DIR/$rel" "placeify_flutter/lib/$rel"
done < <(find "$PRESERVE_DIR" -type f -name '*.dart' | sed "s|^$PRESERVE_DIR/||")

echo "==> Restore Serverpod entry + critical wiring from current branch"
git checkout HEAD -- \
  placeify_flutter/lib/main.dart \
  placeify_flutter/lib/features/auth/domain/models/app_user.dart \
  placeify_flutter/lib/features/auth/data/mock_auth_repository.dart \
  placeify_flutter/lib/features/auth/domain/repositories/auth_repository.dart \
  placeify_flutter/lib/features/auth/data/serverpod_auth_repository.dart \
  placeify_flutter/lib/features/auth/presentation/providers/auth_provider.dart \
  placeify_flutter/lib/features/auth/presentation/providers/auth_provider.g.dart \
  placeify_flutter/lib/features/cart/presentation/providers/cart_provider.dart \
  placeify_flutter/lib/features/cart/presentation/providers/cart_provider.g.dart \
  placeify_flutter/lib/features/cart/presentation/cart_actions.dart \
  placeify_flutter/lib/features/home/presentation/providers/catalog_provider.dart \
  placeify_flutter/lib/features/home/presentation/providers/catalog_provider.g.dart \
  placeify_flutter/lib/features/vendor/presentation/providers/vendor_orders_provider.dart \
  placeify_flutter/lib/features/vendor/presentation/providers/vendor_orders_provider.g.dart \
  placeify_flutter/lib/features/vendor/presentation/providers/vendor_profile_provider.dart \
  placeify_flutter/lib/features/vendor/data/hybrid_vendor_repository.dart \
  placeify_flutter/lib/features/vendor/domain/models/vendor_profile.dart \
  placeify_flutter/lib/features/vendor/domain/models/vendor_profile.freezed.dart \
  placeify_flutter/lib/features/vendor/domain/models/vendor_profile.g.dart \
  2>/dev/null || true

rm -f placeify_flutter/lib/features/auth/domain/models/app_user.freezed.dart \
      placeify_flutter/lib/features/auth/domain/models/app_user.g.dart

echo "==> build_runner"
dart pub get >/dev/null
(cd placeify_flutter && dart run build_runner build --delete-conflicting-outputs) 2>&1 | tail -3

echo "==> Restore backend wiring + cart checkout"
bash "$SCRIPT_DIR/restore-backend-wiring.sh"

echo ""
echo "✓ Full Nisha UI sync complete."
echo "  Backup: $PRESERVE_DIR"
echo "  Next: cd placeify_flutter && flutter analyze"
echo "  Then manually verify wired screens: refunds, AR, notifications, wishlist, orders."
