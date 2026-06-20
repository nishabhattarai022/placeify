import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'package:placeify/core/constants/app_colors.dart';
import 'package:placeify/core/services/haptic_service.dart';
import 'package:placeify/core/theme/app_fonts.dart';
import 'package:placeify/features/shops/data/shop_listing_details.dart';
import 'package:placeify/features/shops/domain/constants/shop_strings.dart';
import 'package:placeify/features/shops/domain/models/shop_listing.dart';

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
                // ── Banner + avatar badge ────────────────────────────────
                _BannerSection(shop: shop, tileWidth: tileWidth),
                // ── Text content ─────────────────────────────────────────
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

// ── Sub-widgets ────────────────────────────────────────────────────────────────

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
    final bannerUrl = shop.bannerUrl;
    final logoUrl = shop.logoUrl;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Banner image
        AspectRatio(
          aspectRatio: 4 / 3,
          child: _BannerImage(
            shop: shop,
            bannerUrl: bannerUrl,
            tileWidth: tileWidth,
          ),
        ),
        // Avatar badge at bottom-left, overlapping into card body
        if (logoUrl != null && logoUrl.isNotEmpty)
          Positioned(
            bottom: -14,
            left: 12,
            child: _AvatarBadge(logoUrl: logoUrl),
          ),
      ],
    );
  }
}

class _BannerImage extends StatelessWidget {
  const _BannerImage({
    required this.shop,
    required this.bannerUrl,
    required this.tileWidth,
  });

  final ShopListing shop;
  final String? bannerUrl;
  final int tileWidth;

  @override
  Widget build(BuildContext context) {
    final url = bannerUrl;
    if (url != null && url.isNotEmpty) {
      if (url.startsWith('assets/')) {
        return Image.asset(
          url,
          fit: BoxFit.cover,
          width: double.infinity,
          errorBuilder: (_, __, ___) => _VendorPatternBox(
            vendorId: shop.vendorId,
            businessName: shop.businessName,
          ),
        );
      }
      return CachedNetworkImage(
        imageUrl: url,
        fit: BoxFit.cover,
        width: double.infinity,
        memCacheWidth: tileWidth,
        placeholder: (_, __) => const _BannerShimmer(),
        errorWidget: (_, __, ___) => _VendorPatternBox(
          vendorId: shop.vendorId,
          businessName: shop.businessName,
        ),
      );
    }
    return _VendorPatternBox(
      vendorId: shop.vendorId,
      businessName: shop.businessName,
    );
  }
}

class _BannerShimmer extends StatelessWidget {
  const _BannerShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.creamDark,
      highlightColor: AppColors.cream,
      child: Container(color: AppColors.creamDark),
    );
  }
}

class _AvatarBadge extends StatelessWidget {
  const _AvatarBadge({required this.logoUrl});

  final String logoUrl;

  Widget _image() {
    if (logoUrl.startsWith('assets/')) {
      return Image.asset(
        logoUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const _StorefrontIcon(),
      );
    }
    return CachedNetworkImage(
      imageUrl: logoUrl,
      fit: BoxFit.cover,
      errorWidget: (_, __, ___) => const _StorefrontIcon(),
    );
  }

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
      child: ClipOval(child: _image()),
    );
  }
}

class _StorefrontIcon extends StatelessWidget {
  const _StorefrontIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF0EDE6),
      alignment: Alignment.center,
      child: const Icon(
        Icons.storefront_outlined,
        size: 20,
        color: Color(0xFF8A8A8A),
      ),
    );
  }
}

/// Generated pattern box — shown when no banner URL is available.
/// Background colour and initials are seeded from [vendorId].
class _VendorPatternBox extends StatelessWidget {
  const _VendorPatternBox({
    required this.vendorId,
    required this.businessName,
  });

  final String vendorId;
  final String businessName;

  static const _palette = [
    Color(0xFFB5654B),
    Color(0xFF7A8C6E),
    Color(0xFF4A9B8F),
    Color(0xFFC17F3C),
    Color(0xFF8B7EC8),
    Color(0xFF2C7873),
    Color(0xFF9B4A2A),
    Color(0xFF5B7FA6),
  ];

  String get _initials {
    final parts = businessName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '?';
    if (parts.length == 1) {
      return parts[0].isNotEmpty ? parts[0][0].toUpperCase() : '?';
    }
    final a = parts[0].isNotEmpty ? parts[0][0] : '';
    final b = parts[1].isNotEmpty ? parts[1][0] : '';
    return '$a$b'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final color = _palette[vendorId.hashCode.abs() % _palette.length];
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: color.withValues(alpha: 0.12),
      alignment: Alignment.center,
      child: Text(
        _initials,
        style: AppFonts.cormorantGaramond(
          fontSize: 52,
          fontWeight: FontWeight.w600,
          color: color.withValues(alpha: 0.60),
        ),
      ),
    );
  }
}

/// Small pill showing product count.
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
