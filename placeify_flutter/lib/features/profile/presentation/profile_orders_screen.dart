import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/bottom_nav/bottom_nav_tokens.dart';
import '../data/profile_mock_data.dart';
import 'widgets/orders/order_card.dart';
import 'widgets/orders/order_filter_tabs.dart';
import 'widgets/profile_sub_hero.dart';

class ProfileOrdersScreen extends StatefulWidget {
  const ProfileOrdersScreen({super.key});

  @override
  State<ProfileOrdersScreen> createState() => _ProfileOrdersScreenState();
}

class _ProfileOrdersScreenState extends State<ProfileOrdersScreen> {
  int _filterIndex = 0;

  List<ProfileOrder> get _filtered {
    if (_filterIndex == 0) return ProfileMockData.orders;
    final status = switch (_filterIndex) {
      1 => OrderStatus.processing,
      2 => OrderStatus.shipped,
      3 => OrderStatus.delivered,
      _ => OrderStatus.cancelled,
    };
    return ProfileMockData.orders.where((o) => o.status == status).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Column(
        children: [
          ProfileSubHero(
            title: 'My Orders',
            bottom: OrderFilterTabs(
              filters: ProfileMockData.orderFilters,
              selectedIndex: _filterIndex,
              onSelected: (i) => setState(() => _filterIndex = i),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                18,
                20,
                18,
                BottomNavTokens.scrollBottomPadding,
              ),
              children: [
                for (final order in _filtered) OrderCard(order: order),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
