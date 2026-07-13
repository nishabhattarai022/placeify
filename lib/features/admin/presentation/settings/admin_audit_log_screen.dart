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
import 'package:placeify/features/admin/domain/enums/application_decision.dart';
import 'package:placeify/features/admin/domain/enums/audit_action.dart';
import 'package:placeify/features/admin/domain/models/admin_audit_log_entry.dart';
import 'package:placeify/features/admin/presentation/providers/admin_audit_log_provider.dart';
import 'package:placeify/features/admin/presentation/providers/admin_users_provider.dart';
import 'package:placeify/features/admin/presentation/widgets/admin_empty_state.dart';
import 'package:placeify/features/profile/presentation/widgets/profile_sub_hero.dart';

enum _AuditActionFilter { all, approvals, declines, suspensions, reinstatements }

enum _AuditDateFilter { all, last7Days, last30Days }

class AdminAuditLogScreen extends ConsumerStatefulWidget {
  const AdminAuditLogScreen({super.key});

  @override
  ConsumerState<AdminAuditLogScreen> createState() =>
      _AdminAuditLogScreenState();
}

class _AdminAuditLogScreenState extends ConsumerState<AdminAuditLogScreen> {
  _AuditActionFilter _actionFilter = _AuditActionFilter.all;
  _AuditDateFilter _dateFilter = _AuditDateFilter.all;

  bool _matchesAction(AdminAuditLogEntry entry) {
    return switch (_actionFilter) {
      _AuditActionFilter.all => true,
      _AuditActionFilter.approvals => entry.action.maybeWhen(
            application: (d) => d == ApplicationDecision.approved,
            orElse: () => false,
          ),
      _AuditActionFilter.declines => entry.action.maybeWhen(
            application: (d) => d == ApplicationDecision.declined,
            orElse: () => false,
          ),
      _AuditActionFilter.suspensions => entry.action.maybeWhen(
            vendor: (a) => a == AuditAction.suspended,
            orElse: () => false,
          ),
      _AuditActionFilter.reinstatements => entry.action.maybeWhen(
            vendor: (a) => a == AuditAction.reinstated,
            orElse: () => false,
          ),
    };
  }

  bool _matchesDate(AdminAuditLogEntry entry) {
    final now = DateTime.now();
    return switch (_dateFilter) {
      _AuditDateFilter.all => true,
      _AuditDateFilter.last7Days => now.difference(entry.timestamp).inDays <= 7,
      _AuditDateFilter.last30Days =>
        now.difference(entry.timestamp).inDays <= 30,
    };
  }

  @override
  Widget build(BuildContext context) {
    final auditAsync = ref.watch(adminAuditLogProvider);
    final usersAsync = ref.watch(adminUsersListProvider('', null));

    final userNames = usersAsync.value?.fold<Map<String, String>>(
          {},
          (map, user) => map..[user.id] = user.name,
        ) ??
        const {};

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Column(
        children: [
          const ProfileSubHero(
            title: AdminStrings.auditLogTitle,
            subtitle: 'system activity',
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Row(
              children: [
                for (final filter in _AuditActionFilter.values) ...[
                  _FilterChip(
                    label: _actionLabel(filter),
                    isSelected: _actionFilter == filter,
                    onTap: () => setState(() => _actionFilter = filter),
                  ),
                  const SizedBox(width: 8),
                ],
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Row(
              children: [
                _FilterChip(
                  label: AdminStrings.filterAll,
                  isSelected: _dateFilter == _AuditDateFilter.all,
                  onTap: () => setState(() => _dateFilter = _AuditDateFilter.all),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: AdminStrings.filterLast7Days,
                  isSelected: _dateFilter == _AuditDateFilter.last7Days,
                  onTap: () =>
                      setState(() => _dateFilter = _AuditDateFilter.last7Days),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: AdminStrings.filterLast30Days,
                  isSelected: _dateFilter == _AuditDateFilter.last30Days,
                  onTap: () => setState(
                    () => _dateFilter = _AuditDateFilter.last30Days,
                  ),
                ),
              ],
            ),
          ),
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
                final filtered = entries
                    .where(_matchesAction)
                    .where(_matchesDate)
                    .toList()
                  ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

                if (filtered.isEmpty) {
                  return const Center(
                    child: AdminEmptyState(
                      message: AdminStrings.noAuditEntries,
                      icon: Icons.history_outlined,
                    ),
                  );
                }

                return RefreshIndicator(
                  color: AppColors.adminSlate,
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
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final entry = filtered[index];
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

  String _actionLabel(_AuditActionFilter filter) => switch (filter) {
        _AuditActionFilter.all => AdminStrings.filterAll,
        _AuditActionFilter.approvals => 'Approvals',
        _AuditActionFilter.declines => 'Declines',
        _AuditActionFilter.suspensions => 'Suspensions',
        _AuditActionFilter.reinstatements => 'Reinstatements',
      };
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.adminSlate : AppColors.warmWhite,
          borderRadius: AppRadii.pill,
          border: Border.all(
            color: isSelected ? AppColors.adminSlate : AppColors.creamDark,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSelected ? AppColors.warmWhite : AppColors.textSecondary,
          ),
        ),
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
