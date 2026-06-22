import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:placeify_client/placeify_client.dart' hide Order;

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/constants/order_strings.dart';
import '../providers/customer_in_app_notifications_provider.dart';
import 'order_section_card.dart';

/// Order-scoped in-app notifications; marks rows read when shown.
class OrderNotificationsSection extends ConsumerStatefulWidget {
  const OrderNotificationsSection({required this.orderId, super.key});

  final String orderId;

  @override
  ConsumerState<OrderNotificationsSection> createState() =>
      _OrderNotificationsSectionState();
}

class _OrderNotificationsSectionState
    extends ConsumerState<OrderNotificationsSection> {
  bool _markedRead = false;

  int? get _parsedOrderId => int.tryParse(widget.orderId);

  List<InAppNotificationSummary> _forOrder(
    List<InAppNotificationSummary> all,
  ) {
    final orderId = _parsedOrderId;
    if (orderId == null) return const [];

    return all
        .where((notification) => notification.referenceId == orderId)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<void> _markUnreadAsRead(List<InAppNotificationSummary> items) async {
    if (_markedRead) return;
    _markedRead = true;

    final notifier = ref.read(customerInAppNotificationsProvider.notifier);
    for (final notification in items) {
      if (!notification.isRead) {
        await notifier.markRead(notification.id);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final notificationsAsync = ref.watch(customerInAppNotificationsProvider);

    return notificationsAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (state) {
        final items = _forOrder(state.notifications);
        if (items.isEmpty) return const SizedBox.shrink();

        WidgetsBinding.instance.addPostFrameCallback((_) {
          _markUnreadAsRead(items);
        });

        return OrderSectionCard(
          title: OrderStrings.notificationsSectionTitle,
          child: Column(
            children: [
              for (var i = 0; i < items.length; i++) ...[
                if (i > 0) const SizedBox(height: 10),
                _NotificationRow(notification: items[i]),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _NotificationRow extends StatelessWidget {
  const _NotificationRow({required this.notification});

  final InAppNotificationSummary notification;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: notification.isRead
            ? AppColors.cream
            : AppColors.accent.withValues(alpha: 0.06),
        borderRadius: AppRadii.md,
        border: Border.all(
          color: notification.isRead
              ? AppColors.creamDark
              : AppColors.accent.withValues(alpha: 0.25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  notification.title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: notification.isRead
                        ? AppColors.textSecondary
                        : AppColors.textPrimary,
                  ),
                ),
              ),
              Text(
                Formatters.shortDate(notification.createdAt),
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            notification.message,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}
