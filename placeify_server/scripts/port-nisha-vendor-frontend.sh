#!/usr/bin/env bash
# Port LATEST origin/Nishabhattarai vendor presentation UI into placeify_flutter.
# Preserves rosika admin, user, vendor data/providers/domain, and Serverpod 3D builder.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
cd "$ROOT"

REMOTE="${PLACEIFY_GIT_REMOTE:-origin}"
BRANCH="${PLACEIFY_UI_BRANCH:-Nishabhattarai}"
REF="$REMOTE/$BRANCH"
PRESERVE_DIR="${PRESERVE_DIR:-/tmp/placeify-preserve-vendor-$$}"
BACKUP_BRANCH="backup/rosikagajurel-pre-nisha-vendor-$(date +%Y%m%d%H%M%S)"

VENDOR_KEEP_DIRS=(
  placeify_flutter/lib/features/vendor/data
  placeify_flutter/lib/features/vendor/domain
  placeify_flutter/lib/features/vendor/presentation/providers
  placeify_flutter/lib/features/vendor/presentation/guards
)

VENDOR_KEEP_FILES=(
  placeify_flutter/lib/features/vendor/presentation/vendor_build_3d_screen.dart
)

echo "==> Fetch latest $REF"
git fetch "$REMOTE" "$BRANCH"

echo "==> Backup branch: $BACKUP_BRANCH"
git branch "$BACKUP_BRANCH" HEAD 2>/dev/null || true

echo "==> Backup admin + user + vendor data layer"
mkdir -p "$PRESERVE_DIR/placeify_flutter/lib/features"
cp -R placeify_flutter/lib/features/admin "$PRESERVE_DIR/placeify_flutter/lib/features/"
cp -R placeify_flutter/lib/features/user "$PRESERVE_DIR/placeify_flutter/lib/features/"

for dir in "${VENDOR_KEEP_DIRS[@]}"; do
  if [[ -d "$ROOT/$dir" ]]; then
    rel="${dir#placeify_flutter/lib/}"
    mkdir -p "$PRESERVE_DIR/placeify_flutter/lib/$(dirname "$rel")"
    cp -R "$ROOT/$dir" "$PRESERVE_DIR/placeify_flutter/lib/$rel"
  fi
done

mkdir -p "$PRESERVE_DIR/vendor-keep"
for path in "${VENDOR_KEEP_FILES[@]}"; do
  if [[ -f "$ROOT/$path" ]]; then
    mkdir -p "$PRESERVE_DIR/vendor-keep/$(dirname "$path")"
    cp "$ROOT/$path" "$PRESERVE_DIR/vendor-keep/$path"
  fi
done

echo "==> Port vendor presentation dart from $REF (skip providers/guards)"
ported=0
while IFS= read -r src; do
  case "$src" in
    lib/features/vendor/presentation/providers/*|lib/features/vendor/presentation/guards/*) continue ;;
    lib/features/vendor/presentation/*) ;;
    *) continue ;;
  esac
  rel="${src#lib/}"
  dest="placeify_flutter/lib/$rel"
  mkdir -p "$(dirname "$dest")"
  git show "$REF:$src" | sed 's/package:placeify\//package:placeify_flutter\//g' >"$dest"
  ported=$((ported + 1))
done < <(git ls-tree -r --name-only "$REF" -- lib/ | grep '\.dart$')
echo "    Ported $ported vendor presentation dart files from $(git rev-parse --short "$REF")"

echo "==> Restore admin + user"
rsync -a "$PRESERVE_DIR/placeify_flutter/lib/features/admin/" placeify_flutter/lib/features/admin/
rsync -a "$PRESERVE_DIR/placeify_flutter/lib/features/user/" placeify_flutter/lib/features/user/

echo "==> Restore vendor data/providers/domain"
for dir in "${VENDOR_KEEP_DIRS[@]}"; do
  rel="${dir#placeify_flutter/lib/}"
  if [[ -d "$PRESERVE_DIR/placeify_flutter/lib/$rel" ]]; then
    rsync -a "$PRESERVE_DIR/placeify_flutter/lib/$rel/" "$dir/"
  fi
done

echo "==> Restore Serverpod 3D builder screen"
for path in "${VENDOR_KEEP_FILES[@]}"; do
  if [[ -f "$PRESERVE_DIR/vendor-keep/$path" ]]; then
    mkdir -p "$(dirname "$path")"
    cp "$PRESERVE_DIR/vendor-keep/$path" "$path"
  fi
done

echo "==> build_runner"
(cd placeify_flutter && dart pub get >/dev/null)
(cd placeify_flutter && dart run build_runner build --delete-conflicting-outputs) 2>&1 | tail -5

echo ""
echo "✓ Latest Nishabh vendor UI sync complete."
echo "  Source:        $REF ($(git rev-parse --short "$REF"))"
echo "  Backup branch: $BACKUP_BRANCH"
