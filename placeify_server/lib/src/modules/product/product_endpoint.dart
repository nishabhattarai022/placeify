import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import 'product_service.dart';

/// Product browsing, search, and filtering.
class ProductEndpoint extends Endpoint {
  final _service = ProductService();

  Future<List<Category>> listCategories(Session session) {
    return _service.listCategories(session);
  }

  Future<ProductPage> searchProducts(
    Session session,
    ProductSearchInput input,
  ) {
    return _service.searchProducts(session, input);
  }

  Future<Product?> getProduct(Session session, int productId) {
    return _service.getProduct(session, productId);
  }

  Future<VendorProfileDetail?> getShopProfile(
    Session session,
    UuidValue vendorId,
  ) {
    return _service.getShopProfile(session, vendorId);
  }

  Future<List<ShopListingSummary>> listApprovedShops(
    Session session, {
    String? query,
  }) {
    return _service.listApprovedShops(session, query: query);
  }

  Future<MarketplaceHighlights> getMarketplaceHighlights(Session session) {
    return _service.getMarketplaceHighlights(session);
  }

  /// Backward-compatible list without pagination wrapper.
  Future<List<Product>> listProducts(
    Session session, {
    String? categoryName,
    int? limit,
    int? offset,
  }) async {
    final page = await _service.searchProducts(
      session,
      ProductSearchInput(
        categoryName: categoryName,
        pagination: PaginationInput(
          page: offset == null ? 1 : (offset ~/ (limit ?? 20)) + 1,
          pageSize: limit ?? 20,
        ),
      ),
    );
    return page.items;
  }

  Future<ByteData?> getModel3dAsset(Session session, int productId) {
    return _service.getModel3dAsset(session, productId);
  }
}
