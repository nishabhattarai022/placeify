#!/usr/bin/env bash
# Safely pull admin UI + backend from team branches while preserving rosikagajurel
# Serverpod wiring, order lifecycle, vendor 3D/AR, and marketplace extensions.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FLUTTER_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
REPO_ROOT="$(cd "$FLUTTER_DIR/.." && pwd)"
INTEGRATION_BRANCH="${ADMIN_INTEGRATION_BRANCH:-origin/rosikagajurel}"
UI_BRANCH="${ADMIN_UI_BRANCH:-origin/Nishabhattarai}"
BACKUP_BRANCH="backup/$(git branch --show-current)-pre-admin-$(date +%Y%m%d%H%M%S)"
PRESERVE_DIR="${PRESERVE_DIR:-/tmp/placeify-preserve-admin-$$}"

# Server admin module + related models from integration branch.
SERVER_PULL_PATHS=(
  "placeify_server/lib/src/modules/admin"
  "placeify_server/lib/src/models/admin.spy.yaml"
  "placeify_server/lib/src/models/admin_type.spy.yaml"
  "placeify_server/lib/src/models/admin_platform_stats.spy.yaml"
  "placeify_server/lib/src/models/admin_audit_log_summary.spy.yaml"
  "placeify_server/lib/src/models/admin_refund_request_summary.spy.yaml"
  "placeify_server/lib/src/models/admin_vendor_payout_summary.spy.yaml"
  "placeify_server/lib/src/models/platform_user_summary.spy.yaml"
  "placeify_server/lib/src/models/vendor_application_summary.spy.yaml"
  "placeify_server/lib/src/models/vendor_application_detail.spy.yaml"
  "placeify_server/lib/src/models/complaint.spy.yaml"
  "placeify_server/lib/src/models/complaint_status.spy.yaml"
)

# Curated newer admin UI from Nishabhattarai (approval flows, sheets, rows).
NISHA_ADMIN_FILES=(
  features/admin/presentation/vendor_approvals/vendor_application_detail_screen.dart
  features/admin/presentation/vendor_approvals/widgets/vendor_application_approve_sheet.dart
  features/admin/presentation/vendor_approvals/widgets/vendor_application_decline_sheet.dart
  features/admin/presentation/vendor_approvals/widgets/application_detail_sections.dart
  features/admin/presentation/widgets/admin_application_row.dart
  core/widgets/bottom_nav/admin_bottom_nav.dart
)

# Local Serverpod wiring + auth guard — never overwrite from UI branch.
PRESERVE_PATHS=(
  "placeify_flutter/lib/features/admin/data/serverpod_admin_api.dart"
  "placeify_flutter/lib/features/admin/data/serverpod_admin_repository.dart"
  "placeify_flutter/lib/features/admin/data/serverpod_vendor_application_repository.dart"
  "placeify_flutter/lib/features/admin/data/hybrid_admin_repository.dart"
  "placeify_flutter/lib/features/admin/data/admin_platform_mapper.dart"
  "placeify_flutter/lib/features/admin/presentation/guards/admin_auth_guard.dart"
  "placeify_flutter/lib/features/admin/presentation/providers/admin_repository_provider.dart"
  "placeify_flutter/lib/features/admin/presentation/providers/vendor_application_repository_provider.dart"
  "placeify_flutter/lib/core/router/app_router.dart"
  "placeify_flutter/lib/features/auth/data/serverpod_auth_repository.dart"
  "placeify_flutter/lib/features/auth/presentation/providers/auth_provider.dart"
  "placeify_flutter/lib/features/auth/constants/demo_credentials.dart"
  "placeify_server/lib/src/modules/user/user_service.dart"
  "placeify_server/lib/src/modules/vendor"
  "placeify_server/lib/src/modules/order"
  "placeify_server/lib/src/modules/checkout"
  "placeify_server/lib/src/modules/payment"
  "placeify_server/lib/src/modules/marketplace"
  "placeify_server/lib/src/modules/notification"
)

checkout_path() {
  local branch="$1"
  local path="$2"
  if git cat-file -e "$branch:$path" 2>/dev/null; then
    git checkout "$branch" -- "$path"
    echo "  + $path"
  else
    echo "  ! missing on $branch: $path" >&2
  fi
}

cd "$REPO_ROOT"

echo "==> Placeify admin integration (safe, no merge)"
echo "    Root:        $REPO_ROOT"
echo "    Backend:     $INTEGRATION_BRANCH"
echo "    UI updates:  $UI_BRANCH (curated approval screens)"

echo "==> Fetch remote branches"
git fetch origin rosikagajurel Nishabhattarai 2>&1 | tail -3

echo "==> Backup branch: $BACKUP_BRANCH"
git branch "$BACKUP_BRANCH" HEAD 2>/dev/null || true

echo "==> Preserve local Serverpod wiring + extensions"
mkdir -p "$PRESERVE_DIR"
for path in "${PRESERVE_PATHS[@]}"; do
  if [[ -e "$REPO_ROOT/$path" ]]; then
    mkdir -p "$PRESERVE_DIR/$(dirname "$path")"
    cp -R "$REPO_ROOT/$path" "$PRESERVE_DIR/$path"
  fi
done

echo "==> Pull admin backend from $INTEGRATION_BRANCH"
for path in "${SERVER_PULL_PATHS[@]}"; do
  checkout_path "$INTEGRATION_BRANCH" "$path"
done

echo "==> Pull admin Flutter feature from $INTEGRATION_BRANCH"
checkout_path "$INTEGRATION_BRANCH" "placeify_flutter/lib/features/admin"

echo "==> Port curated admin UI from $UI_BRANCH"
ported=0
for rel in "${NISHA_ADMIN_FILES[@]}"; do
  src="lib/$rel"
  dest="placeify_flutter/lib/$rel"
  if git cat-file -e "$UI_BRANCH:$src" 2>/dev/null; then
    mkdir -p "$(dirname "$dest")"
    git show "$UI_BRANCH:$src" \
      | sed -e 's|package:placeify/|package:placeify_flutter/|g' \
      > "$dest"
    ported=$((ported + 1))
    echo "  + $rel"
  fi
done
echo "    Ported $ported curated UI files"

echo "==> Restore preserved wiring"
for path in "${PRESERVE_PATHS[@]}"; do
  if [[ -e "$PRESERVE_DIR/$path" ]]; then
    mkdir -p "$REPO_ROOT/$(dirname "$path")"
    rm -rf "$REPO_ROOT/$path"
    cp -R "$PRESERVE_DIR/$path" "$REPO_ROOT/$path"
  fi
done

echo "==> Dependencies + codegen"
cd "$REPO_ROOT"
dart pub get >/dev/null
(cd placeify_server && serverpod generate) 2>&1 | tail -3
(cd placeify_flutter && dart run build_runner build --delete-conflicting-outputs) 2>&1 | tail -3

echo
echo "✓ Admin integration complete."
echo "  Backup branch: $BACKUP_BRANCH"
echo "  Rollback file: git checkout $BACKUP_BRANCH -- <path>"
echo
echo "Next — start backend + app:"
echo "  cd placeify_server && ./scripts/start-server.sh"
echo "  cd placeify_flutter && flutter run -d chrome"
echo
echo "Demo admin login:"
echo "  Email:    admin@placeify.com"
echo "  Password: demo1234"
echo "  Route:    /admin  (or use 'Demo Admin Access' on login screen)"
