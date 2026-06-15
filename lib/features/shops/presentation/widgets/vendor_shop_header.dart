import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:placeify/features/shops/data/shop_listing_details.dart';
import 'package:placeify/features/shops/domain/constants/shop_strings.dart';
import 'package:placeify/features/shops/domain/models/shop_listing.dart';

/// Read-only storefront about section on vendor shop product listings.
class VendorShopHeader extends StatelessWidget {
  const VendorShopHeader({required this.shop, super.key});

  final ShopListing shop;

  @override
  Widget build(BuildContext context) {
    final details = ShopListingDetails.forShop(shop);
    final year = details.establishedYear;
    final rating = shop.averageRating;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.06),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ShopLogo(logoUrl: shop.logoUrl),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shop.businessName,
                      style: GoogleFonts.dmSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      [
                        '${ShopStrings.establishedLabel} $year',
                        shop.locality,
                        if (rating > 0)
                          '${rating.toStringAsFixed(1)} ${ShopStrings.ratingLabel}',
                      ].join(' · '),
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
          if (details.description.isNotEmpty) ...[
            const SizedBox(height: 14),
            Text(
              details.description,
              style: GoogleFonts.dmSans(
                fontSize: 13.5,
                color: Colors.black54,
                height: 1.55,
                letterSpacing: -0.1,
              ),
            ),
          ],
          if (details.highlights.isNotEmpty) ...[
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final highlight in details.highlights)
                  _HighlightChip(label: highlight),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _HighlightChip extends StatelessWidget {
  const _HighlightChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F3EE),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: Text(
        label,
        style: GoogleFonts.dmSans(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: Colors.black54,
        ),
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
          width: 48,
          height: 48,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const _LogoPlaceholder(),
        ),
      );
    }

    if (path.startsWith('/')) {
      return ClipOval(
        child: Image.file(
          File(path),
          width: 48,
          height: 48,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const _LogoPlaceholder(),
        ),
      );
    }

    return ClipOval(
      child: Image.network(
        path,
        width: 48,
        height: 48,
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
      width: 48,
      height: 48,
      decoration: const BoxDecoration(
        color: Color(0xFFF0EDE6),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: const Icon(
        Icons.storefront_outlined,
        size: 22,
        color: Color(0xFF8A8A8A),
      ),
    );
  }
}
