import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';

import '../../generated/protocol.dart';
import 'catalog_seed_image_storage.dart';
import 'catalog_seed_images.dart';
import 'special_offer_seed.dart';

/// Inserts demo categories, vendor, and products when the catalog is empty.
abstract final class CatalogSeed {
  /// Matches Nisha browse chips in [furniture_categories.dart].
  static const defaultCategoryNames = [
    'chairs',
    'sofas',
    'desks',
    'beds',
    'tables',
    'storage',
    'lighting',
    'outdoor',
  ];

  /// Legacy browse rows from older seeds — remapped on every catalog ensure.
  static const legacyCategoryRenames = <String, String>{
    'lights': 'lighting',
    'light': 'lighting',
    'decor': 'storage',
  };

  /// Dedicated vendor account for seeded catalog products — never a consumer login.
  static const catalogVendorEmail = 'catalog-vendor@placeify.app';
  static const catalogVendorName = 'Placeify Catalog';
  static const demoStoreName = 'Placeify Demo Store';

  /// Ensures all Nisha browse categories exist (also on existing databases).
  static Future<void> ensureCategories(Session session) async {
    for (final name in defaultCategoryNames) {
      final existing = await Category.db.findFirstRow(
        session,
        where: (row) => row.name.equals(name),
      );
      if (existing != null) continue;

      await Category.db.insertRow(
        session,
        Category(
          name: name,
          description: name[0].toUpperCase() + name.substring(1),
        ),
      );
    }
  }

  /// Moves products off deprecated category names and deletes empty legacy rows.
  static Future<void> reconcileLegacyCategories(Session session) async {
    await ensureCategories(session);
    final canonical = await _loadCategoriesByName(session);

    for (final entry in legacyCategoryRenames.entries) {
      final legacy = await Category.db.findFirstRow(
        session,
        where: (row) => row.name.equals(entry.key),
      );
      if (legacy == null || legacy.id == null) continue;

      final legacyId = legacy.id!;
      final target = canonical[entry.value];
      if (target?.id == null) continue;

      final legacyProducts = await Product.db.find(
        session,
        where: (row) => row.categoryId.equals(legacyId),
      );
      for (final product in legacyProducts) {
        await Product.db.updateRow(
          session,
          product.copyWith(
            categoryId: target!.id,
            updatedAt: DateTime.now(),
          ),
        );
      }

      final stillUsed = await Product.db.count(
        session,
        where: (row) => row.categoryId.equals(legacyId),
      );
      if (stillUsed == 0) {
        await Category.db.deleteRow(session, legacy);
      }
    }
  }

  static Future<void> ensureDemoCatalog(Session session) async {
    await ensureCategories(session);
    await reconcileLegacyCategories(session);

    final vendor = await _ensureDemoVendor(session);
    final categories = await _loadCategoriesByName(session);

    final count = await Product.db.count(session);
    if (count > 0) {
      await _insertMissingSeedProducts(
        session,
        vendor: vendor,
        categories: categories,
      );
      await _reconcileSeedProducts(session, categories: categories);
      await ensureSeedProductImages(session);
      await SpecialOfferSeed.ensureDemoOffers(session);
      return;
    }

    await _insertAllSeedProducts(
      session,
      vendor: vendor,
      categories: categories,
    );
    await SpecialOfferSeed.ensureDemoOffers(session);
  }

  static Future<Map<String, Category>> _loadCategoriesByName(
    Session session,
  ) async {
    final categories = <String, Category>{};
    for (final name in defaultCategoryNames) {
      final existing = await Category.db.findFirstRow(
        session,
        where: (row) => row.name.equals(name),
      );
      categories[name] = existing ??
          await Category.db.insertRow(
            session,
            Category(
              name: name,
              description: name[0].toUpperCase() + name.substring(1),
            ),
          );
    }
    return categories;
  }

