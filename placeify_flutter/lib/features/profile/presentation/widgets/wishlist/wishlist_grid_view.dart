import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../home/data/mock_product_repository.dart';
import '../../../../home/presentation/providers/wishlist_provider.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/services/haptic_service.dart';
import '../../../../../core/widgets/animated_scale_tap.dart';
import '../../../../../core/widgets/placeify_bottom_nav.dart';
import '../../../../../screens/widgets/category_product_list_tile.dart';
import 'wishlist_sort.dart';
import 'wishlist_sort_provider.dart';
import 'wishlist_sort_sheet.dart';

/// Wishlist list — category-style rows with sort control.
class WishlistGridView extends ConsumerWidget {
  const WishlistGridView({
    this.searchQuery = '',
    this.showBottomPadding = true,
    super.key,
  });

  final String searchQuery;
  final bool showBottomPadding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlist = ref.watch(wishlistProvider);
    final savedAt = wishlist.savedAt;
    final sort = ref.watch(wishlistSortProvider);
    final byId = {
      for (final p in MockProductRepository.products) p.id: p,
    };
    final resolvedProducts = wishlist.products.isNotEmpty
        ? wishlist.products
        : [
            for (final id in savedAt.keys)
              if (byId.containsKey(id)) byId[id]!,
          ];
    final sortedProducts = sortWishlistProducts(
      products: resolvedProducts,
      savedAt: savedAt,
      sort: sort,
    );

    final query = searchQuery.trim().toLowerCase();
    final products = query.isEmpty
        ? sortedProducts
        : sortedProducts
            .where((p) => p.name.toLowerCase().contains(query))
            .toList();

    if (savedAt.isEmpty) {
      return const _WishlistEmptyState();
    }

    if (products.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _WishlistSortBarSection(
            sort: sort,
            onTap: () => WishlistSortSheet.show(context, ref, sort),
          ),
          Expanded(
            child: _WishlistNoSearchResultsState(
              query: searchQuery.trim(),
            ),
          ),
        ],
      );
    }

    final bottom = showBottomPadding
        ? BottomNavTokens.scrollBottomPadding +
            MediaQuery.paddingOf(context).bottom
        : 32.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _WishlistSortBarSection(
          sort: sort,
          onTap: () => WishlistSortSheet.show(context, ref, sort),
        ),
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            child: ListView.separated(
              key: ValueKey(sort.name),
              padding: EdgeInsets.fromLTRB(
                AppSpacing.screenPadding,
                0,
                AppSpacing.screenPadding,
                bottom,
              ),
              itemCount: products.length,
              separatorBuilder: (_, _) => const SizedBox(height: 32),
              itemBuilder: (context, index) {
                final product = products[index];
                return CategoryProductListTile(
                  product: product,
                  onRemoveFromWishlist: () {
                    ref.read(wishlistProvider.notifier).toggle(product.id);
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _WishlistSortBarSection extends StatelessWidget {
  const _WishlistSortBarSection({
    required this.sort,
    required this.onTap,
  });

  final WishlistSort sort;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        8,
        AppSpacing.screenPadding,
        12,
      ),
      child: _WishlistSortBar(sort: sort, onTap: onTap),
    );
  }
}

class _WishlistSortBar extends StatelessWidget {
  const _WishlistSortBar({
    required this.sort,
    required this.onTap,
  });

  final WishlistSort sort;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          sort.icon,
          size: 16,
          color: AppColors.textMuted,
        ),
        const SizedBox(width: 6),
        Text(
          sort.barLabel,
          style: GoogleFonts.dmSans(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.textMuted,
          ),
        ),
        const Spacer(),
        AnimatedScaleTap(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: AppColors.warmWhite,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: AppColors.creamDark),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Sort by',
                  style: GoogleFonts.dmSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.espresso,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.unfold_more_rounded,
                  size: 18,
                  color: AppColors.espresso,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _WishlistNoSearchResultsState extends StatelessWidget {
  const _WishlistNoSearchResultsState({required this.query});

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
              'No results for "$query"',
              textAlign: TextAlign.center,
              style: GoogleFonts.dmSans(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.espresso,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try a different product name.',
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

class _WishlistEmptyState extends StatelessWidget {
  const _WishlistEmptyState();

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
              child: Icon(
                Icons.star_border_rounded,
                size: 32,
                color: AppColors.rust.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'No saved items yet',
              style: TextStyle(
                fontFamily: 'Fraunces',
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: AppColors.espresso,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the star on any product to save it here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textMuted,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () {
                HapticService.light();
                context.go('/browse');
              },
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
              child: const Text('Browse furniture'),
            ),
          ],
        ),
      ),
    );
  }
}
