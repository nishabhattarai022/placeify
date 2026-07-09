import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../home/domain/models/product.dart';
import '../../data/product_3d_model_resolver.dart';

/// Minimal, AR-screen-local view of a catalog product.
class ArAddableProduct {
  const ArAddableProduct({
    required this.id,
    required this.name,
    required this.remoteModelUrl,
    required this.dimensions,
    this.thumbnailUrl,
  });

  final String id;
  final String name;
  final String remoteModelUrl;
  final ProductDimensions dimensions;
  final String? thumbnailUrl;

  /// Returns null when the product has no resolved 3D model URL yet.
  static ArAddableProduct? tryFromProduct(Product product) {
    final remoteModelUrl = Product3dModelResolver.modelUrlFor(product.id);
    if (remoteModelUrl == null || remoteModelUrl.isEmpty) return null;
    return ArAddableProduct(
      id: product.id,
      name: product.name,
      remoteModelUrl: remoteModelUrl,
      dimensions: product.dimensions,
      thumbnailUrl: product.imageUrl,
    );
  }

  /// Maps catalog products that have a 3D preview, excluding [excludeProductId].
  static List<ArAddableProduct> fromCatalogProducts(
    Iterable<Product> products, {
    String? excludeProductId,
  }) {
    return products
        .where(
          (product) =>
              product.id != excludeProductId &&
              Product3dModelResolver.hasPreview(product),
        )
        .map(tryFromProduct)
        .whereType<ArAddableProduct>()
        .toList();
  }
}

/// Slide-up tray shown inside the AR view for adding more products to the
/// room without leaving the camera. Call [ArProductTray.show] rather than
/// constructing this directly.
class ArProductTray extends StatelessWidget {
  const ArProductTray({
    required this.products,
    required this.onSelected,
    super.key,
  });

  final List<ArAddableProduct> products;
  final ValueChanged<ArAddableProduct> onSelected;

  static Future<ArAddableProduct?> show(
    BuildContext context, {
    required List<ArAddableProduct> products,
  }) {
    return showModalBottomSheet<ArAddableProduct>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => ArProductTray(
        products: products,
        onSelected: (product) => Navigator.of(context).pop(product),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.55),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
              ),
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 36,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 14),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const Text(
                    'Add to your room',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (products.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Text(
                        'No other products available to add right now.',
                        style: TextStyle(color: Colors.white70),
                      ),
                    )
                  else
                    SizedBox(
                      height: 128,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: products.length,
                        separatorBuilder: (_, _) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return _ArTrayProductCard(
                            product: product,
                            onTap: () => onSelected(product),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ArTrayProductCard extends StatelessWidget {
  const _ArTrayProductCard({required this.product, required this.onTap});

  final ArAddableProduct product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 92,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  color: Colors.white10,
                  child: product.thumbnailUrl != null
                      ? Image.network(
                          product.thumbnailUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => const Icon(
                            Icons.chair_alt_rounded,
                            color: Colors.white38,
                          ),
                        )
                      : const Icon(
                          Icons.chair_alt_rounded,
                          color: Colors.white38,
                        ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              product.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
