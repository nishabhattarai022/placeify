#!/usr/bin/env bash
# Sync latest origin/Nishabhattarai consumer profile UI (Nishabh's "user dashboard").
# Nishabh does not use features/user/* — Profile tab is the dashboard.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
cd "$ROOT"

REMOTE="${PLACEIFY_GIT_REMOTE:-origin}"
BRANCH="${PLACEIFY_UI_BRANCH:-Nishabhattarai}"
REF="$REMOTE/$BRANCH"

echo "==> Fetch latest $REF"
git fetch "$REMOTE" "$BRANCH"

echo "==> Port profile dashboard UI from $(git rev-parse --short "$REF")"
count=0
while IFS= read -r src; do
  rel="${src#lib/}"
  dest="placeify_flutter/lib/$rel"
  mkdir -p "$(dirname "$dest")"
  git show "$REF:$src" | sed 's/package:placeify\//package:placeify_flutter\//g' >"$dest"
  count=$((count + 1))
done < <(
  git ls-tree -r --name-only "$REF" -- \
    lib/features/profile/presentation \
    lib/features/profile/data/profile_menu_config.dart \
    lib/features/profile/data/profile_mock_data.dart \
    lib/features/profile/domain/constants/refund_strings.dart
)
echo "    Synced $count profile UI files"

echo "==> build_runner (wishlist sort provider)"
dart pub get >/dev/null
(cd placeify_flutter && dart run build_runner build --delete-conflicting-outputs) 2>&1 | tail -3

echo ""
echo "✓ Latest Nishabh profile dashboard UI synced."
echo "  Consumer dashboard = Profile tab (/profile), not features/user/"
echo "  /user/* routes redirect to /profile/* in app_router.dart"
