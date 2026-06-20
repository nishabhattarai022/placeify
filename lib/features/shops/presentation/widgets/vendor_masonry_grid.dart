import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';

import 'package:placeify/features/shops/domain/constants/shop_routes.dart';
import 'package:placeify/features/shops/domain/models/shop_listing.dart';
import 'package:placeify/features/shops/presentation/widgets/vendor_card_compact.dart';
import 'package:placeify/features/shops/presentation/widgets/vendor_card_full.dart';
import 'package:placeify/features/shops/presentation/widgets/vendor_card_minimal.dart';

// ── Tier logic ─────────────────────────────────────────────────────────────────

enum _VendorCardTier { full, compact, minimal }

_VendorCardTier _tier(int count) {
  if (count >= 5) return _VendorCardTier.full;
  if (count >= 1) return _VendorCardTier.compact;
  return _VendorCardTier.minimal;
}

// ── Public widget ──────────────────────────────────────────────────────────────

/// Masonry grid of vendor cards with staggered tier-based heights.
///
/// - 2 columns on phones (width ≤ 600 dp), 3 on tablets.
/// - Each card wrapped in [RepaintBoundary] for paint isolation.
/// - Entrance: fade + 12 px upward slide per card, 40 ms stagger (capped at 8).
/// - Reduced-motion: skips animation when
///   [MediaQueryData.disableAnimations] is true.
class VendorMasonryGrid extends StatelessWidget {
  const VendorMasonryGrid({
    required this.shops,
    this.query = '',
    super.key,
  });

  final List<ShopListing> shops;
  final String query;

  @override
  Widget build(BuildContext context) {
    final crossAxisCount =
        MediaQuery.sizeOf(context).width > 600 ? 3 : 2;

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
      sliver: SliverMasonryGrid.count(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        itemBuilder: (context, index) {
          final shop = shops[index];
          return RepaintBoundary(
            key: ValueKey(shop.vendorId),
            child: _AnimatedCard(
              index: index,
              shop: shop,
            ),
          );
        },
        childCount: shops.length,
      ),
    );
  }
}

// ── Entrance animation wrapper ─────────────────────────────────────────────────

class _AnimatedCard extends StatefulWidget {
  const _AnimatedCard({
    required this.index,
    required this.shop,
  });

  final int index;
  final ShopListing shop;

  @override
  State<_AnimatedCard> createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<_AnimatedCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<double> _slide;

  @override
  void initState() {
    super.initState();

    final staggerIndex = widget.index.clamp(0, 7);
    _controller = AnimationController(
      duration: Duration(milliseconds: 320 + staggerIndex * 40),
      vsync: this,
    );

    _opacity = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    _slide = Tween<double>(begin: 12, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.of(context).disableAnimations) {
      _controller.value = 1.0;
    } else {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => FadeTransition(
        opacity: _opacity,
        child: Transform.translate(
          offset: Offset(0, _slide.value),
          child: child,
        ),
      ),
      child: _TieredCard(shop: widget.shop),
    );
  }
}

// ── Tier dispatch ──────────────────────────────────────────────────────────────

class _TieredCard extends StatelessWidget {
  const _TieredCard({required this.shop});

  final ShopListing shop;

  void _navigateToShop(BuildContext context) {
    context.push(ShopRoutes.shopDetail(shop.vendorId));
  }

  @override
  Widget build(BuildContext context) {
    switch (_tier(shop.productCount)) {
      case _VendorCardTier.full:
        return VendorCardFull(
          shop: shop,
          onTap: () => _navigateToShop(context),
        );
      case _VendorCardTier.compact:
        return VendorCardCompact(
          shop: shop,
          onTap: () => _navigateToShop(context),
        );
      case _VendorCardTier.minimal:
        return VendorCardMinimal(
          shop: shop,
          onTap: () => _navigateToShop(context),
        );
    }
  }
}
