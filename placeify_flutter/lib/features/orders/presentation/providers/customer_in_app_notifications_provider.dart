import 'dart:async';

import 'package:placeify_client/placeify_client.dart' hide Order;
import 'package:placeify_flutter/core/config/placeify_server_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'customer_in_app_notifications_provider.g.dart';

class CustomerInAppNotificationsState {
  const CustomerInAppNotificationsState({
    required this.notifications,
    required this.unreadCount,
  });

  final List<InAppNotificationSummary> notifications;
  final int unreadCount;
}

/// Customer order notifications backed by the server (30s polling).
@riverpod
class CustomerInAppNotifications extends _$CustomerInAppNotifications {
  Timer? _pollTimer;

  @override
  Future<CustomerInAppNotificationsState> build() {
    ref.onDispose(() => _pollTimer?.cancel());
    _pollTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      unawaited(refresh());
    });
    return _load();
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(_load);
  }

  Future<CustomerInAppNotificationsState> _load() async {
    try {
      final notifications = await client.notification.listInAppNotifications(
        limit: 50,
        offset: 0,
      );
      final unreadCount =
          await client.notification.unreadInAppNotificationCount();
      return CustomerInAppNotificationsState(
        notifications: notifications,
        unreadCount: unreadCount,
      );
    } catch (_) {
      return const CustomerInAppNotificationsState(
        notifications: [],
        unreadCount: 0,
      );
    }
  }

  Future<void> markRead(int notificationId) async {
    try {
      await client.notification.markInAppNotificationRead(notificationId);
    } catch (_) {}
    await refresh();
  }

  Future<void> markAllRead() async {
    try {
      await client.notification.markAllInAppNotificationsRead();
    } catch (_) {}
    await refresh();
  }
}
