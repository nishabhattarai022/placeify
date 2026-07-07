import 'package:placeify_client/placeify_client.dart';

/// Maps notification preference API rows to Nisha toggle fields.
abstract final class ProfileNotificationMapper {
  static bool valueFor(NotificationPreference prefs, String field) {
    return switch (field) {
      'orderUpdates' => prefs.orderUpdates,
      'refundStatus' => prefs.refundStatus,
      'arReminders' => prefs.arReminders,
      'priceDropAlerts' => prefs.priceDropAlerts,
      'vendorMessages' => prefs.vendorMessages,
      'promotions' => prefs.promotions,
      _ => true,
    };
  }

  static NotificationPreference apply(
    NotificationPreference base,
    String field,
    bool value,
  ) {
    return switch (field) {
      'orderUpdates' => base.copyWith(orderUpdates: value),
      'refundStatus' => base.copyWith(refundStatus: value),
      'arReminders' => base.copyWith(arReminders: value),
      'priceDropAlerts' => base.copyWith(priceDropAlerts: value),
      'vendorMessages' => base.copyWith(vendorMessages: value),
      'promotions' => base.copyWith(promotions: value),
      _ => base,
    };
  }
}
