import 'package:flutter/material.dart';

import 'package:placeify/core/constants/app_colors.dart';
import 'package:placeify/core/services/haptic_service.dart';
import 'package:placeify/core/theme/app_fonts.dart';
import 'package:placeify/features/shops/data/shop_listing_images.dart';
import 'package:placeify/features/shops/domain/models/shop_listing.dart';
import 'package:placeify/features/shops/presentation/widgets/shop_listing_image.dart';

const _kCardRadiusMinimal = 22.0;

/// Tier C — shown when [ShopListing.productCount] is 0.
///
/// Quieter outlined card: shop image + name + "Opening soon" badge.
class VendorCardMinimal extends StatefulWidget {
  const VendorCardMinimal({
    required this.shop,
    required this.onTap,
    super.key,
  });

  final ShopListing shop;
  final VoidCallback onTap;

  @override
  State<VendorCardMinimal> createState() => _VendorCardMinimalState();
}

class _VendorCardMinimalState extends State<VendorCardMinimal> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final shop = widget.shop;

    return Semantics(
      label: '${shop.businessName}, ${shop.locality}, no items listed yet',
      button: true,
      excludeSemantics: true,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) {
          setState(() => _pressed = false);
          HapticService.light();
          widget.onTap();
        },
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedScale(
          scale: _pressed ? 0.97 : 1.0,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOutCubic,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.warmWhite,
              borderRadius: BorderRadius.circular(_kCardRadiusMinimal),
              border: Border.all(
                color: AppColors.charcoal.withValues(alpha: 0.10),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(_kCardRadiusMinimal),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ShopImagePreview(shop: shop),
                    const SizedBox(height: 12),
                    Text(
                      shop.businessName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppFonts.cormorantGaramond(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: AppColors.charcoal.withValues(alpha: 0.70),
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      shop.locality,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppFonts.dmSans(
                        fontSize: 12,
                        color: AppColors.charcoal.withValues(alpha: 0.40),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const _OpeningSoonBadge(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ShopImagePreview extends StatelessWidget {
  const _ShopImagePreview({required this.shop});

  final ShopListing shop;

  @override
  Widget build(BuildContext context) {
    final imageUrl = shop.bannerUrl ??
        shop.logoUrl ??
        ShopListingImages.defaultBanner;

    return ShopListingImage(
      imageUrl: imageUrl,
      width: double.infinity,
      height: 88,
      borderRadius: BorderRadius.circular(12),
      fallbackUrl: ShopListingImages.defaultBanner,
    );
  }
}

class _OpeningSoonBadge extends StatelessWidget {
  const _OpeningSoonBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.charcoal.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'Opening soon',
        style: AppFonts.dmSans(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: AppColors.charcoal.withValues(alpha: 0.45),
        ),
      ),
    );
  }
}
