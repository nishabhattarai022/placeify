import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../domain/models/vendor_product.dart';

/// Offer badge for vendor product list tiles (matches catalog card styling).
class VendorProductSaleBadge extends StatelessWidget {
  const VendorProductSaleBadge({required this.product, super.key});

  final VendorProduct product;

  @override
  Widget build(BuildContext context) {
    if (!product.isOnSale) return const SizedBox.shrink();

    final percent = product.discountPercent.round();
    final label = percent > 0 ? '$percent% OFF' : 'Special Offer';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.rust.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          color: AppColors.warmWhite,
        ),
      ),
    );
  }
}
