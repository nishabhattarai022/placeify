import 'package:placeify/features/admin/domain/enums/user_role.dart';
import 'package:placeify/features/admin/domain/models/platform_user.dart';
import 'package:placeify/features/admin/presentation/providers/admin_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'admin_users_provider.g.dart';

@riverpod
class AdminUsersList extends _$AdminUsersList {
  @override
  Future<List<PlatformUser>> build(String query, UserRole? role) async {
    final repo = await ref.watch(adminRepositoryProvider.future);
    final normalized = query.trim();
    return repo.listUsers(
      query: normalized.isEmpty ? null : normalized,
      role: role,
    );
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = await ref.read(adminRepositoryProvider.future);
      final normalized = query.trim();
      return repo.listUsers(
        query: normalized.isEmpty ? null : normalized,
        role: role,
      );
    });
  }
}

@riverpod
Future<PlatformUser?> adminUserDetail(Ref ref, String userId) async {
  final repo = await ref.watch(adminRepositoryProvider.future);
  final users = await repo.listUsers();
  return users.where((u) => u.id == userId).firstOrNull;
}

extension<T> on Iterable<T> {
  T? get firstOrNull {
    final iterator = this.iterator;
    if (!iterator.moveNext()) return null;
    return iterator.current;
  }
}
