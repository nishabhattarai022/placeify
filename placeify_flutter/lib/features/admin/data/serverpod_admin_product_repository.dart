import 'package:placeify_client/placeify_client.dart' as api;
import 'package:serverpod_client/serverpod_client.dart';

import '../../../core/config/placeify_server_client.dart';
import '../domain/models/admin_product_summary.dart' as domain;
import '../domain/repositories/admin_product_repository.dart';
import 'admin_platform_mapper.dart';
import 'serverpod_admin_api.dart';

class ServerpodAdminProductRepository implements AdminProductRepository {
  const ServerpodAdminProductRepository(this._api);

  final ServerpodAdminApi _api;

  @override
  Future<List<domain.AdminProductSummary>> listProducts(
    AdminProductListQuery query,
  ) async {
    try {
      final trimmedQuery = query.searchQuery.trim();
      final products = await client.admin.listProducts(
        api.AdminProductListInput(
          query: trimmedQuery.isEmpty ? null : trimmedQuery,
          visibility:
              AdminPlatformMapper.toApiProductVisibility(query.visibility),
          vendorId: query.vendorId == null
              ? null
              : UuidValue.fromString(query.vendorId!),
          reportedOnly: query.reportedOnly,
          sortNewest: query.sortNewest,
          pagination: api.PaginationInput(page: 1, pageSize: 100),
        ),
      );
      var summaries = await Future.wait(
        products.map(AdminPlatformMapper.toAdminProductSummary),
      );
      final category = query.categoryName?.trim();
      if (category != null && category.isNotEmpty) {
        summaries = summaries
            .where(
              (product) =>
                  (product.categoryName ?? '').toLowerCase() ==
                  category.toLowerCase(),
            )
            .toList();
      }
      return summaries;
    } catch (error) {
      throw AdminApiException(_mapError(error));
    }
  }

  @override
  Future<domain.AdminProductDetail?> getProductDetails(int productId) async {
    try {
      final product = await client.admin.getProductDetails(productId);
      if (product == null) return null;
      return AdminPlatformMapper.toAdminProductDetail(product);
    } catch (error) {
      throw AdminApiException(_mapError(error));
    }
  }

  @override
  Future<void> removeProduct(int productId, {required String reason}) async {
    await _api.removeProduct(productId, reason);
  }

  @override
  Future<void> restoreProduct(int productId) async {
    await _api.restoreProduct(productId);
  }

  String _mapError(Object error) {
    if (error is AdminApiException) return error.message;
    if (error is api.PlaceifyException) return error.message;
    if (error is ServerpodClientException) return error.message;
    return error.toString();
  }
}
