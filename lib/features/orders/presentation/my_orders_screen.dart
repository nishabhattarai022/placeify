import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radii.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/widgets/bottom_nav/bottom_nav_tokens.dart';
import '../../../core/widgets/shimmer_loader.dart';
import '../../profile/presentation/widgets/profile_sub_hero.dart';
import '../domain/constants/order_strings.dart';
import '../domain/enums/order_list_filter.dart';
import '../domain/models/order.dart';
import 'providers/orders_provider.dart';
import 'widgets/order_card.dart';
import 'widgets/order_filter_chips.dart';
import 'widgets/order_list_entry.dart';
import 'widgets/order_quick_actions_sheet.dart';
import 'widgets/orders_empty_state.dart';

class MyOrdersScreen extends ConsumerStatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  ConsumerState<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends ConsumerState<MyOrdersScreen> {
  OrderListFilter _selectedFilter = OrderListFilter.all;
  bool _animateListEntry = true;

  Future<void> _onRefresh() async {
    await ref.read(ordersProvider.notifier).refresh();
  }

  void _onFilterSelected(OrderListFilter filter) {
    if (filter == _selectedFilter) return;
    setState(() {
      _selectedFilter = filter;
      _animateListEntry = false;
    });
  }

  List<Order> _sortedFilteredOrders() {
    final orders = ref.watch(filteredOrdersProvider(_selectedFilter));
    return [...orders]..sort((a, b) => b.placedAt.compareTo(a.placedAt));
  }

  @override
  Widget build(BuildContext context) {
    final ordersAsync = ref.watch(ordersProvider);
    final orderCount = ref.watch(ordersCountProvider);
    final filteredOrders = _sortedFilteredOrders();

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Column(
        children: [
          ProfileSubHero(
            title: OrderStrings.myOrdersTitle,
            bottom: Text(
              OrderStrings.ordersCountSubtitle(orderCount),
              style: GoogleFonts.dmSans(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Colors.white.withValues(alpha: 0.72),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
            child: OrderFilterChips(
              selectedFilter: _selectedFilter,
              onSelected: _onFilterSelected,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ordersAsync.when(
              loading: () => const _OrdersListShimmer(),
              error: (_, __) => _OrdersErrorState(onRetry: _onRefresh),
              data: (_) => AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                transitionBuilder: (child, animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child: filteredOrders.isEmpty
                    ? RefreshIndicator(
                        key: ValueKey('empty_$_selectedFilter'),
                        onRefresh: _onRefresh,
                        color: AppColors.espresso,
                        child: ListView(
                          physics: const AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics(),
                          ),
                          children: [
                            SizedBox(
                              height: MediaQuery.sizeOf(context).height * 0.35,
                              child: OrdersEmptyState(filter: _selectedFilter),
                            ),
                            const SizedBox(
                              height: BottomNavTokens.scrollBottomPadding,
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        key: ValueKey('list_$_selectedFilter'),
                        onRefresh: _onRefresh,
                        color: AppColors.espresso,
                        child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics(),
                          ),
                          padding: const EdgeInsets.fromLTRB(
                            24,
                            0,
                            24,
                            BottomNavTokens.scrollBottomPadding,
                          ),
                          itemCount: filteredOrders.length,
                          itemBuilder: (context, index) {
                            final order = filteredOrders[index];
                            final card = OrderCard(
                              order: order,
                              onLongPress: () => OrderQuickActionsSheet.show(
                                context,
                                ref,
                                order,
                              ),
                            );

                            if (!_animateListEntry) return card;

                            return OrderListEntry(
                              index: index,
                              enabled: _animateListEntry,
                              child: card,
                            );
                          },
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrdersListShimmer extends StatelessWidget {
  const _OrdersListShimmer();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, AppSpacing.xxl),
      itemCount: 5,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, __) => const SizedBox(
        height: 168,
        child: ShimmerLoader(borderRadius: AppRadii.lg),
      ),
    );
  }
}

class _OrdersErrorState extends StatelessWidget {
  const _OrdersErrorState({required this.onRetry});

  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 40,
              color: AppColors.textMuted,
            ),
            const SizedBox(height: 12),
            const Text(
              'Could not load orders',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.espresso,
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: onRetry,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.espresso,
                  borderRadius: AppRadii.pill,
                ),
                child: const Text(
                  'Try again',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.warmWhite,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
