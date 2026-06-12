import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:placeify/core/constants/app_colors.dart';
import 'package:placeify/core/constants/app_radii.dart';
import 'package:placeify/core/constants/app_spacing.dart';
import 'package:placeify/core/constants/app_typography.dart';
import 'package:placeify/core/utils/formatters.dart';
import 'package:placeify/core/widgets/bottom_nav/bottom_nav_tokens.dart';
import 'package:placeify/core/widgets/shimmer_loader.dart';
import 'package:placeify/features/admin/domain/constants/admin_strings.dart';
import 'package:placeify/features/admin/domain/models/admin_audit_log_entry.dart';
import 'package:placeify/features/admin/presentation/providers/admin_audit_log_provider.dart';
import 'package:placeify/features/admin/presentation/providers/admin_users_provider.dart';
import 'package:placeify/features/admin/presentation/widgets/admin_empty_state.dart';
import 'package:placeify/features/profile/presentation/widgets/profile_sub_hero.dart';

class AdminAuditLogScreen extends ConsumerWidget {
  const AdminAuditLogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auditAsync = ref.watch(adminAuditLogProvider);
    final usersAsync = ref.watch(adminUsersListProvider(''));

    final userNames = usersAsync.value?.fold<Map<String, String>>(
          {},
          (map, user) => map..[user.id] = user.name,
        ) ??
        const {};

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Column(
        children: [
          const ProfileSubHero(title: AdminStrings.auditLogTitle),
          Expanded(
            child: auditAsync.when(
              loading: () => ListView.separated(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenPadding,
                  12,
                  AppSpacing.screenPadding,
                  BottomNavTokens.scrollBottomPadding,
                ),
                itemCount: 8,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (_, __) => const SizedBox(
                  height: 88,
                  child: ShimmerLoader(borderRadius: AppRadii.md),
                ),
              ),
              error: (_, __) => Center(
                child: TextButton(
                  onPressed: () =>
                      ref.read(adminAuditLogProvider.notifier).refresh(),
                  child: const Text(AdminStrings.retry),
                ),
              ),
              data: (entries) {
                if (entries.isEmpty) {
                  return const Center(
                    child: AdminEmptyState(
                      message: AdminStrings.noAuditEntries,
                      icon: Icons.history_outlined,
                    ),
                  );
                }

                final sorted = [...entries]
                  ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

                return RefreshIndicator(
                  color: AppColors.espresso,
                  onRefresh: () =>
                      ref.read(adminAuditLogProvider.notifier).refresh(),
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.screenPadding,
                      12,
                      AppSpacing.screenPadding,
                      BottomNavTokens.scrollBottomPadding,
                    ),
                    itemCount: sorted.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final entry = sorted[index];
                      return _AuditLogTile(
                        entry: entry,
                        targetName: userNames[entry.targetUserId],
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _AuditLogTile extends StatelessWidget {
  const _AuditLogTile({
    required this.entry,
    required this.targetName,
  });

  final AdminAuditLogEntry entry;
  final String? targetName;

  @override
  Widget build(BuildContext context) {
    final actionLabel = AdminStrings.auditActionLabel(entry.action);
    final targetLabel = targetName ?? entry.targetUserId;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.warmWhite,
        borderRadius: AppRadii.md,
        border: Border.all(color: AppColors.creamDark, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            actionLabel,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.espresso,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${AdminStrings.targetUser}: $targetLabel',
            style: AppTypography.bodyLight.copyWith(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          if (entry.note != null && entry.note!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              '${AdminStrings.noteLabel}: ${entry.note}',
              style: AppTypography.bodyLight.copyWith(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ],
          const SizedBox(height: 8),
          Text(
            _formatTimestamp(entry.timestamp),
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final hour = timestamp.hour % 12 == 0 ? 12 : timestamp.hour % 12;
    final minute = timestamp.minute.toString().padLeft(2, '0');
    final period = timestamp.hour >= 12 ? 'PM' : 'AM';
    return '${Formatters.shortDate(timestamp)} · $hour:$minute $period';
  }
}
