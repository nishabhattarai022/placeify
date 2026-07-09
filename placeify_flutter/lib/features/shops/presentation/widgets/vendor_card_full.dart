import 'package:flutter/material.dart';

import 'package:placeify_flutter/core/constants/app_colors.dart';
import 'package:placeify_flutter/core/services/haptic_service.dart';
import 'package:placeify_flutter/core/theme/app_fonts.dart';
import 'package:placeify_flutter/features/shops/data/shop_listing_images.dart';
import 'package:placeify_flutter/features/shops/data/shop_listing_details.dart';
import 'package:placeify_flutter/features/shops/domain/constants/shop_strings.dart';
import 'package:placeify_flutter/features/shops/domain/models/shop_listing.dart';
import 'package:placeify_flutter/features/shops/presentation/widgets/shop_listing_image.dart';

const _kAccent = Color(0xFFB5654B);
const _kCardRadius = 22.0;

/// Tier A — shown when [ShopListing.productCount] >= 5.
///
/// Layout: 4:3 banner image with avatar chip + name / meta / count pill.
class VendorCardFull extends StatefulWidget {
  const VendorCardFull({
    required this.shop,
    required this.onTap,
    super.key,
  });

  final ShopListing shop;
  final VoidCallback onTap;

  @override
  State<VendorCardFull> createState() => _VendorCardFullState();
}

class _VendorCardFullState extends State<VendorCardFull> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final shop = widget.shop;
    final details = ShopListingDetails.forShop(shop);
    final w = MediaQuery.sizeOf(context).width;
    final tileWidth = (w / (w > 600 ? 3 : 2)).toInt();

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
          child: _CardShell(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _BannerSection(shop: shop, tileWidth: tileWidth),
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        shop.businessName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppFonts.cormorantGaramond(
                          fontSize: 19,
                          fontWeight: FontWeight.w600,
                          color: AppColors.charcoal,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${ShopStrings.establishedLabel} '
                        '${details.establishedYear} · ${shop.locality}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppFonts.dmSans(
                          fontSize: 13,
                          color: AppColors.charcoal.withValues(alpha: 0.55),
                        ),
                      ),
                      const SizedBox(height: 10),
                      _CountPill(count: shop.productCount),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CardShell extends StatelessWidget {
  const _CardShell({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.warmWhite,
        borderRadius: BorderRadius.circular(_kCardRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_kCardRadius),
        child: child,
      ),
    );
  }
}

class _BannerSection extends StatelessWidget {
  const _BannerSection({required this.shop, required this.tileWidth});

  final ShopListing shop;
  final int tileWidth;

  @override
  Widget build(BuildContext context) {
    final bannerUrl =
        shop.bannerUrl ?? ShopListingImages.defaultBanner;
    final logoUrl = shop.logoUrl ?? ShopListingImages.defaultLogo;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        AspectRatio(
          aspectRatio: 4 / 3,
          child: ShopListingImage(
            imageUrl: bannerUrl,
            width: double.infinity,
            memCacheWidth: tileWidth,
            fallbackUrl: ShopListingImages.defaultBanner,
          ),
        ),
        Positioned(
          bottom: -14,
          left: 12,
          child: _AvatarBadge(logoUrl: logoUrl),
        ),
      ],
    );
  }
}

class _AvatarBadge extends StatelessWidget {
  const _AvatarBadge({required this.logoUrl});

  final String logoUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.warmWhite,
        border: Border.all(color: AppColors.warmWhite, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipOval(
        child: ShopListingImage(
          imageUrl: logoUrl,
          width: 40,
          height: 40,
          fallbackUrl: ShopListingImages.defaultLogo,
        ),
      ),
    );
  }
}

class _CountPill extends StatelessWidget {
  const _CountPill({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: _kAccent.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '$count ${ShopStrings.productCountLabel}',
        style: AppFonts.dmSans(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: _kAccent,
        ),
      ),
    );
  }
}
