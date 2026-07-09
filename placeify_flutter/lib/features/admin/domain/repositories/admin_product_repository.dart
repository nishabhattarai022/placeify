import 'package:placeify_flutter/features/admin/domain/enums/admin_product_visibility_filter.dart';
import 'package:placeify_flutter/features/admin/domain/models/admin_product_summary.dart';

class AdminProductListQuery {
  const AdminProductListQuery({
    this.searchQuery = '',
    this.visibility = AdminProductVisibilityFilter.all,
    this.categoryName,
    this.vendorId,
    this.reportedOnly = false,
    this.sortNewest = true,
  });

  final String searchQuery;
  final AdminProductVisibilityFilter visibility;
  final String? categoryName;
  final String? vendorId;
  final bool reportedOnly;
  final bool sortNewest;

  @override
  bool operator ==(Object other) {
    return other is AdminProductListQuery &&
        other.searchQuery == searchQuery &&
        other.visibility == visibility &&
        other.categoryName == categoryName &&
        other.vendorId == vendorId &&
        other.reportedOnly == reportedOnly &&
        other.sortNewest == sortNewest;
  }

  @override
  int get hashCode => Object.hash(
        searchQuery,
        visibility,
        categoryName,
        vendorId,
        reportedOnly,
        sortNewest,
      );
}

abstract interface class AdminProductRepository {
  Future<List<AdminProductSummary>> listProducts(AdminProductListQuery query);

  Future<AdminProductDetail?> getProductDetails(int productId);

  Future<void> removeProduct(int productId, {required String reason});

  Future<void> restoreProduct(int productId);
}
