import 'package:placeify/features/admin/presentation/providers/admin_stats_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'admin_pending_badge_provider.g.dart';

@riverpod
int adminPendingApplicationsBadge(Ref ref) {
  final statsAsync = ref.watch(adminStatsProvider);
  return statsAsync.maybeWhen(
    data: (stats) => stats.pendingCount,
    orElse: () => 0,
  );
}
