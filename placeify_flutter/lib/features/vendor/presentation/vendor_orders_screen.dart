import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radii.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/services/haptic_service.dart';
import '../../../core/widgets/bottom_nav/bottom_nav_tokens.dart';
import '../../../core/widgets/shimmer_loader.dart';
import '../domain/enums/order_status.dart';
import '../domain/models/vendor_order.dart';
import 'providers/vendor_orders_provider.dart';
import 'widgets/vendor_order_date_filter_sheet.dart';
import 'widgets/vendor_order_filter_tabs.dart';
import 'widgets/vendor_order_row.dart';
import 'widgets/vendor_orders_empty_state.dart';

class VendorOrdersScreen extends ConsumerStatefulWidget {
  const VendorOrdersScreen({this.showAllOrdersOnly = false, super.key});

  /// When true (dashboard "See all"), shows every order in a simple list.
  final bool showAllOrdersOnly;

  @override
  ConsumerState<VendorOrdersScreen> createState() => _VendorOrdersScreenState();
}

class _VendorOrdersScreenState extends ConsumerState<VendorOrdersScreen> {
  VendorOrderTab _selectedTab = VendorOrderTab.pending;
  String _searchQuery = '';
  VendorOrderDateFilter _dateFilter = VendorOrderDateFilter.all;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<VendorOrder> _filterOrders(List<VendorOrder> orders) {
    if (widget.showAllOrdersOnly) {
      return [...orders]..sort((a, b) => b.orderedAt.compareTo(a.orderedAt));
    }

    final query = _searchQuery.trim().toLowerCase();

    return orders.where((order) {
      if (!_matchesTab(order, _selectedTab)) return false;
      if (!_dateFilter.matches(order.orderedAt)) return false;
      if (query.isEmpty) return true;

      return order.customerName.toLowerCase().contains(query) ||
          order.orderNumber.toLowerCase().contains(query) ||
          order.productName.toLowerCase().contains(query) ||
          order.id.toLowerCase().contains(query);
    }).toList()
      ..sort((a, b) => b.orderedAt.compareTo(a.orderedAt));
  }

  bool _matchesTab(VendorOrder order, VendorOrderTab tab) {
    return switch (tab) {
      VendorOrderTab.pending => order.status == OrderStatus.pending,
      VendorOrderTab.active =>
        order.status == OrderStatus.accepted ||
            order.status == OrderStatus.processing ||
            order.status == OrderStatus.shipped,
      VendorOrderTab.completed => order.status == OrderStatus.delivered,
      VendorOrderTab.cancelled =>
        order.status == OrderStatus.cancelled ||
            order.status == OrderStatus.rejected,
    };
  }

  Future<void> _onRefresh() async {
    await ref.read(vendorOrdersProvider.notifier).refresh();
  }

  Future<void> _openDateFilter() async {
    final selected = await VendorOrderDateFilterSheet.show(
      context,
      _dateFilter,
    );
    if (selected != null && selected != _dateFilter) {
      setState(() => _dateFilter = selected);
    }
  }

  void _clearFilters() {
    setState(() {
      _searchQuery = '';
      _searchController.clear();
      _dateFilter = VendorOrderDateFilter.all;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ordersAsync = ref.watch(vendorOrdersProvider);

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!widget.showAllOrdersOnly)
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 14, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Orders', style: AppTypography.sectionTitle),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: _VendorOrdersSearchField(
                            controller: _searchController,
                            onChanged: (value) =>
                                setState(() => _searchQuery = value),
                          ),
                        ),
                        const SizedBox(width: 10),
                        _DateFilterButton(
                          filter: _dateFilter,
                          onTap: _openDateFilter,
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    VendorOrderFilterTabs(
                      selectedTab: _selectedTab,
                      onSelected: (tab) => setState(() => _selectedTab = tab),
                    ),
                  ],
                ),
              )
            else
              const Padding(
                padding: EdgeInsets.fromLTRB(24, 14, 24, 0),
                child: Text('Orders', style: AppTypography.sectionTitle),
              ),
            const SizedBox(height: 16),
            Expanded(
              child: ordersAsync.when(
                loading: () => const _OrdersListShimmer(),
                error: (_, __) => VendorOrdersEmptyState(
                  tab: _selectedTab,
                  onSwitchTab: (tab) => setState(() => _selectedTab = tab),
                ),
                data: (orders) {
                  final filtered = _filterOrders(orders);

                  if (filtered.isEmpty) {
                    if (widget.showAllOrdersOnly) {
                      return RefreshIndicator(
                        onRefresh: _onRefresh,
                        color: AppColors.espresso,
                        child: ListView(
                          physics: const AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics(),
                          ),
                          children: [
                            SizedBox(
                              height: MediaQuery.sizeOf(context).height * 0.35,
                              child: Center(
                                child: Text(
                                  'No orders yet',
                                  style: AppTypography.metricLabel.copyWith(
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: BottomNavTokens.scrollBottomPadding,
                            ),
                          ],
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: _onRefresh,
                      color: AppColors.espresso,
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        children: [
                          SizedBox(
                            height: MediaQuery.sizeOf(context).height * 0.35,
                            child: VendorOrdersEmptyState(
                              tab: _selectedTab,
                              searchQuery: _searchQuery,
                              hasDateFilter:
                                  _dateFilter != VendorOrderDateFilter.all,
                              onClearFilters: _clearFilters,
                              onSwitchTab: (tab) =>
                                  setState(() => _selectedTab = tab),
                            ),
                          ),
                          const SizedBox(
                            height: BottomNavTokens.scrollBottomPadding,
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
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
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        return VendorOrderRow(order: filtered[index]);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VendorOrdersSearchField extends StatelessWidget {
  const _VendorOrdersSearchField({
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.warmWhite,
        borderRadius: AppRadii.pill,
        border: Border.all(color: AppColors.creamDark, width: 1.5),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: GoogleFonts.dmSans(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: 'Search orders, customers, products',
          hintStyle: GoogleFonts.dmSans(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColors.textMuted,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            size: 22,
            color: AppColors.textSecondary,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          isDense: true,
        ),
      ),
    );
  }
}

class _DateFilterButton extends StatelessWidget {
  const _DateFilterButton({
    required this.filter,
    required this.onTap,
  });

  final VendorOrderDateFilter filter;
  final VoidCallback onTap;

  bool get _isActive => filter != VendorOrderDateFilter.all;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticService.light();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: _isActive ? AppColors.accentBg : AppColors.warmWhite,
          borderRadius: AppRadii.pill,
          border: Border.all(
            color: _isActive ? AppColors.accent : AppColors.creamDark,
            width: 1.5,
          ),
        ),
        child: Icon(
          Icons.calendar_today_outlined,
          size: 20,
          color: _isActive ? AppColors.accent : AppColors.textSecondary,
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
      padding: const EdgeInsets.fromLTRB(24, 0, 24, AppSpacing.xxl),
      itemCount: 5,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, __) => const SizedBox(
        height: 76,
        child: ShimmerLoader(borderRadius: AppRadii.md),
      ),
    );
  }
}
