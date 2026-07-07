import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';

/// Rules for which vendor products appear on consumer dashboards and browse.
abstract final class ProductCatalogPolicy {
  static const defaultRecentLimit = 12;
  static const defaultFeaturedLimit = 8;
  static const defaultOfferLimit = 8;

  static bool isApprovedVendorUser(User? user) {
    if (user == null) return false;
    return user.role == UserRole.vendor &&
        user.status == UserAccountStatus.approved &&
        user.isActive;
  }

  /// Approved vendor shop that consumers can browse (store visibility on).
  static bool isConsumerVisibleShop(Vendor vendor, {User? user}) {
    final resolvedUser = user ?? vendor.user;
    if (!isApprovedVendorUser(resolvedUser)) return false;
    return vendor.isOpen;
  }

  static bool isConsumerVisibleProduct(
    Product product, {
    User? vendorUser,
    Vendor? vendor,
  }) {
    if (product.isDeleted) return false;
    if (product.status != ProductStatus.active) return false;
    if (vendor != null && !vendor.isOpen) return false;
    return isApprovedVendorUser(vendorUser);
  }

  static Future<Set<UuidValue>> approvedVendorIds(Session session) async {
    final vendors = await Vendor.db.find(
      session,
      include: Vendor.include(user: User.include()),
    );

    return {
      for (final vendor in vendors)
        if (vendor.id != null &&
            isConsumerVisibleShop(vendor, user: vendor.user))
          vendor.id!,
    };
  }

  static WhereExpressionBuilder<ProductTable> consumerVisibleWhere({
    required Set<UuidValue> approvedVendorIds,
    int? categoryId,
    UuidValue? vendorId,
    double? minPrice,
    double? maxPrice,
    String? query,
    bool? featuredOnly,
    bool? offersOnly,
  }) {
    return (row) {
      var expression =
          row.isDeleted.equals(false) & row.status.equals(ProductStatus.active);

      if (featuredOnly == true) {
        expression = expression & row.featured.equals(true);
      }
      if (offersOnly == true) {
        expression = expression & row.isOffer.equals(true);
      }
      if (categoryId != null) {
        expression = expression & row.categoryId.equals(categoryId);
      }
      if (vendorId != null) {
        expression = expression & row.vendorId.equals(vendorId);
      }
      if (minPrice != null) {
        expression = expression & (row.price >= minPrice);
      }
      if (maxPrice != null) {
        expression = expression & (row.price <= maxPrice);
      }
      if (query != null && query.isNotEmpty) {
        final pattern = '%$query%';
        expression = expression &
            (row.name.ilike(pattern) | row.description.ilike(pattern));
      }

      expression = expression & _vendorInSet(row, approvedVendorIds);
      return expression;
    };
  }

  static dynamic _vendorInSet(
    ProductTable row,
    Set<UuidValue> approvedVendorIds,
  ) {
    if (approvedVendorIds.isEmpty) {
      return row.id.equals(-1);
    }

    final ids = approvedVendorIds.toList(growable: false);
    var expression = row.vendorId.equals(ids.first);
    for (final vendorId in ids.skip(1)) {
      expression = expression | row.vendorId.equals(vendorId);
    }
    return expression;
  }
}
