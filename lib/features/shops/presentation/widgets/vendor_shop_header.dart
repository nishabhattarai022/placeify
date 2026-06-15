import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:placeify/features/shops/domain/models/shop_listing.dart';

/// Compact read-only storefront strip for vendor shop product listings.
class VendorShopHeader extends StatelessWidget {
  const VendorShopHeader({required this.shop, super.key});

  final ShopListing shop;

  @override
  Widget build(BuildContext context) {
    final bio = shop.tags.isNotEmpty ? shop.tags.join(' · ') : shop.locality;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.06),
        ),
      ),
      child: Row(
        children: [
          _ShopLogo(logoUrl: shop.logoUrl),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                const SizedBox(height: 2),
                Text(
                  bio,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    color: Colors.black45,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ShopLogo extends StatelessWidget {
  const _ShopLogo({this.logoUrl});

  final String? logoUrl;

  @override
  Widget build(BuildContext context) {
    final path = logoUrl;
    if (path == null || path.isEmpty) {
      return const _LogoPlaceholder();
    }

    if (path.startsWith('assets/')) {
      return ClipOval(
        child: Image.asset(
          path,
          width: 44,
          height: 44,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const _LogoPlaceholder(),
        ),
      );
    }

    if (path.startsWith('/')) {
      return ClipOval(
        child: Image.file(
          File(path),
          width: 44,
          height: 44,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const _LogoPlaceholder(),
        ),
      );
    }

    return ClipOval(
      child: Image.network(
        path,
        width: 44,
        height: 44,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const _LogoPlaceholder(),
      ),
    );
  }
}

class _LogoPlaceholder extends StatelessWidget {
  const _LogoPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: const BoxDecoration(
        color: Color(0xFFF0EDE6),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: const Icon(
        Icons.storefront_outlined,
        size: 20,
        color: Color(0xFF8A8A8A),
      ),
    );
  }
}
