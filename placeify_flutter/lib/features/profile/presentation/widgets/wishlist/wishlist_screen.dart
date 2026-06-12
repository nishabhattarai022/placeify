import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../home/data/mock_product_repository.dart';
import '../../../../home/presentation/providers/wishlist_provider.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/services/haptic_service.dart';
import '../../../../../core/widgets/superscript_count_title.dart';
import 'wishlist_grid_view.dart';
import 'wishlist_search_field.dart';

/// Shared wishlist UI used by the bottom-nav tab and profile menu.
class WishlistScreen extends ConsumerStatefulWidget {
  const WishlistScreen({
    this.showBackButton = false,
    super.key,
  });

  final bool showBackButton;

  @override
  ConsumerState<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends ConsumerState<WishlistScreen> {
  String _searchQuery = '';

  int _visibleProductCount() {
    final savedAt = ref.read(wishlistProvider);
    final byId = {
      for (final p in MockProductRepository.products) p.id: p,
    };
    final products = [
      for (final id in savedAt.keys)
        if (byId.containsKey(id)) byId[id]!,
    ];

    final query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty) return products.length;

    return products.where((p) => p.name.toLowerCase().contains(query)).length;
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(wishlistProvider);
    final visibleCount = _visibleProductCount();

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
                  if (widget.showBackButton)
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
                          child: SuperscriptCountTitle(
                            title: 'Wishlist',
                            count: visibleCount,
                          ),
                        ),
                      ],
                    )
                  else
                    SuperscriptCountTitle(
                      title: 'Wishlist',
                      count: visibleCount,
                    ),
                  const SizedBox(height: 16),
                  WishlistSearchField(
                    onChanged: (query) => setState(() => _searchQuery = query),
                  ),
                ],
              ),
            ),
            Expanded(
              child: WishlistGridView(
                searchQuery: _searchQuery,
                showBottomPadding: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