  /// Insert order matches UI ids `p1`…`p18` via [ProductIdCodec] on the client.
  static const _demoProducts =
      <({String name, String category, double price, String description})>[
    (
      name: 'Astra',
      category: 'chairs',
      price: 56,
      description: 'Modern accent chair',
    ),
    (
      name: 'Brixon Chair',
      category: 'sofas',
      price: 85,
      description: 'Compact sofa chair',
    ),
    (
      name: 'Odin 75',
      category: 'chairs',
      price: 94,
      description: 'Scandinavian lounge chair',
    ),
    (
      name: 'Harmony Chair',
      category: 'sofas',
      price: 110,
      description: 'Rattan modern chair',
    ),
    (
      name: 'Brixon',
      category: 'chairs',
      price: 85,
      description: 'Lounge chair',
    ),
    (
      name: 'Brixon Pro',
      category: 'chairs',
      price: 94,
      description: 'Premium lounge chair',
    ),
    (
      name: 'Walnut Desk',
      category: 'desks',
      price: 320,
      description: 'Walnut writing desk',
    ),
    (
      name: 'Studio Desk',
      category: 'desks',
      price: 280,
      description: 'Studio workspace desk',
    ),
    (
      name: 'Cloud Bed',
      category: 'beds',
      price: 890,
      description: 'Upholstered platform bed with cloud-soft cushioning',
    ),
    (
      name: 'Linen Bed Frame',
      category: 'beds',
      price: 720,
      description: 'Minimal linen-upholstered bed frame',
    ),
    (
      name: 'Round Dining Table',
      category: 'tables',
      price: 450,
      description: 'Round dining table for four to six guests',
    ),
    (
      name: 'Oak Console',
      category: 'tables',
      price: 380,
      description: 'Oak console table',
    ),
    (
      name: 'Modular Shelf',
      category: 'storage',
      price: 240,
      description: 'Configurable shelving for living and storage spaces',
    ),
    (
      name: 'Cabinet Unit',
      category: 'storage',
      price: 310,
      description: 'Compact cabinet for storage and display',
    ),
    (
      name: 'Arc Floor Lamp',
      category: 'lighting',
      price: 180,
      description: 'Arc floor lamp',
    ),
    (
      name: 'Pendant Light',
      category: 'lighting',
      price: 120,
      description: 'Pendant ceiling light',
    ),
    (
      name: 'Patio Lounge',
      category: 'outdoor',
      price: 520,
      description: 'Outdoor lounge seating for patios and balconies',
    ),
    (
      name: 'Garden Set',
      category: 'outdoor',
      price: 680,
      description: 'Outdoor table and seating set for gardens',
    ),
  ];

  static List<String> get demoProductNames =>
      _demoProducts.map((seed) => seed.name).toList(growable: false);

  static Future<void> ensureSeedProductImages(Session session) async {
    for (final seed in _demoProducts) {
      final product = await Product.db.findFirstRow(
        session,
        where: (row) => row.name.equals(seed.name),
      );
      if (product == null) continue;

      final imageSet = CatalogSeedImages.forProduct(seed.name);
      final thumbnailUrl = await CatalogSeedImageStorage.resolveUrl(
        session,
        imageSet.thumbnail,
      );
      final viewImageUrls = await CatalogSeedImageStorage.resolveUrls(
        session,
        imageSet.views,
      );

      final missingThumbnail = product.thumbnailUrl == null ||
          product.thumbnailUrl!.trim().isEmpty;
      final missingViews =
          product.viewImageUrls == null || product.viewImageUrls!.isEmpty;

      if (!missingThumbnail &&
          !missingViews &&
          product.thumbnailUrl == thumbnailUrl &&
          _sameUrls(product.viewImageUrls, viewImageUrls)) {
        continue;
      }

      await Product.db.updateRow(
        session,
        product.copyWith(
          thumbnailUrl: thumbnailUrl,
          viewImageUrls: viewImageUrls,
          updatedAt: DateTime.now(),
        ),
      );
    }
  }

  static bool _sameUrls(List<String>? left, List<String> right) {
    if (left == null) return false;
    if (left.length != right.length) return false;
    for (var i = 0; i < left.length; i++) {
      if (left[i] != right[i]) return false;
    }
    return true;
  }

  static Future<void> _insertAllSeedProducts(
    Session session, {
    required Vendor vendor,
    required Map<String, Category> categories,
  }) async {
    for (final seed in _demoProducts) {
      await _insertSeedProduct(
        session,
        seed: seed,
        vendor: vendor,
        categories: categories,
      );
    }
  }

  static Future<void> _insertMissingSeedProducts(
    Session session, {
    required Vendor vendor,
    required Map<String, Category> categories,
  }) async {
    for (final seed in _demoProducts) {
      final existing = await Product.db.findFirstRow(
        session,
        where: (row) => row.name.equals(seed.name),
      );
      if (existing != null) continue;

      await _insertSeedProduct(
        session,
        seed: seed,
        vendor: vendor,
        categories: categories,
      );
    }
  }

