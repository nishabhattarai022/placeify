import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../shared/placeify_exception.dart';
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

  static Future<void> ensureDemoCatalog(Session session) async {
    await ensureCategories(session);

    final vendor = await _ensureDemoVendor(session);
    final categories = await _loadCategoriesByName(session);

    final count = await Product.db.count(session);
    if (count > 0) {
      await _insertMissingSeedProducts(session, vendor: vendor, categories: categories);
      await SpecialOfferSeed.ensureDemoOffers(session);
      return;
    }

    await _insertAllSeedProducts(session, vendor: vendor, categories: categories);
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

  static Future<void> _insertSeedProduct(
    Session session, {
    required ({String name, String category, double price, String description})
        seed,
    required Vendor vendor,
    required Map<String, Category> categories,
  }) async {
    final category = categories[seed.category];
    await Product.db.insertRow(
      session,
      Product(
        vendorId: vendor.id!,
        categoryId: category?.id,
        name: seed.name,
        description: seed.description,
        price: seed.price,
        status: ProductStatus.active,
      ),
    );
  }

  static Future<Vendor> _ensureDemoVendor(Session session) async {
    final existing = await Vendor.db.findFirstRow(
      session,
      where: (row) => row.shopName.equals('Placeify Demo Store'),
    );
    if (existing != null) return existing;

    final users = await User.db.find(
      session,
      orderBy: (row) => row.createdAt,
    );
    for (final owner in users) {
      final ownerId = owner.id;
      if (ownerId == null) continue;

      final ownsVendor = await Vendor.db.findFirstRow(
        session,
        where: (row) => row.userId.equals(ownerId),
      );
      if (ownsVendor != null) continue;

      return Vendor.db.insertRow(
        session,
        Vendor(
          userId: ownerId,
          shopName: 'Placeify Demo Store',
          description: 'Sample furniture for development and testing',
          rating: 4.8,
        ),
      );
    }

    throw PlaceifyException(
      message: 'Register at least one user without a vendor before loading the catalog.',
      code: 'CATALOG_SEED_REQUIRES_USER',
    );
  }
}
