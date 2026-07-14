import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:placeify_flutter/core/constants/app_colors.dart';
import 'package:placeify_flutter/core/constants/app_radii.dart';
import 'package:placeify_flutter/core/constants/app_spacing.dart';
import 'package:placeify_flutter/core/constants/app_typography.dart';
import 'package:placeify_flutter/core/widgets/bottom_nav/bottom_nav_tokens.dart';
import 'package:placeify_flutter/core/widgets/shimmer_loader.dart';
import 'package:placeify_flutter/features/admin/domain/constants/admin_routes.dart';
import 'package:placeify_flutter/features/admin/domain/constants/admin_strings.dart';
import 'package:placeify_flutter/features/admin/domain/enums/admin_product_visibility_filter.dart';
import 'package:placeify_flutter/features/admin/domain/repositories/admin_product_repository.dart';
import 'package:placeify_flutter/features/admin/presentation/products/widgets/admin_product_row.dart';
import 'package:placeify_flutter/features/admin/presentation/providers/admin_products_provider.dart';
import 'package:placeify_flutter/features/admin/presentation/widgets/admin_empty_state.dart';

class AdminProductsScreen extends ConsumerStatefulWidget {
  const AdminProductsScreen({super.key});

  @override
  ConsumerState<AdminProductsScreen> createState() => _AdminProductsScreenState();
}

class _AdminProductsScreenState extends ConsumerState<AdminProductsScreen> {
  String _searchQuery = '';
  AdminProductVisibilityFilter _visibility = AdminProductVisibilityFilter.all;
  String? _categoryFilter;
  String? _vendorFilter;
  bool _reportedOnly = false;
  bool _sortNewest = true;
  bool _hasLoaded = false;
  final TextEditingController _searchController = TextEditingController();

  AdminProductListQuery get _query => AdminProductListQuery(
        searchQuery: _searchQuery,
        visibility: _visibility,
        categoryName: _categoryFilter,
        vendorId: _vendorFilter,
        reportedOnly: _reportedOnly,
        sortNewest: _sortNewest,
      );

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    await ref.read(adminProductsListProvider(_query).notifier).refresh();
  }

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(adminProductsListProvider(_query));

    productsAsync.whenData((products) {
      if (!_hasLoaded) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) setState(() => _hasLoaded = true);
        });
      }
      // #region agent log
      _debugLogAdminProducts(count: products.length, visibility: _visibility.name);
      // #endregion
    });

    final showShimmer = productsAsync.isLoading && !_hasLoaded;
    final categories = productsAsync.maybeWhen(
      data: (products) => products
          .map((product) => product.categoryName)
          .whereType<String>()
          .where((name) => name.trim().isNotEmpty)
          .toSet()
          .toList()
        ..sort(),
      orElse: () => <String>[],
    );

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: AppColors.espresso),
        title: const Text(
          AdminStrings.productsTitle,
          style: TextStyle(
            fontFamily: 'Fraunces',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.espresso,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
              child: TextField(
                controller: _searchController,
                onChanged: (value) => setState(() => _searchQuery = value),
                decoration: InputDecoration(
                  hintText: AdminStrings.productsSearchHint,
                  filled: true,
                  fillColor: AppColors.warmWhite,
                  prefixIcon: const Icon(Icons.search, color: AppColors.textMuted),
                  border: OutlineInputBorder(
                    borderRadius: AppRadii.md,
                    borderSide: const BorderSide(color: AppColors.creamDark),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: AppRadii.md,
                    borderSide: const BorderSide(color: AppColors.creamDark),
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
              child: Row(
                children: [
                  for (final filter in AdminProductVisibilityFilter.values)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(_visibilityLabel(filter)),
                        selected: _visibility == filter,
                        onSelected: (_) =>
                            setState(() => _visibility = filter),
                      ),
                    ),
                  FilterChip(
                    label: const Text('Reported'),
                    selected: _reportedOnly,
                    onSelected: (selected) =>
                        setState(() => _reportedOnly = selected),
                  ),
                  FilterChip(
                    label: Text(_sortNewest ? 'Newest' : 'Oldest'),
                    selected: true,
                    onSelected: (_) => setState(() => _sortNewest = !_sortNewest),
                  ),
                ],
              ),
            ),
            if (categories.isNotEmpty)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
                child: Row(
                  children: [
                    FilterChip(
                      label: const Text('All categories'),
                      selected: _categoryFilter == null,
                      onSelected: (_) => setState(() => _categoryFilter = null),
                    ),
                    for (final category in categories)
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: FilterChip(
                          label: Text(category),
                          selected: _categoryFilter == category,
                          onSelected: (_) =>
                              setState(() => _categoryFilter = category),
                        ),
                      ),
                  ],
                ),
              ),
            Expanded(
              child: showShimmer
                  ? const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: SizedBox(
                        height: 72,
                        child: ShimmerLoader(borderRadius: AppRadii.md),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _onRefresh,
                      color: AppColors.accent,
                      child: productsAsync.when(
                        loading: () => const SizedBox.shrink(),
                        error: (_, __) => ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(AppSpacing.screenPadding),
                          children: [
                            AdminEmptyState(
                              message: AdminStrings.productsLoadError,
                              icon: Icons.inventory_2_outlined,
                            ),
                            TextButton(
                              onPressed: _onRefresh,
                              child: Text(AdminStrings.retry),
                            ),
                          ],
                        ),
                        data: (products) {
                          if (products.isEmpty) {
                            return ListView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding: const EdgeInsets.all(AppSpacing.screenPadding),
                              children: [
                                AdminEmptyState(
                                  message: AdminStrings.productsEmpty,
                                  icon: Icons.inventory_2_outlined,
                                ),
                              ],
                            );
                          }

                          return ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.fromLTRB(
                              24,
                              0,
                              24,
                              BottomNavTokens.scrollBottomPadding,
                            ),
                            itemCount: products.length,
                            itemBuilder: (context, index) {
                              final product = products[index];
                              return AdminProductRow(
                                product: product,
                                onTap: () => context.push(
                                  AdminRoutes.productDetail(product.productId),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  String _visibilityLabel(AdminProductVisibilityFilter filter) {
    return switch (filter) {
      AdminProductVisibilityFilter.all => AdminStrings.filterAll,
      AdminProductVisibilityFilter.active => 'Active',
      AdminProductVisibilityFilter.removed => 'Removed',
    };
  }

  // #region agent log
  void _debugLogAdminProducts({required int count, required String visibility}) {
    try {
      final payload = {
        'sessionId': 'c092fc',
        'location': 'admin_products_screen.dart:build',
        'message': 'admin products loaded',
        'data': {'count': count, 'visibility': visibility},
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'runId': 'post-fix',
        'hypothesisId': 'H1',
      };
      File('/Users/rosikagajurel/Documents/College/placeify/.cursor/debug-c092fc.log')
          .writeAsStringSync('${jsonEncode(payload)}\n', mode: FileMode.append);
    } catch (_) {}
  }
  // #endregion
}
