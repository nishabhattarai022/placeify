import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/home_categories_config.dart';
import '../providers/home_room_provider.dart';
import '../theme/home_screen_tokens.dart';
import 'home_recommend_header.dart';
import 'home_recommend_product_card.dart';

/// "Recommend for you" section: header and animated product grid.
class HomeRecommendSection extends ConsumerWidget {
  const HomeRecommendSection({super.key});

  static const _switchDuration = Duration(milliseconds: 220);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomId = ref.watch(selectedRoomProvider);
    final productsAsync = ref.watch(recommendedProductsProvider);

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
          child: productsAsync.when(
            loading: () =>
                _LoadingRecommendations(key: ValueKey('loading_$roomId')),
            error: (_, _) =>
                _EmptyRecommendations(key: ValueKey('error_$roomId')),
            data: (products) => products.isEmpty
                ? _EmptyRecommendations(key: ValueKey('empty_$roomId'))
                : _RecommendProductGrid(
                    key: ValueKey(roomId),
                    products: products,
                  ),
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

class _LoadingRecommendations extends StatelessWidget {
  const _LoadingRecommendations({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 48),
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2.5),
        ),
      ),
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
