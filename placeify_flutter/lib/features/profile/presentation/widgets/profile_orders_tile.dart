import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../orders/domain/constants/order_strings.dart';
import '../../../orders/presentation/providers/orders_provider.dart';
import '../../data/profile_menu_config.dart';
import 'profile_menu_tile.dart';

class ProfileOrdersTile extends ConsumerWidget {
  const ProfileOrdersTile({required this.onTap, super.key});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(ordersCountProvider);
    final inTransit = ref.watch(inTransitOrderCountProvider);

    final item = ProfileMenuItemData(
      title: OrderStrings.profileMenuTitle,
      subtitle: OrderStrings.ordersSubtitle(count, inTransit),
      icon: Icons.inventory_2_outlined,
      iconColor: AppColors.sage,
      backgroundColor: AppColors.sageBg,
      route: ProfileMenuRoute.orders,
      badge: inTransit > 0 ? '$inTransit' : null,
    );

    return ProfileMenuTile(item: item, onTap: onTap);
  }
}
