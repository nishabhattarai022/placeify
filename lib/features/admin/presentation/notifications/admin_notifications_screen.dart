import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:placeify/core/constants/app_colors.dart';
import 'package:placeify/core/constants/app_radii.dart';
import 'package:placeify/core/constants/app_spacing.dart';
import 'package:placeify/core/constants/app_typography.dart';
import 'package:placeify/core/services/haptic_service.dart';
import 'package:placeify/core/utils/formatters.dart';
import 'package:placeify/core/widgets/bottom_nav/bottom_nav_tokens.dart';
import 'package:placeify/core/widgets/shimmer_loader.dart';
import 'package:placeify/features/admin/domain/constants/admin_routes.dart';
import 'package:placeify/features/admin/domain/constants/admin_strings.dart';
import 'package:placeify/features/admin/domain/enums/admin_notification_type.dart';
import 'package:placeify/features/admin/domain/models/admin_notification.dart';
import 'package:placeify/features/admin/presentation/providers/admin_notifications_provider.dart';
import 'package:placeify/features/admin/presentation/widgets/admin_empty_state.dart';
import 'package:placeify/features/profile/presentation/widgets/profile_sub_hero.dart';

class AdminNotificationsScreen extends ConsumerWidget {
  const AdminNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(adminNotificationsProvider);

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Column(
        children: [
          ProfileSubHero(
            title: AdminStrings.notificationsTitle,
            subtitle: 'alerts & updates',
          ),
          notificationsAsync.maybeWhen(
            data: (items) {
              if (!items.any((n) => !n.read)) {
                return const SizedBox.shrink();
              }
              return Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenPadding,
                    0,
                    AppSpacing.screenPadding,
                    8,
                  ),
                  child: TextButton(
                    onPressed: () async {
                      HapticService.light();
                      await ref
                          .read(adminNotificationsProvider.notifier)
                          .markAllAsRead();
                    },
                    child: const Text(
                      AdminStrings.markAllRead,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.espresso,
                      ),
                    ),
                  ),
                ),
              );
            },
            orElse: () => const SizedBox.shrink(),
          ),
          Expanded(
            child: notificationsAsync.when(
              loading: () => ListView.separated(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenPadding,
                  12,
                  AppSpacing.screenPadding,
                  BottomNavTokens.scrollBottomPadding,
                ),
                itemCount: 6,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (_, __) => const SizedBox(
                  height: 88,
                  child: ShimmerLoader(borderRadius: AppRadii.md),
                ),
              ),
              error: (_, __) => Center(
                child: TextButton(
                  onPressed: () =>
                      ref.read(adminNotificationsProvider.notifier).refresh(),
                  child: const Text(AdminStrings.retry),
                ),
              ),
              data: (notifications) {
                if (notifications.isEmpty) {
                  return const Center(
                    child: AdminEmptyState(
                      message: AdminStrings.noNotifications,
                      icon: Icons.notifications_none_outlined,
                    ),
                  );
                }

                return RefreshIndicator(
                  color: AppColors.espresso,
                  onRefresh: () =>
                      ref.read(adminNotificationsProvider.notifier).refresh(),
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
                    itemCount: notifications.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final notification = notifications[index];
                      return _NotificationTile(
                        notification: notification,
                        onTap: () async {
                          HapticService.light();
                          if (!notification.read) {
                            await ref
                                .read(adminNotificationsProvider.notifier)
                                .markAsRead(notification.id);
                          }
                          if (!context.mounted) return;
                          if (notification.type ==
                                  AdminNotificationType.newApplication &&
                              notification.linkedVendorId != null) {
                            context.push(
                              AdminRoutes.approvalDetail(
                                notification.linkedVendorId!,
                              ),
                            );
                          }
                        },
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

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({
    required this.notification,
    required this.onTap,
  });

  final AdminNotification notification;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isUnread = !notification.read;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.md,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isUnread ? AppColors.warmWhite : AppColors.cream,
            borderRadius: AppRadii.md,
            border: Border.all(
              color: isUnread ? AppColors.espresso.withValues(alpha: 0.12) : AppColors.creamDark,
              width: 1.5,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isUnread
                      ? AppColors.espresso.withValues(alpha: 0.08)
                      : AppColors.creamDark.withValues(alpha: 0.5),
                  borderRadius: AppRadii.sm,
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.notifications_outlined,
                  size: 20,
                  color: isUnread ? AppColors.espresso : AppColors.textMuted,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight:
                                  isUnread ? FontWeight.w700 : FontWeight.w600,
                              color: AppColors.espresso,
                            ),
                          ),
                        ),
                        if (isUnread)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.coral,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.body,
                      style: AppTypography.bodyLight.copyWith(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      Formatters.shortDate(notification.createdAt),
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
