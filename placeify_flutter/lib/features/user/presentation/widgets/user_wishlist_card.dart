import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/services/haptic_service.dart';
import '../../../../core/utils/formatters.dart';
import '../../../home/domain/models/product.dart';
import '../../data/user_wishlist_mappers.dart';

class UserWishlistCard extends StatelessWidget {
  const UserWishlistCard({
    required this.entry,
    required this.onRemove,
    super.key,
  });

  final UserWishlistEntry entry;
  final VoidCallback onRemove;

  Product get product => entry.product;

  bool get _isAsset => product.imageUrl.startsWith('assets/');

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticService.light();
        context.push('/product/${product.id}');
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.warmWhite,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.creamDark, width: 1.5),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 72,
                height: 72,
                child: _ProductThumb(product: product, isAsset: _isAsset),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.espresso,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.shopName,
                    style: AppTypography.metricLabel.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    Formatters.currencyDecimal(product.price),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.espresso,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                HapticService.light();
                onRemove();
              },
              icon: const Icon(
                Icons.favorite_rounded,
                color: AppColors.coral,
              ),
              tooltip: 'Remove from wishlist',
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductThumb extends StatelessWidget {
  const _ProductThumb({
    required this.product,
    required this.isAsset,
  });

  final Product product;
  final bool isAsset;

  @override
  Widget build(BuildContext context) {
    if (isAsset) {
      return Image.asset(
        product.imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _Placeholder(svgPath: product.svgIconPath),
      );
    }

    return CachedNetworkImage(
      imageUrl: product.imageUrl,
      fit: BoxFit.cover,
      errorWidget: (_, __, ___) => _Placeholder(svgPath: product.svgIconPath),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.svgPath});

  final String svgPath;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.cream,
      child: Center(
        child: SvgPicture.asset(
          svgPath,
          width: 28,
          colorFilter: const ColorFilter.mode(
            AppColors.bark,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
