import 'package:serverpod/serverpod.dart';

import '../../../generated/protocol.dart';
import '../vendor_shop_category_codec.dart';

/// Public vendor shop listings and catalog surfaces.
class VendorProfileStore {
  Future<List<ShopListingSummary>> listApprovedShops(
    Session session, {
    String? query,
  }) async {
    final normalizedQuery = query?.trim().toLowerCase();
    final vendors = await Vendor.db.find(
      session,
      include: Vendor.include(user: User.include()),
      orderBy: (row) => row.shopName,
    );

    final activeProducts = await Product.db.find(
      session,
      where: (row) => row.status.equals(ProductStatus.active),
    );
    final productCountByVendor = <UuidValue, int>{};
    for (final product in activeProducts) {
      productCountByVendor.update(
        product.vendorId,
        (count) => count + 1,
        ifAbsent: () => 1,
      );
    }

    final listings = <ShopListingSummary>[];
    for (final vendor in vendors) {
      final user = vendor.user;
      final vendorId = vendor.id;
      if (user == null || vendorId == null) continue;
      if (user.role != UserRole.vendor ||
          user.status != UserAccountStatus.approved ||
          !user.isActive) {
        continue;
      }

      final productCount = productCountByVendor[vendorId] ?? 0;

      final locality = vendor.city?.trim().isNotEmpty == true
          ? vendor.city!.trim()
          : _localityFromAddress(vendor.businessAddress);
      final tags = VendorShopCategoryCodec.decode(vendor.shopCategory);

      final listing = ShopListingSummary(
        vendorId: vendorId,
        businessName: vendor.shopName,
        locality: locality,
        tags: tags,
        logoUrl: vendor.logoUrl,
        bannerUrl: vendor.bannerUrl,
        productCount: productCount,
        averageRating: vendor.rating,
      );

      if (normalizedQuery != null && normalizedQuery.isNotEmpty) {
        final haystack =
            '${listing.businessName} ${listing.locality} ${tags.join(' ')}'
                .toLowerCase();
        if (!haystack.contains(normalizedQuery)) continue;
      }

      listings.add(listing);
    }

    return listings;
  }

  String _localityFromAddress(String? address) {
    if (address == null || address.trim().isEmpty) return '';
    final parts = address.split(',');
    if (parts.length >= 2) {
      return parts[parts.length - 2].trim();
    }
    return parts.first.trim();
  }
}
