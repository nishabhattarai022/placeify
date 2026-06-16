import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../shared/placeify_exception.dart';
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
}
