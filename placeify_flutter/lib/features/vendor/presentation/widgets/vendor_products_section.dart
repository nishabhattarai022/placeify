import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:placeify_client/placeify_client.dart';

import '../../../../core/config/resolve_media_url.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/utils/formatters.dart';

class VendorProductsSection extends StatelessWidget {
  const VendorProductsSection({
    required this.products,
    super.key,
  });

  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Your products', style: AppTypography.sectionTitle),
        const SizedBox(height: 12),
        SizedBox(
          height: 210,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              return _ProductCard(product: products[index]);
            },
          ),
        ),
      ],
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: resolveMediaUrl(product.thumbnailUrl),
      builder: (context, snapshot) {
        final imageUrl = snapshot.data ?? '';
        return Container(
          width: 160,
          decoration: BoxDecoration(
            color: AppColors.warmWhite,
            borderRadius: AppRadii.md,
            border: Border.all(color: AppColors.creamDark),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: imageUrl.isEmpty
                    ? Container(
                        color: AppColors.cream,
                        child: const Center(
                          child: Icon(
                            Icons.chair_outlined,
                            color: AppColors.bark,
                            size: 36,
                          ),
                        ),
                      )
                    : CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorWidget: (_, __, ___) => Container(
                          color: AppColors.cream,
                          child: const Icon(Icons.broken_image_outlined),
                        ),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      Formatters.currencyDecimal(product.price),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.espresso,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
