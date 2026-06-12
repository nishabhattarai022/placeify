import 'package:placeify/features/admin/domain/models/admin_notification.dart';
import 'package:placeify/features/admin/presentation/providers/admin_repository_provider.dart';
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
}
