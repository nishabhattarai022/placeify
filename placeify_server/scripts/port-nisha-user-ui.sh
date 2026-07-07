#!/usr/bin/env bash
# Port curated User UI from Nishabhattarai (lib/) into placeify_flutter/lib/.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
cd "$ROOT"

REMOTE="${PLACEIFY_GIT_REMOTE:-backend}"
BRANCH="${PLACEIFY_UI_BRANCH:-Nishabhattarai}"
REF="$REMOTE/$BRANCH"

NISHA_FILES=(
  features/orders/data/mock_order_repository.dart
  features/orders/domain/constants/order_strings.dart
  features/orders/domain/enums/consumer_order_status.dart
  features/orders/domain/enums/order_list_filter.dart
  features/orders/domain/enums/payment_status.dart
  features/orders/domain/models/order.dart
  features/orders/domain/models/order.freezed.dart
  features/orders/domain/models/order.g.dart
  features/orders/domain/models/order_item.dart
  features/orders/domain/models/order_item.freezed.dart
  features/orders/domain/models/order_item.g.dart
  features/orders/domain/models/order_status_update.dart
  features/orders/domain/models/order_status_update.freezed.dart
  features/orders/domain/models/order_status_update.g.dart
  features/orders/domain/repositories/order_repository.dart
  features/orders/presentation/my_orders_screen.dart
  features/orders/presentation/order_detail_screen.dart
  features/orders/presentation/order_tracking_screen.dart
  features/orders/presentation/providers/orders_provider.dart
  features/orders/presentation/providers/orders_provider.g.dart
  features/orders/presentation/widgets/consumer_order_status_chip.dart
  features/orders/presentation/widgets/consumer_payment_status_chip.dart
  features/orders/presentation/widgets/order_card.dart
  features/orders/presentation/widgets/order_filter_sheet.dart
  features/orders/presentation/widgets/order_item_row.dart
  features/orders/presentation/widgets/order_list_entry.dart
  features/orders/presentation/widgets/order_quick_actions_sheet.dart
  features/orders/presentation/widgets/order_reason_sheets.dart
  features/orders/presentation/widgets/order_section_card.dart
  features/orders/presentation/widgets/order_timeline.dart
  features/orders/presentation/widgets/orders_empty_state.dart
  features/orders/presentation/widgets/orders_filter_bar.dart
  features/orders/presentation/widgets/orders_search_field.dart
  features/profile/data/profile_menu_config.dart
  features/profile/data/profile_mock_data.dart
  features/profile/presentation/profile_home_screen.dart
  features/profile/presentation/profile_ar_history_screen.dart
  features/profile/presentation/profile_notifications_screen.dart
  features/profile/presentation/profile_password_screen.dart
  features/profile/presentation/profile_refund_screen.dart
  features/profile/presentation/profile_settings_screen.dart
  features/profile/presentation/profile_wishlist_screen.dart
  features/profile/presentation/widgets/ar/ar_history_card.dart
  features/profile/presentation/widgets/profile_hero.dart
  features/profile/presentation/widgets/profile_hero_pattern.dart
  features/profile/presentation/widgets/profile_menu_tile.dart
  features/profile/presentation/widgets/profile_orders_tile.dart
  features/profile/presentation/widgets/profile_stats_strip.dart
  features/profile/presentation/widgets/profile_sub_hero.dart
  features/profile/presentation/widgets/refund/refund_list_item.dart
  features/profile/presentation/widgets/refund/refund_summary_card.dart
  features/profile/presentation/widgets/shared/password_strength_panel.dart
  features/profile/presentation/widgets/shared/profile_form_field.dart
  features/profile/presentation/widgets/shared/profile_submit_button.dart
  features/profile/presentation/widgets/shared/profile_toggle_row.dart
  features/profile/presentation/widgets/wishlist/wishlist_grid_view.dart
  features/profile/presentation/widgets/wishlist/wishlist_screen.dart
  features/profile/presentation/widgets/wishlist/wishlist_search_field.dart
  features/profile/presentation/widgets/wishlist/wishlist_sort.dart
  features/profile/presentation/widgets/wishlist/wishlist_sort_provider.dart
  features/profile/presentation/widgets/wishlist/wishlist_sort_provider.g.dart
  features/profile/presentation/widgets/wishlist/wishlist_sort_sheet.dart
)

echo "==> Port User UI from $REF"
ported=0
for rel in "${NISHA_FILES[@]}"; do
  src="lib/$rel"
  dest="placeify_flutter/lib/$rel"
  if ! git cat-file -e "$REF:$src" 2>/dev/null; then
    echo "  skip (missing): $src"
    continue
  fi
  mkdir -p "$(dirname "$dest")"
  git show "$REF:$src" >"$dest"
  sed -i '' 's/package:placeify\//package:placeify_flutter\//g' "$dest"
  ported=$((ported + 1))
done
echo "==> Ported $ported files"
