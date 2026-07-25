import 'dart:async';

import 'package:placeify_client/placeify_client.dart' hide Order;
import 'package:placeify_flutter/core/config/placeify_server_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

part 'customer_in_app_notifications_provider.g.dart';

class CustomerInAppNotificationsState {
  const CustomerInAppNotificationsState({
    required this.notifications,
    required this.unreadCount,
  });

  final List<InAppNotificationSummary> notifications;
  final int unreadCount;

  static const empty = CustomerInAppNotificationsState(
    notifications: [],
    unreadCount: 0,
  );
}

/// Customer in-app notifications backed by Serverpod streaming.
@Riverpod(keepAlive: true)
class CustomerInAppNotifications extends _$CustomerInAppNotifications {
  StreamSubscription<InAppNotificationSummary>? _subscription;

  @override
  Future<CustomerInAppNotificationsState> build() {
    ref.onDispose(() => _subscription?.cancel());
    if (!client.auth.isAuthenticated) {
      return Future.value(CustomerInAppNotificationsState.empty);
    }
    unawaited(_attachRealtimeListener());
    return _load();
  }

  Future<void> _attachRealtimeListener() async {
    if (_subscription != null) return;
    await ensurePlaceifyRealtime();
    _subscription = inAppNotificationEvents.listen((notification) {
      _applyIncoming(notification);
      unawaited(refresh(silent: true));
    });
  }

  void _applyIncoming(InAppNotificationSummary notification) {
    final current = state.asData?.value;
    if (current == null) return;

    final alreadyKnown =
        current.notifications.any((row) => row.id == notification.id);
    final withoutDup = current.notifications
        .where((row) => row.id != notification.id)
        .toList(growable: false);
    final nextUnread = alreadyKnown || notification.isRead
        ? current.unreadCount
        : current.unreadCount + 1;

    state = AsyncData(
      CustomerInAppNotificationsState(
        notifications: [notification, ...withoutDup],
        unreadCount: nextUnread,
      ),
    );
  }

  Future<void> refresh({bool silent = false}) async {
    if (!client.auth.isAuthenticated) {
      state = const AsyncData(CustomerInAppNotificationsState.empty);
      return;
    }
    if (!silent) {
      state = const AsyncLoading();
    }
    state = await AsyncValue.guard(_load);
  }

  Future<CustomerInAppNotificationsState> _load() async {
    if (!client.auth.isAuthenticated) {
      return CustomerInAppNotificationsState.empty;
    }
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
  }

  Future<void> markRead(int notificationId) async {
    final current = state.asData?.value;
    if (current != null) {
      final wasUnread = current.notifications.any(
        (row) => row.id == notificationId && !row.isRead,
      );
      state = AsyncData(
        CustomerInAppNotificationsState(
          notifications: [
            for (final row in current.notifications)
              if (row.id == notificationId) row.copyWith(isRead: true) else row,
          ],
          unreadCount: wasUnread
              ? (current.unreadCount - 1).clamp(0, 9999)
              : current.unreadCount,
        ),
      );
    }

    try {
      await client.notification.markInAppNotificationRead(notificationId);
    } catch (_) {}
    unawaited(refresh(silent: true));
  }

  Future<void> markAllRead() async {
    final current = state.asData?.value;
    if (current != null) {
      state = AsyncData(
        CustomerInAppNotificationsState(
          notifications: [
            for (final row in current.notifications) row.copyWith(isRead: true),
          ],
          unreadCount: 0,
        ),
      );
    }

    try {
      await client.notification.markAllInAppNotificationsRead();
    } catch (_) {}
    unawaited(refresh(silent: true));
  }
}

@riverpod
int customerNotificationBadgeCount(Ref ref) {
  final async = ref.watch(customerInAppNotificationsProvider);
  return async.maybeWhen(
    data: (state) => state.unreadCount,
    orElse: () => 0,
  );
}
