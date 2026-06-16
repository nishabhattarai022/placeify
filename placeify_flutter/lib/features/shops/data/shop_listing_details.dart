import 'package:placeify_flutter/features/admin/data/config/admin_seed_data.dart';
import 'package:placeify_flutter/features/shops/domain/models/shop_listing.dart';
import 'package:placeify_flutter/features/vendor/data/config/vendor_mock_config.dart';
import 'package:placeify_flutter/features/vendor/domain/models/vendor_profile.dart';

/// Consumer-facing storefront copy keyed by vendor ID.
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
    return _catalog[shop.vendorId] ?? _fallbackFromListing(shop);
  }

  static ShopListingDetails forProfile(VendorProfile profile) {
    return _catalog[profile.id] ?? _fallback(profile);
  }

  static final Map<String, ShopListingDetails> _catalog = {
    VendorMockConfig.demoVendorId: const ShopListingDetails(
      establishedYear: 2018,
      highlights: [
        'Sal & oak wood',
        'Linen upholstery',
        'Made in Kathmandu',
        'Custom sizing',
      ],
      description:
          'Harmony Home Furnishings began as a Lazimpat workshop building chairs '
          'and tables from locally sourced sal wood. Each frame is kiln-dried and '
          'hand-finished, then paired with performance linen suited to Nepali '
          'humidity. Browse ready-to-ship pieces or request custom dimensions for '
          'compact city apartments.',
    ),
    AdminSeedData.approvedVendorId: const ShopListingDetails(
      establishedYear: 2019,
      highlights: [
        'Solid hardwood',
        'Vegan suede seating',
        'Lazimpat studio',
        'Family-owned',
      ],
      description:
          'Founded by Maya Rai, this Lazimpat studio focuses on modern seating and '
          'dining for urban Nepali homes. We combine sustainably harvested hardwoods '
          'with vegan suede and clean silhouettes — warm craftsmanship without heavy '
          'ornament. Most pieces ship within 7–10 days across Kathmandu Valley.',
    ),
  };

  static ShopListingDetails _fallbackFromListing(ShopListing shop) {
    final tags = shop.tags;
    return ShopListingDetails(
      establishedYear: 2020,
      highlights: tags.isNotEmpty
          ? tags
          : const ['Handcrafted furniture', 'Local workshop'],
      description:
          '${shop.businessName} is a Placeify partner based in ${shop.locality}, '
          'offering thoughtfully made furniture for modern Nepali homes. '
          'Each piece is built with durable materials and practical designs '
          'meant to last beyond seasonal trends.',
    );
  }

  static ShopListingDetails _fallback(VendorProfile profile) {
    final year = profile.createdAt.year;
    final tags = profile.tags;
    final bio = profile.bio.trim();

    return ShopListingDetails(
      establishedYear: year,
      highlights: tags.isNotEmpty
          ? tags
          : const ['Handcrafted furniture', 'Local workshop'],
      description: bio.isNotEmpty
          ? bio
          : 'A Placeify partner workshop offering thoughtfully made furniture for '
              'modern Nepali homes. Established in $year, we focus on durable '
              'materials and practical designs built to last.',
    );
  }
}
