/// User-facing copy for vendor store settings.
abstract final class VendorSettingsStrings {
  static const screenTitle = 'Store Settings';

  static const notificationsSection = 'Notifications';
  static const storeSection = 'Store';
  static const payoutSection = 'Payout method';
  static const accountSection = 'Account';

  static const storeVisibleTitle = 'Store visible';
  static const storeVisibleSubtitle =
      'When off, your store is hidden from shoppers';

  static const changePasswordTitle = 'Change password';
  static const changePasswordSubtitle = 'Update your login credentials';

  static const deactivateStoreTitle = 'Deactivate store';
  static const deactivateStoreSubtitle =
      'Temporarily hide your store from Placeify';

  static const payoutBankName = 'Nepal Investment Bank';
  static const payoutPrimaryBadge = 'Primary';
  static const payoutAccountMasked = 'Account ·••• 4821 · NPR settlements';
  static const payoutSupportNote =
      'Payout method changes are reviewed by Placeify support.';

  static const deactivateSheetTitle = 'Deactivate store?';
  static const deactivateSheetSubtitle =
      'Your store will be hidden after a 24-hour cooldown. '
      'You can cancel anytime before then.';
  static const deactivateSheetBody =
      'During the cooldown, orders in progress will still be fulfilled. '
      'After 24 hours your store visibility will turn off automatically.';
  static const deactivateSheetConfirm = 'Start 24-hour cooldown';
  static const deactivateScheduledToast =
      'Deactivation scheduled · 24h cooldown started';

  static String notificationTitle(String typeName) => switch (typeName) {
        'order' => 'Order alerts',
        'payment' => 'Payment alerts',
        'product' => 'Product alerts',
        'system' => 'System updates',
        _ => typeName,
      };

  static String notificationSubtitle(String typeName) => switch (typeName) {
        'order' => 'New orders and status changes',
        'payment' => 'Payouts and payment updates',
        'product' => 'Low stock and listing issues',
        'system' => 'Policy and platform announcements',
        _ => '',
      };

  static String cooldownLabel(Duration? remaining) {
    if (remaining == null) return 'Ready to deactivate';
    final hours = remaining.inHours;
    final minutes = remaining.inMinutes.remainder(60);
    if (hours > 0) {
      return 'Cooldown active · ${hours}h ${minutes}m remaining';
    }
    return 'Cooldown active · ${minutes}m remaining';
  }
}
