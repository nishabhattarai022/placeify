import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:placeify/features/shops/domain/constants/shop_strings.dart';
import 'package:placeify/features/shops/domain/models/shop_listing.dart';

class ShopListTile extends StatelessWidget {
  const ShopListTile({
    required this.shop,
    required this.onTap,
    super.key,
  });

  final ShopListing shop;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.black.withValues(alpha: 0.06),
          ),
        ),
        child: Row(
          children: [
            const SizedBox(width: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: _ShopThumbnail(shop: shop),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    shop.businessName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.dmSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    '${shop.locality} · ${shop.productCount} ${ShopStrings.productCountLabel}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      color: Colors.black38,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              size: 22,
              color: Colors.black26,
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}

class _ShopThumbnail extends StatelessWidget {
  const _ShopThumbnail({required this.shop});

  final ShopListing shop;

  @override
  Widget build(BuildContext context) {
    final logoUrl = shop.logoUrl;
    if (logoUrl != null && logoUrl.isNotEmpty) {
      final isAsset = logoUrl.startsWith('assets/');
      return isAsset
          ? Image.asset(
              logoUrl,
              width: 48,
              height: 48,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const _PlaceholderThumbnail(),
            )
          : Image.network(
              logoUrl,
              width: 48,
              height: 48,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const _PlaceholderThumbnail(),
            );
    }

    return const _PlaceholderThumbnail();
  }
}

class _PlaceholderThumbnail extends StatelessWidget {
  const _PlaceholderThumbnail();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      color: const Color(0xFFF0EDE6),
      alignment: Alignment.center,
      child: const Icon(
        Icons.storefront_outlined,
        size: 22,
        color: Color(0xFF8A8A8A),
      ),
    );
  }
}
