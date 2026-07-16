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

  Future<ProfileInAppNotificationsState> _load() async {
    if (!client.auth.isAuthenticated) {
      return ProfileInAppNotificationsState.empty;
    }
    try {
      final notifications = await _repository.listInAppNotifications();
      final unreadCount = await _repository.unreadInAppNotificationCount();
      return ProfileInAppNotificationsState(
        notifications: notifications,
        unreadCount: unreadCount,
      );
    } on NotificationRepositoryException {
      rethrow;
    }
  }

  Future<void> markRead(int notificationId) async {
    try {
      await _repository.markInAppNotificationRead(notificationId);
    } catch (_) {}
    unawaited(refresh(silent: true));
  }

  Future<void> markAllRead() async {
    try {
      await _repository.markAllInAppNotificationsRead();
    } catch (_) {}
    unawaited(refresh(silent: true));
  }
}
