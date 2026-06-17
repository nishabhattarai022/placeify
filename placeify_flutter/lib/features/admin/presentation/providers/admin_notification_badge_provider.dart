import 'package:placeify_flutter/features/admin/presentation/providers/admin_notifications_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'admin_notification_badge_provider.g.dart';

@riverpod
int adminNotificationBadgeCount(Ref ref) {
  final notificationsAsync = ref.watch(adminNotificationsProvider);
  return notificationsAsync.maybeWhen(
    data: (notifications) =>
        notifications.where((notification) => !notification.read).length,
    orElse: () => 0,
  );
}
