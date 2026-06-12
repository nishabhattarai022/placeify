import 'package:placeify/features/admin/domain/models/platform_user.dart';
import 'package:placeify/features/admin/presentation/providers/admin_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'admin_users_provider.g.dart';

@riverpod
class AdminUsersList extends _$AdminUsersList {
  @override
  Future<List<PlatformUser>> build(String query) async {
    final repo = await ref.watch(adminRepositoryProvider.future);
    final normalized = query.trim();
    return repo.listUsers(
      query: normalized.isEmpty ? null : normalized,
    );
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = await ref.read(adminRepositoryProvider.future);
      final normalized = query.trim();
      return repo.listUsers(
        query: normalized.isEmpty ? null : normalized,
      );
    });
  }
}
