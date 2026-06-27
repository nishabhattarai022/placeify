import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:placeify_client/placeify_client.dart';

import '../../../../core/constants/app_typography.dart';
import 'user_order_card.dart';

/// Recent orders with live status on the user dashboard overview.
class UserDashboardRecentOrders extends StatelessWidget {
  const UserDashboardRecentOrders({
    required this.orders,
    super.key,
  });

  final List<UserOrderSummary> orders;

  static const _previewCount = 3;

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) return const SizedBox.shrink();

    final preview = orders.take(_previewCount).toList(growable: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text('Recent Orders', style: AppTypography.sectionTitle),
            ),
            GestureDetector(
              onTap: () => context.go('/user/orders'),
              child: const Text('See all', style: AppTypography.seeAll),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...preview.map((order) => UserOrderCard(order: order)),
      ],
    );
  }
}
