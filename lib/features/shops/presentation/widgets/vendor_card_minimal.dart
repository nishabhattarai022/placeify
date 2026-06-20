import 'package:flutter/material.dart';

import 'package:placeify/core/constants/app_colors.dart';
import 'package:placeify/core/services/haptic_service.dart';
import 'package:placeify/core/theme/app_fonts.dart';
import 'package:placeify/features/shops/domain/models/shop_listing.dart';

const _kCardRadiusMinimal = 22.0;

/// Tier C — shown when [ShopListing.productCount] is 0.
///
/// Quieter outlined card: storefront icon + shop name + "Opening soon" badge.
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
                    // ── Icon ─────────────────────────────────────────
                    _ShopIconBox(vendorId: shop.vendorId),
                    const SizedBox(height: 12),
                    // ── Name ─────────────────────────────────────────
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
                    // ── "Opening soon" badge ──────────────────────────
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

// ── Sub-widgets ────────────────────────────────────────────────────────────────

class _ShopIconBox extends StatelessWidget {
  const _ShopIconBox({required this.vendorId});

  final String vendorId;

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

  @override
  Widget build(BuildContext context) {
    final color = _palette[vendorId.hashCode.abs() % _palette.length];
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: Icon(
        Icons.storefront_outlined,
        size: 22,
        color: color.withValues(alpha: 0.65),
      ),
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
