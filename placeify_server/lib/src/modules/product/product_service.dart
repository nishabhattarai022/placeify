import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../shared/placeify_exception.dart';
import '../../shared/server_static_paths.dart';
import '../vendor/vendor_service.dart';
import 'catalog_seed.dart';
import 'product_repository.dart';

class ProductService {
  ProductService({
    CatalogRepository? repository,
    VendorService? vendorService,
  })  : _repository = repository ?? CatalogRepository(),
        _vendorService = vendorService ?? VendorService();

  final CatalogRepository _repository;
  final VendorService _vendorService;

  Future<void> _ensureCatalog(Session session) async {
    try {
      await CatalogSeed.ensureDemoCatalog(session);
    } on PlaceifyException catch (error) {
      if (error.code != 'CATALOG_SEED_REQUIRES_USER') rethrow;
    }
  }

  Future<List<Category>> listCategories(Session session) async {
    await _ensureCatalog(session);
    return _repository.listCategories(session);
  }

  Future<ProductPage> searchProducts(
    Session session,
    ProductSearchInput input,
  ) async {
    await _ensureCatalog(session);
    return _repository.searchProducts(session, input);
  }

  Future<Product?> getProduct(Session session, int productId) async {
    await _ensureCatalog(session);
    return _repository.getProduct(session, productId);
  }

  Future<VendorProfileDetail?> getShopProfile(
    Session session,
    UuidValue vendorId,
  ) {
    return _vendorService.getShopProfile(session, vendorId);
  }

  Future<List<ShopListingSummary>> listApprovedShops(
    Session session, {
    String? query,
  }) {
    return _vendorService.listApprovedShops(session, query: query);
  }

  Future<MarketplaceHighlights> getMarketplaceHighlights(Session session) async {
    await _ensureCatalog(session);
    return _repository.marketplaceHighlights(session);
  }

  /// Serves GLB bytes over the API port so phones can load 3D/AR without 8082.
  Future<ByteData?> getModel3dAsset(Session session, int productId) async {
    await _ensureCatalog(session);
    final product = await _repository.getProduct(session, productId);
    final modelPath = product?.model3dUrl?.trim();
    if (product == null || modelPath == null || modelPath.isEmpty) {
      return null;
    }

    final file = ServerStaticPaths.fileFromUrlPath(modelPath);
    if (!file.existsSync()) {
      session.log(
        '3D model file missing for product $productId: $modelPath',
        level: LogLevel.warning,
      );
      return null;
    }

    final bytes = await file.readAsBytes();
    if (bytes.isEmpty) return null;
    return ByteData.sublistView(bytes);
  }
}
