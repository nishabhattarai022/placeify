import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../shared/placeify_exception.dart';
import '../vendor/vendor_service.dart';
import 'catalog_seed.dart';
import 'product_repository.dart';
import 'special_offer_reader.dart';
import 'special_offer_seed.dart';

class ProductService {
  ProductService({
    CatalogRepository? repository,
    VendorService? vendorService,
    SpecialOfferReader? specialOffers,
  })  : _repository = repository ?? CatalogRepository(),
        _vendorService = vendorService ?? VendorService(),
        _specialOffers = specialOffers ?? SpecialOfferReader();

  final CatalogRepository _repository;
  final VendorService _vendorService;
  final SpecialOfferReader _specialOffers;

  Future<void> _ensureCatalog(Session session) async {
    try {
      await CatalogSeed.ensureDemoCatalog(session);
      await SpecialOfferSeed.ensureDemoOffers(session);
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

  Future<List<SpecialOfferSummary>> listSpecialOffers(
    Session session, {
    int limit = 12,
  }) async {
    await _ensureCatalog(session);
    return _specialOffers.listActiveOffers(session, limit: limit);
  }
}
