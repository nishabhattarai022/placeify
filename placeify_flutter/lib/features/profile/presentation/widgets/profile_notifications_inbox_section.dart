import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:placeify_client/placeify_client.dart';
import 'package:placeify_flutter/features/messaging/domain/constants/messaging_routes.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/relative_time.dart';
import '../../../orders/presentation/providers/customer_in_app_notifications_provider.dart';

class ProfileNotificationsInboxSection extends ConsumerWidget {
  const ProfileNotificationsInboxSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inboxAsync = ref.watch(customerInAppNotificationsProvider);

    return inboxAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.only(bottom: 20),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (_, _) => const Padding(
        padding: EdgeInsets.only(bottom: 20),
        child: Text(
          'Could not load notifications.',
          style: TextStyle(color: AppColors.textMuted, fontSize: 13),
        ),
      ),
      data: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Inbox',
                  style: TextStyle(
                    fontFamily: 'Fraunces',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.espresso,
                  ),
                ),
                const Spacer(),
                if (state.unreadCount > 0)
                  TextButton(
                    onPressed: () => ref
                        .read(customerInAppNotificationsProvider.notifier)
                        .markAllRead(),
                    child: const Text('Mark all read'),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            if (state.notifications.isEmpty)
              const Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Text(
                  'No notifications.',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                ),
              )
            else
              for (final notification in state.notifications)
                _InboxTile(
                  notification: notification,
                  onTap: () {
                    if (!notification.isRead) {
                      ref
                          .read(customerInAppNotificationsProvider.notifier)
                          .markRead(notification.id);
                    }
                    if (notification.type == InAppNotificationType.chatMessage &&
                        notification.referenceKey != null &&
                        notification.referenceKey!.isNotEmpty) {
                      context.push(
                        MessagingRoutes.chat(notification.referenceKey!),
                      );
                    }
                  },
                ),
            const SizedBox(height: 8),
            const Divider(height: 24, color: AppColors.creamDark),
            const Text(
              'Preferences',
              style: TextStyle(
                fontFamily: 'Fraunces',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.espresso,
              ),
            ),
            const SizedBox(height: 12),
          ],
        );
      },
    );
  }
}

class _InboxTile extends StatelessWidget {
  const _InboxTile({
    required this.notification,
    required this.onTap,
  });

  final InAppNotificationSummary notification;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: notification.isRead ? Colors.white : AppColors.accentBg,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(14),
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
                          fontWeight: notification.isRead
                              ? FontWeight.w500
                              : FontWeight.w700,
                          color: AppColors.espresso,
                        ),
                      ),
                    ),
                    if (!notification.isRead)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.teal,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  notification.message,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textMuted,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  RelativeTime.format(notification.createdAt),
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textMuted.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
