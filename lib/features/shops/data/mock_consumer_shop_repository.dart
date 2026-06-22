import 'package:placeify/features/admin/data/config/admin_seed_data.dart';
import 'package:placeify/features/auth/domain/repositories/auth_repository.dart';
import 'package:placeify/features/home/domain/models/product.dart';
import 'package:placeify/features/shops/data/consumer_shop_seed.dart';
import 'package:placeify/features/shops/data/vendor_product_mapper.dart';
import 'package:placeify/features/vendor/data/vendor_profile_provisioner.dart';
import 'package:placeify/features/shops/data/shop_listing_images.dart';
import 'package:placeify/features/shops/domain/models/shop_listing.dart';
import 'package:placeify/features/shops/domain/repositories/consumer_shop_repository.dart';
import 'package:placeify/features/vendor/data/config/vendor_mock_config.dart';
import 'package:placeify/features/vendor/domain/enums/vendor_status.dart';
import 'package:placeify/features/vendor/domain/models/vendor_product.dart';
import 'package:placeify/features/vendor/domain/models/vendor_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockConsumerShopRepository implements ConsumerShopRepository {
  MockConsumerShopRepository(this._authRepository, this._prefs);

  final AuthRepository _authRepository;
  final SharedPreferences _prefs;

  static final Map<String, Product> _productIndex = {};

  @override
  Future<List<ShopListing>> listShops({String? query}) async {
    await AdminSeedData.ensureSeeded(_prefs);
    ConsumerShopSeed.ensureCatalogProfiles();
    await _ensureApprovedProfiles();

    final vendorIds = await _approvedVendorIds();
    final listings = <ShopListing>[];

    for (final vendorId in vendorIds) {
      final profile = VendorMockConfig.profileFor(vendorId);
      if (profile == null) continue;

      final products = await getShopProducts(vendorId);
      listings.add(_toListing(profile, products));
    }

    listings.sort((a, b) => a.businessName.compareTo(b.businessName));

    final normalizedQuery = query?.trim().toLowerCase();
    if (normalizedQuery == null || normalizedQuery.isEmpty) {
      return listings;
    }

    return listings
        .where(
          (shop) =>
              shop.businessName.toLowerCase().contains(normalizedQuery) ||
              shop.locality.toLowerCase().contains(normalizedQuery) ||
              shop.tags.any(
                (tag) => tag.toLowerCase().contains(normalizedQuery),
              ),
        )
        .toList();
  }

  @override
  Future<ShopListing?> getShop(String vendorId) async {
    await AdminSeedData.ensureSeeded(_prefs);
    ConsumerShopSeed.ensureCatalogProfiles();
    await _ensureApprovedProfiles();

    final profile = VendorMockConfig.profileFor(vendorId);
    if (profile == null) return null;

    final products = await getShopProducts(vendorId);
    return _toListing(profile, products);
  }

  @override
  Future<List<Product>> getShopProducts(String vendorId) async {
    return _vendorProductsFor(vendorId)
        .map(VendorProductMapper.toConsumerProduct)
        .toList();
  }

  /// Synchronous lookup for [productByIdProvider] and cart resolution.
  static Product? productByIdSync(String id) {
    if (!VendorProductMapper.isShopProductId(id)) return null;
    _ensureProductIndex();
    return _productIndex[id];
  }

  static void _ensureProductIndex() {
    if (_productIndex.isNotEmpty) return;

    ConsumerShopSeed.ensureCatalogProfiles();

    for (final vendorId in [
      VendorMockConfig.demoVendorId,
      ...ConsumerShopSeed.catalogVendorIds,
    ]) {
      for (final vendorProduct in _vendorProductsFor(vendorId)) {
        final product = VendorProductMapper.toConsumerProduct(vendorProduct);
        _productIndex[product.id] = product;
      }
    }
  }

  static List<VendorProduct> _vendorProductsFor(String vendorId) {
    if (VendorMockConfig.isKnownVendor(vendorId)) {
      return VendorMockConfig.productsFor(vendorId)
          .where((product) => product.isActive)
          .toList();
    }
    if (ConsumerShopSeed.hasSeedProducts(vendorId)) {
      return ConsumerShopSeed.productsFor(vendorId);
    }
    return const [];
  }

  Future<Set<String>> _approvedVendorIds() async {
    final ids = <String>{
      VendorMockConfig.demoVendorId,
      ...AdminSeedData.catalogShopVendorIds,
    };
    final users = await _authRepository.getAllUsers();
    for (final user in users) {
      if (user.vendorStatus == VendorStatus.approved && user.vendorId != null) {
        ids.add(user.vendorId!);
      }
    }
    return ids;
  }

  Future<void> _ensureApprovedProfiles() async {
    final users = await _authRepository.getAllUsers();
    for (final user in users) {
      if (user.vendorStatus != VendorStatus.approved) continue;
      final vendorId = user.vendorId;
      if (vendorId == null) continue;
      if (VendorMockConfig.profileFor(vendorId) != null) continue;
      VendorProfileProvisioner.ensureFromRegistration(vendorId, _prefs);
    }
  }

  ShopListing _toListing(VendorProfile profile, List<Product> products) {
    return ShopListing(
      vendorId: profile.id,
      businessName: profile.businessName,
      locality: _localityFromAddress(profile.address),
      tags: profile.tags,
      logoUrl: ShopListingImages.resolveLogoUrl(profile, products),
      bannerUrl: ShopListingImages.resolveBannerUrl(profile, products),
      productCount: products.length,
      averageRating: _averageRatingFor(profile.id),
    );
  }

  double _averageRatingFor(String vendorId) {
    final fromStats = VendorMockConfig.statsFor(vendorId).averageRating;
    if (fromStats > 0) return fromStats;
    if (ConsumerShopSeed.hasSeedProducts(vendorId)) {
      return ConsumerShopSeed.averageRatingFor(vendorId);
    }
    return 0;
  }

  String _localityFromAddress(String address) {
    final parts = address.split(',');
    if (parts.length >= 2) {
      return parts[parts.length - 2].trim();
    }
    return parts.first.trim();
  }
}