  static Future<void> _reconcileSeedProducts(
    Session session, {
    required Map<String, Category> categories,
  }) async {
    for (final seed in _demoProducts) {
      final existing = await Product.db.findFirstRow(
        session,
        where: (row) => row.name.equals(seed.name),
      );
      if (existing == null) continue;

      final category = categories[seed.category];
      if (category?.id == null || existing.categoryId == category!.id) {
        continue;
      }

      await Product.db.updateRow(
        session,
        existing.copyWith(
          categoryId: category.id,
          updatedAt: DateTime.now(),
        ),
      );
    }
  }

  static Future<void> _insertSeedProduct(
    Session session, {
    required ({String name, String category, double price, String description})
        seed,
    required Vendor vendor,
    required Map<String, Category> categories,
  }) async {
    final category = categories[seed.category];
    final imageSet = CatalogSeedImages.forProduct(seed.name);
    final thumbnailUrl = await CatalogSeedImageStorage.resolveUrl(
      session,
      imageSet.thumbnail,
    );
    final viewImageUrls = await CatalogSeedImageStorage.resolveUrls(
      session,
      imageSet.views,
    );

    await Product.db.insertRow(
      session,
      Product(
        vendorId: vendor.id!,
        categoryId: category?.id,
        name: seed.name,
        description: seed.description,
        price: seed.price,
        thumbnailUrl: thumbnailUrl,
        viewImageUrls: viewImageUrls,
        status: ProductStatus.active,
      ),
    );
  }

  static Future<Vendor> _ensureDemoVendor(Session session) async {
    final catalogOwner = await _ensureCatalogVendorUser(session);

    final existing = await Vendor.db.findFirstRow(
      session,
      where: (row) => row.shopName.equals(demoStoreName),
    );

    if (existing != null) {
      if (existing.userId != catalogOwner.id) {
        final previousOwnerId = existing.userId;
        final reassigned = await Vendor.db.updateRow(
          session,
          existing.copyWith(userId: catalogOwner.id!),
        );
        await _restoreConsumerRoleAfterDemoStoreTransfer(
          session,
          previousOwnerId: previousOwnerId,
          catalogVendorUserId: catalogOwner.id!,
        );
        return reassigned;
      }
      return existing;
    }

    return Vendor.db.insertRow(
      session,
      Vendor(
        userId: catalogOwner.id!,
        shopName: demoStoreName,
        description: 'Sample furniture for development and testing',
        rating: 4.8,
      ),
    );
  }

  static Future<User> _ensureCatalogVendorUser(Session session) async {
    final existing = await User.db.findFirstRow(
      session,
      where: (row) => row.email.equals(catalogVendorEmail),
    );
    if (existing != null) {
      if (existing.role != UserRole.vendor ||
          existing.status != UserAccountStatus.approved ||
          !existing.isActive) {
        return User.db.updateRow(
          session,
          existing.copyWith(
            role: UserRole.vendor,
            status: UserAccountStatus.approved,
            isActive: true,
            updatedAt: DateTime.now(),
          ),
        );
      }
      return existing;
    }

    return User.db.insertRow(
      session,
      User(
        authUserId: (await AuthUsers().create(session)).id!,
        name: catalogVendorName,
        email: catalogVendorEmail,
        role: UserRole.vendor,
        status: UserAccountStatus.approved,
        isActive: true,
      ),
    );
  }

  /// Older seeds attached the demo store to the first consumer account.
  static Future<void> _restoreConsumerRoleAfterDemoStoreTransfer(
    Session session, {
    required UuidValue previousOwnerId,
    required UuidValue catalogVendorUserId,
  }) async {
    if (previousOwnerId == catalogVendorUserId) return;

    final owner = await User.db.findById(session, previousOwnerId);
    if (owner == null) return;
    if (owner.email?.trim().toLowerCase() == catalogVendorEmail) return;

    final remainingShops = await Vendor.db.count(
      session,
      where: (row) => row.userId.equals(previousOwnerId),
    );
    if (remainingShops > 0) return;

    if (owner.role != UserRole.vendor) return;

    await User.db.updateRow(
      session,
      owner.copyWith(
        role: UserRole.consumer,
        status: UserAccountStatus.approved,
        isActive: true,
        updatedAt: DateTime.now(),
      ),
    );
  }
}
