#!/usr/bin/env bash
# Overlay AR / 3D preview code from origin/anishajoshi without touching
# placeify_server, vendor order/payment workflow, or vendor product form screens.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FLUTTER_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
REPO_ROOT="$(cd "$FLUTTER_DIR/.." && pwd)"
BRANCH="${ANISHAJOSHI_BRANCH:-origin/anishajoshi}"
BACKUP_BRANCH="backup/$(git branch --show-current)-pre-anishajoshi-ar-$(date +%Y%m%d%H%M%S)"

AR_PATHS=(
  "placeify_flutter/lib/features/product_detail/data/ar_furniture_scale.dart"
  "placeify_flutter/lib/features/product_detail/data/product_3d_model_loader.dart"
  "placeify_flutter/lib/features/product_detail/data/product_3d_model_resolver.dart"
  "placeify_flutter/lib/features/product_detail/presentation/ar_room_screen.dart"
  "placeify_flutter/lib/features/product_detail/presentation/webcam_ar_room_screen.dart"
  "placeify_flutter/lib/features/product_detail/presentation/product_detail_screen.dart"
  "placeify_flutter/lib/features/product_detail/presentation/widgets/ar_pinch_scale_overlay.dart"
  "placeify_flutter/lib/features/product_detail/presentation/widgets/product_3d_preview.dart"
  "placeify_flutter/lib/features/product_detail/presentation/widgets/product_detail_gallery.dart"
  "placeify_flutter/lib/features/home/data/catalog_product_mapper.dart"
)

cd "$REPO_ROOT"

echo "==> Fetching $BRANCH"
git fetch origin anishajoshi

echo "==> Backup branch: $BACKUP_BRANCH"
git branch "$BACKUP_BRANCH" HEAD

echo "==> Checking out AR / 3D files from $BRANCH"
for path in "${AR_PATHS[@]}"; do
  if git cat-file -e "$BRANCH:$path" 2>/dev/null; then
    git checkout "$BRANCH" -- "$path"
    echo "  + $path"
  else
    echo "  ! missing on branch: $path" >&2
  fi
done

echo "==> Done."
echo "    Skipped: placeify_server, vendor form/orders/payments/dashboard."
echo "    Analyze: cd placeify_flutter && dart analyze lib/features/product_detail lib/features/home/data/catalog_product_mapper.dart"
echo "    Backup:  git checkout $BACKUP_BRANCH -- <file>"
