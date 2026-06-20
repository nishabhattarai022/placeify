import 'package:flutter/material.dart';

import 'package:placeify/core/constants/app_colors.dart';
import 'package:placeify/core/services/haptic_service.dart';
import 'package:placeify/core/theme/app_fonts.dart';
import 'package:placeify/features/shops/data/shop_listing_images.dart';
import 'package:placeify/features/shops/data/shop_listing_details.dart';
import 'package:placeify/features/shops/domain/constants/shop_strings.dart';
import 'package:placeify/features/shops/domain/models/shop_listing.dart';
import 'package:placeify/features/shops/presentation/widgets/shop_listing_image.dart';

const _kAccentCompact = Color(0xFFB5654B);
const _kCardRadiusCompact = 22.0;

/// Tier B — shown when [ShopListing.productCount] is between 1 and 4.
///
/// Layout: logo square (56 × 56) on the left + name / meta on the right + count pill.
class VendorCardCompact extends StatefulWidget {
  const VendorCardCompact({
    required this.shop,
    required this.onTap,
    super.key,
  });

  final ShopListing shop;
  final VoidCallback onTap;

  @override
  State<VendorCardCompact> createState() => _VendorCardCompactState();
}

class _VendorCardCompactState extends State<VendorCardCompact> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final shop = widget.shop;
    final details = ShopListingDetails.forShop(shop);

    return Semantics(
      label: '${shop.businessName}, ${shop.locality}, '
          '${shop.productCount} ${ShopStrings.productCountLabel}',
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
              borderRadius: BorderRadius.circular(_kCardRadiusCompact),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(_kCardRadiusCompact),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _LogoSquare(shop: shop),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                shop.businessName,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: AppFonts.cormorantGaramond(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.charcoal,
                                  height: 1.2,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${ShopStrings.establishedLabel} '
                                '${details.establishedYear} · ${shop.locality}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: AppFonts.dmSans(
                                  fontSize: 12,
                                  color: AppColors.charcoal.withValues(
                                    alpha: 0.55,
                                  ),
                                  height: 1.35,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _CountPillCompact(count: shop.productCount),
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

class _LogoSquare extends StatelessWidget {
  const _LogoSquare({required this.shop});

  final ShopListing shop;

  @override
  Widget build(BuildContext context) {
    const size = 56.0;
    final logoUrl = shop.logoUrl ?? ShopListingImages.defaultLogo;

    return ShopListingImage(
      imageUrl: logoUrl,
      width: size,
      height: size,
      borderRadius: BorderRadius.circular(14),
      fallbackUrl: ShopListingImages.defaultLogo,
    );
  }
}

class _CountPillCompact extends StatelessWidget {
  const _CountPillCompact({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: _kAccentCompact.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '$count ${ShopStrings.productCountLabel}',
        style: AppFonts.dmSans(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: _kAccentCompact,
        ),
      ),
    );
  }
}
