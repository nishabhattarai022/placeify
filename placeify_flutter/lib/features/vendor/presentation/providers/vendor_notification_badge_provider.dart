import 'package:placeify_flutter/features/vendor/presentation/providers/vendor_notifications_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'vendor_notification_badge_provider.g.dart';

@riverpod
int vendorNotificationBadgeCount(Ref ref) {
  final notificationsAsync = ref.watch(vendorNotificationsProvider);
  return notificationsAsync.maybeWhen(
    data: (state) => state.unreadCount,
    orElse: () => 0,
  );
}
