import 'package:placeify_flutter/features/shops/domain/models/shop_listing.dart';
import 'package:placeify_flutter/features/vendor/domain/models/vendor_profile.dart';

/// Consumer-facing storefront copy derived from live shop/profile data.
class ShopListingDetails {
  const ShopListingDetails({
    required this.description,
    required this.establishedYear,
    required this.highlights,
  });

  final String description;
  final int establishedYear;
  final List<String> highlights;

  static ShopListingDetails forShop(ShopListing shop) {
    final locality = shop.locality.trim();
    final tags = shop.tags.where((t) => t.trim().isNotEmpty).take(4).toList();
    return ShopListingDetails(
      establishedYear: DateTime.now().year,
      highlights: tags.isNotEmpty
          ? tags
          : const ['Quality craftsmanship', 'Reliable delivery'],
      description: locality.isEmpty
          ? '${shop.businessName} offers furniture for your home and workspace.'
          : '${shop.businessName} serves customers from $locality with curated '
              'furniture pieces.',
    );
  }

  static ShopListingDetails forProfile(VendorProfile profile) {
    final address = profile.address.trim();
    final tags = profile.tags.where((t) => t.trim().isNotEmpty).take(4).toList();
    return ShopListingDetails(
      establishedYear: profile.createdAt.year,
      highlights: tags.isNotEmpty
          ? tags
          : const ['Quality craftsmanship', 'Reliable delivery'],
      description: address.isEmpty
          ? '${profile.businessName} offers furniture for your home and workspace.'
          : '${profile.businessName} based at $address offers curated furniture '
              'pieces for your home and workspace.',
    );
  }
}
