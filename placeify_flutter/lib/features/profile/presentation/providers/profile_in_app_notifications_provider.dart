import 'dart:async';

import 'package:placeify_client/placeify_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../../../../core/config/placeify_server_client.dart';
import '../../data/serverpod_notification_repository.dart';

part 'profile_in_app_notifications_provider.g.dart';

class ProfileInAppNotificationsState {
  const ProfileInAppNotificationsState({
    required this.notifications,
    required this.unreadCount,
  });

  final List<InAppNotificationSummary> notifications;
  final int unreadCount;

  static const empty = ProfileInAppNotificationsState(
    notifications: [],
    unreadCount: 0,
  );
}

@riverpod
class ProfileInAppNotifications extends _$ProfileInAppNotifications {
  static const _repository = ServerpodNotificationRepository();
  StreamSubscription<InAppNotificationSummary>? _subscription;

  @override
  Future<ProfileInAppNotificationsState> build() {
    ref.onDispose(() => _subscription?.cancel());
    if (!client.auth.isAuthenticated) {
      return Future.value(ProfileInAppNotificationsState.empty);
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
      ProfileInAppNotificationsState(
        notifications: [notification, ...withoutDup],
        unreadCount: nextUnread,
      ),
    );
  }

  Future<void> refresh({bool silent = false}) async {
    if (!client.auth.isAuthenticated) {
      state = const AsyncData(ProfileInAppNotificationsState.empty);
      return;
    }
    if (!silent) {
      state = const AsyncLoading();
    }
    state = await AsyncValue.guard(_load);
  }

  Future<ProfileInAppNotificationsState> _load() async {
    if (!client.auth.isAuthenticated) {
      return ProfileInAppNotificationsState.empty;
    }
    final notifications = await _repository.listInAppNotifications();
    final unreadCount = await _repository.unreadInAppNotificationCount();
    return ProfileInAppNotificationsState(
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
        ProfileInAppNotificationsState(
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
      await _repository.markInAppNotificationRead(notificationId);
    } catch (_) {}
    unawaited(refresh(silent: true));
  }

  Future<void> markAllRead() async {
    final current = state.asData?.value;
    if (current != null) {
      state = AsyncData(
        ProfileInAppNotificationsState(
          notifications: [
            for (final row in current.notifications) row.copyWith(isRead: true),
          ],
          unreadCount: 0,
        ),
      );
    }

    try {
      await _repository.markAllInAppNotificationsRead();
    } catch (_) {}
    unawaited(refresh(silent: true));
  }
}
