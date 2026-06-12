import 'package:placeify/features/admin/domain/models/admin_stats.dart' as models;
import 'package:placeify/features/admin/presentation/providers/admin_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'admin_stats_provider.g.dart';

@riverpod
class AdminStats extends _$AdminStats {
  @override
  Future<models.AdminStats> build() => _load();

  Future<void> refresh() async {
    state = await AsyncValue.guard(_load);
  }

  Future<models.AdminStats> _load() async {
    final repo = await ref.watch(adminRepositoryProvider.future);
    return repo.getStats();
  }
}
