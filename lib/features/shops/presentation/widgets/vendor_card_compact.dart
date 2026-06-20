import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:placeify/core/constants/app_colors.dart';
import 'package:placeify/core/services/haptic_service.dart';
import 'package:placeify/core/theme/app_fonts.dart';
import 'package:placeify/features/shops/data/shop_listing_details.dart';
import 'package:placeify/features/shops/domain/constants/shop_strings.dart';
import 'package:placeify/features/shops/domain/models/shop_listing.dart';

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
                    // ── Logo + name row ───────────────────────────────
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
                    // ── Count pill ────────────────────────────────────
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

// ── Sub-widgets ────────────────────────────────────────────────────────────────

class _LogoSquare extends StatelessWidget {
  const _LogoSquare({required this.shop});

  final ShopListing shop;

  @override
  Widget build(BuildContext context) {
    final logoUrl = shop.logoUrl;
    const size = 56.0;

    Widget content;
    if (logoUrl != null && logoUrl.isNotEmpty) {
      if (logoUrl.startsWith('assets/')) {
        content = Image.asset(
          logoUrl,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _LogoFallback(shop: shop),
        );
      } else {
        content = CachedNetworkImage(
          imageUrl: logoUrl,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorWidget: (_, __, ___) => _LogoFallback(shop: shop),
        );
      }
    } else {
      content = _LogoFallback(shop: shop);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(width: size, height: size, child: content),
    );
  }
}

class _LogoFallback extends StatelessWidget {
  const _LogoFallback({required this.shop});

  final ShopListing shop;

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

  String get _initial {
    final name = shop.businessName.trim();
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  @override
  Widget build(BuildContext context) {
    final color = _palette[shop.vendorId.hashCode.abs() % _palette.length];
    return Container(
      color: color.withValues(alpha: 0.14),
      alignment: Alignment.center,
      child: Text(
        _initial,
        style: AppFonts.cormorantGaramond(
          fontSize: 26,
          fontWeight: FontWeight.w600,
          color: color.withValues(alpha: 0.70),
        ),
      ),
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
