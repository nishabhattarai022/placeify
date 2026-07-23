import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/services/haptic_service.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/shimmer_loader.dart';
import '../../../home/presentation/providers/category_provider.dart';
import '../../domain/constants/order_strings.dart';
import '../../domain/models/order_item.dart';

class OrderItemRow extends ConsumerWidget {
  const OrderItemRow({
    required this.item,
    super.key,
  });

  final OrderItem item;

  static const _imageSize = 80.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final product = ref.watch(productByIdProvider(item.productId));
    final canViewProduct = product != null;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: _imageSize,
            height: _imageSize,
            decoration: BoxDecoration(
              color: AppColors.cream,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.creamDark, width: 1.5),
            ),
            clipBehavior: Clip.antiAlias,
            child: _OrderItemImage(imageUrl: item.productImageUrl),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  style: AppTypography.productName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (item.brandName.trim().isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    item.brandName,
                    style: AppTypography.brandName,
                  ),
                ],
                if (item.dimensionsLabel.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    item.dimensionsLabel,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
                if (item.selectedColor != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    'Color: ${item.selectedColor}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
                const SizedBox(height: 6),
                Text(
                  item.discountedPrice != null
                      ? 'Qty ${item.quantity} × ${Formatters.currencyFull(item.discountedPrice!)}  (was ${Formatters.currencyFull(item.unitPrice)})'
                      : 'Qty ${item.quantity} × ${Formatters.currencyFull(item.effectiveUnitPrice)}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                if (canViewProduct) ...[
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      HapticService.light();
                      context.pushNamed(
                        'productDetail',
                        pathParameters: {'productId': item.productId},
                      );
                    },
                    child: Text(
                      OrderStrings.viewProductAction,
                      style: AppTypography.seeAll.copyWith(fontSize: 12),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            Formatters.currencyFull(item.lineTotal),
            style: AppTypography.productName,
          ),
        ],
      ),
    );
  }
}

class _OrderItemImage extends StatelessWidget {
  const _OrderItemImage({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final trimmed = imageUrl.trim();
    if (trimmed.isEmpty) {
      return _fallbackIcon();
    }

    final fit =
        trimmed.startsWith('assets/') ? BoxFit.contain : BoxFit.cover;

    if (trimmed.startsWith('assets/')) {
      return Padding(
        padding: const EdgeInsets.all(8),
        child: Image.asset(
          trimmed,
          fit: fit,
          errorBuilder: (_, __, ___) => _fallbackIcon(),
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: trimmed,
      fit: fit,
      placeholder: (_, __) => const ShimmerLoader(),
      errorWidget: (_, __, ___) => _fallbackIcon(),
    );
  }

  Widget _fallbackIcon() {
    return Center(
      child: SvgPicture.asset(
        'assets/icons/ic_chair.svg',
        width: 28,
        colorFilter: const ColorFilter.mode(
          AppColors.bark,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}
