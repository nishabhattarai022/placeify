import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/bottom_nav/bottom_nav_tokens.dart';
import '../../user/data/user_order_mappers.dart';
import '../../user/presentation/widgets/user_order_card.dart';
import '../../user/presentation/widgets/user_order_filter_bar.dart';
import 'providers/profile_dashboard_provider.dart';
import 'widgets/profile_sub_hero.dart';

class ProfileOrdersScreen extends ConsumerStatefulWidget {
  const ProfileOrdersScreen({super.key});

  @override
  ConsumerState<ProfileOrdersScreen> createState() =>
      _ProfileOrdersScreenState();
}

class _ProfileOrdersScreenState extends ConsumerState<ProfileOrdersScreen> {
  int _filterIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(profileOrdersProvider.notifier).refresh();
    });
  }

  Future<void> _refresh() async {
    await ref.read(profileOrdersProvider.notifier).refresh();
  }

  @override
  Widget build(BuildContext context) {
    final ordersAsync = ref.watch(profileOrdersProvider);

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Column(
        children: [
          ProfileSubHero(
            title: 'My Orders',
            bottom: UserOrderFilterBar(
              filters: UserOrderMappers.orderFilters,
              selectedIndex: _filterIndex,
              onSelected: (index) => setState(() => _filterIndex = index),
            ),
          ),
          Expanded(
            child: ordersAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => Center(
                child: TextButton(
                  onPressed: _refresh,
                  child: const Text('Retry'),
                ),
              ),
              data: (orders) {
                final filtered =
                    UserOrderMappers.filterOrders(orders, _filterIndex);

                if (filtered.isEmpty) {
                  return Center(
                    child: Text(
                      orders.isEmpty
                          ? 'No orders yet'
                          : 'No ${UserOrderMappers.orderFilters[_filterIndex]} orders',
                      style: const TextStyle(color: AppColors.textMuted),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: _refresh,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(
                      18,
                      20,
                      18,
                      BottomNavTokens.scrollBottomPadding,
                    ),
                    children: [
                      for (final order in filtered) UserOrderCard(order: order),
                    ],
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
