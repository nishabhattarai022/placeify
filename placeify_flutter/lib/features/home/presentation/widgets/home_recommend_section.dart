import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/home_categories_config.dart';
import '../providers/home_room_provider.dart';
import '../theme/home_screen_tokens.dart';
import 'home_recommend_header.dart';
import 'home_recommend_product_card.dart';

/// "Recommend for you" section: header and animated product row.
class HomeRecommendSection extends ConsumerWidget {
  const HomeRecommendSection({super.key});

  static const _switchDuration = Duration(milliseconds: 220);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(recommendedProductsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HomeRecommendHeader(),
        const SizedBox(height: HomeScreenTokens.sectionSpacing),
        AnimatedSwitcher(
          duration: _switchDuration,
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.08),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
          child: products.isEmpty
              ? const _EmptyRecommendations(key: ValueKey('empty_recommendations'))
              : _RecommendProductGrid(
                  key: const ValueKey('recommendations'),
                  products: products,
                ),
        ),
      ],
    );
  }
}

class _RecommendProductGrid extends StatelessWidget {
  const _RecommendProductGrid({required this.products, super.key});

  final List<RecommendProduct> products;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < products.length; i += 2) ...[
          if (i > 0) const SizedBox(height: HomeScreenTokens.productGap),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: HomeRecommendProductCard(
                  key: ValueKey(products[i].id),
                  product: products[i],
                ),
              ),
              if (i + 1 < products.length) ...[
                const SizedBox(width: HomeScreenTokens.productGap),
                Expanded(
                  child: HomeRecommendProductCard(
                    key: ValueKey(products[i + 1].id),
                    product: products[i + 1],
                  ),
                ),
              ] else
                const Expanded(child: SizedBox.shrink()),
            ],
          ),
        ],
      ],
    );
  }
}

class _EmptyRecommendations extends StatelessWidget {
  const _EmptyRecommendations({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 4),
      child: Text(
        'No recommendations for this room yet',
        style: HomeScreenTokens.productName().copyWith(
          color: Colors.black45,
          fontSize: 15,
        ),
      ),
    );
  }
}
