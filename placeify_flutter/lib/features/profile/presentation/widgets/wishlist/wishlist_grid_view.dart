import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../home/data/mock_product_repository.dart';
import '../../../../home/presentation/providers/wishlist_provider.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/services/haptic_service.dart';
import '../../../../../core/widgets/placeify_bottom_nav.dart';
import '../../../../../screens/widgets/category_product_list_tile.dart';
import 'wishlist_sort.dart';

/// Wishlist list — category-style rows with sort control.
class WishlistGridView extends ConsumerWidget {
  const WishlistGridView({
    this.showBottomPadding = true,
    super.key,
  });

  final bool showBottomPadding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedAt = ref.watch(wishlistProvider);
    final sort = ref.watch(wishlistSortProvider);
    final byId = {
      for (final p in MockProductRepository.products) p.id: p,
    };
    final products = sortWishlistProducts(
      products: [
        for (final id in savedAt.keys)
          if (byId.containsKey(id)) byId[id]!,
      ],
      savedAt: savedAt,
      sort: sort,
    );

    if (products.isEmpty) {
      return const _WishlistEmptyState();
    }

    final bottom = showBottomPadding
        ? BottomNavTokens.scrollBottomPadding +
            MediaQuery.paddingOf(context).bottom
        : 32.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenPadding,
            8,
            AppSpacing.screenPadding,
            12,
          ),
          child: _WishlistSortBar(
            sort: sort,
            onTap: () => _openSortSheet(context, ref, sort),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.screenPadding,
              0,
              AppSpacing.screenPadding,
              bottom,
            ),
            itemCount: products.length,
            separatorBuilder: (_, __) => const SizedBox(height: 32),
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
      ],
    );
  }

  void _openSortSheet(
    BuildContext context,
    WidgetRef ref,
    WishlistSort current,
  ) {
    HapticService.light();
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sort by',
                  style: GoogleFonts.dmSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                for (final option in WishlistSort.values)
                  _WishlistSortTile(
                    label: option.menuLabel,
                    selected: current == option,
                    onTap: () {
                      ref.read(wishlistSortProvider.notifier).state = option;
                      Navigator.pop(sheetContext);
                    },
                  ),
              ],
            ),
          ),
        );
      },
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
        Text(
          sort.barLabel,
          style: GoogleFonts.dmSans(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.textMuted,
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
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
      ],
    );
  }
}

class _WishlistSortTile extends StatelessWidget {
  const _WishlistSortTile({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        label,
        style: GoogleFonts.dmSans(
          fontSize: 14,
          fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
          color: Colors.black87,
        ),
      ),
      trailing: selected
          ? const Icon(Icons.check_rounded, size: 20, color: Colors.black87)
          : null,
      onTap: onTap,
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
