import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/services/haptic_service.dart';
import '../../../core/theme/app_fonts.dart';
import '../../../core/widgets/bottom_nav/bottom_nav_tokens.dart';
import '../../../core/widgets/shimmer_loader.dart';
import '../../../core/widgets/superscript_count_title.dart';
import '../../home/presentation/chairs_catalog_tokens.dart';
import '../domain/constants/order_strings.dart';
import '../domain/enums/order_list_filter.dart';
import '../domain/models/order.dart';
import 'providers/orders_provider.dart';
import 'widgets/order_card.dart';
import 'widgets/order_filter_sheet.dart';
import 'widgets/order_list_entry.dart';
import 'widgets/order_quick_actions_sheet.dart';
import 'widgets/orders_empty_state.dart';
import 'widgets/orders_filter_bar.dart';
import 'widgets/orders_search_field.dart';

class MyOrdersScreen extends ConsumerStatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  ConsumerState<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends ConsumerState<MyOrdersScreen> {
  OrderListFilter _selectedFilter = OrderListFilter.all;
  bool _animateListEntry = true;
  String _searchQuery = '';

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

  void _openFilterSheet() {
    OrderFilterSheet.show(
      context,
      _selectedFilter,
      _onFilterSelected,
    );
  }

  List<Order> _sortedFilteredOrders() {
    final orders = ref.watch(filteredOrdersProvider(_selectedFilter));
    final sorted = [...orders]..sort((a, b) => b.placedAt.compareTo(a.placedAt));

    final query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty) return sorted;

    return sorted.where((order) {
      if (order.orderNumber.toLowerCase().contains(query)) return true;
      if (order.id.toLowerCase().contains(query)) return true;
      if (order.vendorName.toLowerCase().contains(query)) return true;
      for (final item in order.items) {
        if (item.productName.toLowerCase().contains(query)) return true;
      }
      return false;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final ordersAsync = ref.watch(ordersProvider);
    final orderCount = ref.watch(ordersCountProvider);
    final filteredOrders = _sortedFilteredOrders();
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenPadding,
                16,
                AppSpacing.screenPadding,
                8,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          HapticService.light();
                          context.pop();
                        },
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.warmWhite,
                            border: Border.all(color: AppColors.creamDark),
                          ),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.arrow_back,
                            color: AppColors.espresso,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SuperscriptCountTitle(
                              title: OrderStrings.myOrdersTitle,
                              count: orderCount,
                            ),
                            const SizedBox(height: 4),
                            Padding(
                              padding: const EdgeInsets.only(left: 2),
                              child: Text(
                                OrderStrings.myOrdersItalicLine,
                                style: AppFonts.dmSerifDisplay(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.italic,
                                  color: AppColors.textMuted,
                                  height: 1.05,
                                  letterSpacing: -0.3,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  OrdersSearchField(
                    onChanged: (query) => setState(() => _searchQuery = query),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ordersAsync.when(
                loading: () => const _OrdersListShimmer(),
                error: (_, _) => _OrdersErrorState(onRetry: _onRefresh),
                data: (_) => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    OrdersFilterBar(
                      filter: _selectedFilter,
                      onFilterTap: _openFilterSheet,
                    ),
                    Expanded(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        switchInCurve: Curves.easeOut,
                        switchOutCurve: Curves.easeIn,
                        transitionBuilder: (child, animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                        child: _buildOrdersBody(
                          key: ValueKey(
                            '${_selectedFilter.name}_${_searchQuery.trim()}',
                          ),
                          filteredOrders: filteredOrders,
                          bottomInset: bottomInset,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrdersBody({
    required Key key,
    required List<Order> filteredOrders,
    required double bottomInset,
  }) {
    if (filteredOrders.isEmpty) {
      final hasSearch = _searchQuery.trim().isNotEmpty;

      return RefreshIndicator(
        key: key,
        onRefresh: _onRefresh,
        color: AppColors.espresso,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          padding: EdgeInsets.fromLTRB(
            AppSpacing.screenPadding,
            0,
            AppSpacing.screenPadding,
            BottomNavTokens.scrollBottomPadding + bottomInset,
          ),
          children: [
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.28,
              child: hasSearch
                  ? _OrdersNoSearchResultsState(query: _searchQuery.trim())
                  : OrdersEmptyState(filter: _selectedFilter),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      key: key,
      onRefresh: _onRefresh,
      color: AppColors.espresso,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: EdgeInsets.fromLTRB(
          AppSpacing.screenPadding,
          0,
          AppSpacing.screenPadding,
          BottomNavTokens.scrollBottomPadding + bottomInset,
        ),
        itemCount: filteredOrders.length,
        separatorBuilder: (_, _) => const SizedBox(height: 32),
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
    );
  }
}

class _OrdersNoSearchResultsState extends StatelessWidget {
  const _OrdersNoSearchResultsState({required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 40,
              color: AppColors.textMuted.withValues(alpha: 0.7),
            ),
            const SizedBox(height: 16),
            Text(
              OrderStrings.noSearchResults(query),
              textAlign: TextAlign.center,
              style: GoogleFonts.dmSans(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.espresso,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              OrderStrings.noSearchResultsSubtitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.dmSans(
                fontSize: 14,
                color: AppColors.textMuted,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrdersListShimmer extends StatelessWidget {
  const _OrdersListShimmer();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        8,
        AppSpacing.screenPadding,
        AppSpacing.xxl,
      ),
      itemCount: 5,
      separatorBuilder: (_, _) => const SizedBox(height: 32),
      itemBuilder: (_, _) => const SizedBox(
        height: 320,
        child: ShimmerLoader(
          borderRadius: BorderRadius.all(
            Radius.circular(ChairsCatalogTokens.wideCardRadius),
          ),
        ),
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
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.warmWhite,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.creamDark),
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                size: 32,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Could not load orders',
              style: TextStyle(
                fontFamily: 'Fraunces',
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: AppColors.espresso,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: onRetry,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.espresso,
                foregroundColor: AppColors.warmWhite,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              child: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}
