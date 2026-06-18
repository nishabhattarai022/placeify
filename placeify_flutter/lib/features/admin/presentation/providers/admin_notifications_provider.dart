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
    final repo = ref.watch(adminRepositoryProvider);
    return repo.getNotifications();
  }

  Future<void> markAsRead(String notificationId) async {
    final repo = ref.read(adminRepositoryProvider);
    await repo.markNotificationRead(notificationId);
    ref.invalidateSelf();
  }

  Future<void> markAllAsRead() async {
    final repo = ref.read(adminRepositoryProvider);
    await repo.markAllNotificationsRead();
    ref.invalidateSelf();
  }
}
