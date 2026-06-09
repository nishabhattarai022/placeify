import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/services/haptic_service.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/toast_overlay.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../domain/models/product.dart';
import '../providers/catalog_provider.dart';
import '../theme/home_screen_tokens.dart';

class HomeLiveProductsRow extends ConsumerWidget {
  const HomeLiveProductsRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalogAsync = ref.watch(catalogIndexProvider);

    return catalogAsync.when(
      loading: () => const SizedBox(
        height: 220,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
      error: (_, __) => const SizedBox.shrink(),
      data: (index) {
        final products = index.values.toList()
          ..sort((a, b) => b.id.compareTo(a.id));
        final featured = products.take(2).toList();
        if (featured.isEmpty) return const SizedBox.shrink();

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < featured.length; i++) ...[
              if (i > 0) const SizedBox(width: HomeScreenTokens.productGap),
              Expanded(child: _CatalogProductCard(product: featured[i])),
            ],
          ],
        );
      },
    );
  }
}

class _CatalogProductCard extends ConsumerWidget {
  const _CatalogProductCard({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAsset = product.imageUrl.startsWith('assets/');

    return GestureDetector(
      onTap: () {
        HapticService.light();
        context.push('/product/${product.id}');
      },
      child: Container(
        decoration: BoxDecoration(
          color: HomeScreenTokens.cardBg,
          borderRadius: BorderRadius.circular(HomeScreenTokens.cardRadius),
        ),
        padding: const EdgeInsets.all(HomeScreenTokens.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  BorderRadius.circular(HomeScreenTokens.cardImageRadius),
              child: SizedBox(
                height: HomeScreenTokens.cardImageHeight,
                width: double.infinity,
                child: isAsset
                    ? Image.asset(
                        product.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _placeholder(),
                      )
                    : CachedNetworkImage(
                        imageUrl: product.imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => _placeholder(),
                        errorWidget: (_, __, ___) => _placeholder(),
                      ),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              Formatters.currencyFull(product.price),
              style: HomeScreenTokens.productPrice(),
            ),
            const SizedBox(height: 4),
            Text(
              product.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: HomeScreenTokens.productName(),
            ),
            const SizedBox(height: 4),
            Text(
              product.brand,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                color: Colors.black.withValues(alpha: 0.45),
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  HapticService.medium();
                  ref.read(cartProvider.notifier).addProduct(product.id);
                  PlaceifyToast.show(
                    context,
                    '${product.name} added to cart',
                  );
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() {
    return ColoredBox(
      color: HomeScreenTokens.cardBg,
      child: Icon(
        Icons.chair_outlined,
        size: 56,
        color: Colors.black.withValues(alpha: 0.2),
      ),
    );
  }
}
