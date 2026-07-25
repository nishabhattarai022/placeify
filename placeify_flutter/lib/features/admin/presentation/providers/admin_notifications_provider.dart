import 'package:placeify_flutter/features/admin/domain/models/admin_notification.dart';
import 'package:placeify_flutter/features/admin/presentation/providers/admin_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'admin_notifications_provider.g.dart';

@riverpod
class AdminNotifications extends _$AdminNotifications {
  @override
  Future<List<AdminNotification>> build() => _load();

  Future<void> refresh() async {
    state = await AsyncValue.guard(_load);
  }

  Future<List<AdminNotification>> _load() async {
    final repo = await ref.watch(adminRepositoryProvider.future);
    return repo.getNotifications();
  }

  /// Marks one notification read without forcing a full reload (avoids UI freeze).
  Future<void> markAsRead(String notificationId) async {
    final current = state.asData?.value;
    if (current != null) {
      state = AsyncData([
        for (final notification in current)
          if (notification.id == notificationId)
            notification.copyWith(read: true)
          else
            notification,
      ]);
    }

    try {
      final repo = await ref.read(adminRepositoryProvider.future);
      await repo.markNotificationRead(notificationId);
    } catch (_) {
      // Keep optimistic UI; next refresh reconciles.
    }
  }

  Future<void> markAllAsRead() async {
    final current = state.asData?.value;
    if (current != null) {
      state = AsyncData([
        for (final notification in current) notification.copyWith(read: true),
      ]);
    }

    try {
      final repo = await ref.read(adminRepositoryProvider.future);
      await repo.markAllNotificationsRead();
    } catch (_) {
      ref.invalidateSelf();
    }
  }
}
