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

/// Customer in-app notifications backed by Serverpod streaming.
@Riverpod(keepAlive: true)
class CustomerInAppNotifications extends _$CustomerInAppNotifications {
  StreamSubscription<InAppNotificationSummary>? _subscription;

  @override
  Future<CustomerInAppNotificationsState> build() {
    ref.onDispose(() => _subscription?.cancel());
    unawaited(_attachRealtimeListener());
    return _load();
  }

  Future<void> _attachRealtimeListener() async {
    if (_subscription != null) return;
    _subscription = inAppNotificationEvents.listen((_) {
      unawaited(refresh(silent: true));
    });
  }

  Future<void> refresh({bool silent = false}) async {
    if (!silent) {
      state = const AsyncLoading();
    }
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
