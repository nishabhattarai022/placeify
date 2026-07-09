import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:placeify_flutter/core/services/haptic_service.dart';
import 'package:placeify_flutter/core/theme/app_fonts.dart';
import 'package:placeify_flutter/features/shops/domain/constants/shop_routes.dart';
import 'package:placeify_flutter/features/shops/domain/constants/shop_strings.dart';

import '../product_detail_tokens.dart';

/// Tappable vendor attribution row shown on shop-sourced product detail.
class ProductDetailSoldByRow extends StatelessWidget {
  const ProductDetailSoldByRow({
    required this.vendorId,
    required this.businessName,
    super.key,
  });

  final String vendorId;
  final String businessName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        ProductDetailTokens.infoCardHorizontalPadding,
        0,
        ProductDetailTokens.infoCardHorizontalPadding,
        ProductDetailTokens.infoCardTopGap,
      ),
      child: GestureDetector(
        onTap: () {
          HapticService.light();
          context.push(ShopRoutes.shopDetail(vendorId));
        },
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: ProductDetailTokens.infoCardBg,
            borderRadius:
                BorderRadius.circular(ProductDetailTokens.infoCardRadius),
            border: Border.all(
              color: Colors.black.withValues(alpha: 0.06),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.7),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.storefront_outlined,
                  size: 18,
                  color: ProductDetailTokens.textPrimary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ShopStrings.soldByPrefix,
                      style: AppFonts.dmSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: ProductDetailTokens.textSecondary,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      businessName,
                      style: AppFonts.dmSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: ProductDetailTokens.textPrimary,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: ProductDetailTokens.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
