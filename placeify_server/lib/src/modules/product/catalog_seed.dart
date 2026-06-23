import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../shared/placeify_exception.dart';

/// Inserts demo categories, vendor, and products when the catalog is empty.
abstract final class CatalogSeed {
  static const defaultCategoryNames = [
    'chairs',
    'sofas',
    'tables',
    'lights',
    'beds',
    'decor',
  ];

  /// Ensures furniture categories exist (needed for vendor product upload).
  static Future<void> ensureCategories(Session session) async {
    final count = await Category.db.count(session);
    if (count > 0) return;

    for (final name in defaultCategoryNames) {
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
      return;
    }

    await _insertAllSeedProducts(session, vendor: vendor, categories: categories);
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

  static const _demoProducts =
      <({String name, String category, double price, String description})>[
    (
      name: 'Astra',
      category: 'chairs',
      price: 56,
      description: 'Modern accent chair',
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
      name: 'Harmony',
      category: 'chairs',
      price: 110,
      description: 'Rattan modern chair',
    ),
    (
      name: 'Nordic Side Table',
      category: 'tables',
      price: 78,
      description: 'Minimal side table',
    ),
    (
      name: 'Round Dining Table',
      category: 'tables',
      price: 450,
      description: 'Round dining table for four to six guests',
    ),
    (
      name: 'Luna Sofa',
      category: 'sofas',
      price: 320,
      description: 'Compact two-seater sofa for modern living rooms',
    ),
    (
      name: 'Floor Lamp Oden',
      category: 'lights',
      price: 45,
      description: 'Scandinavian floor lamp',
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
      name: 'Modular Shelf',
      category: 'decor',
      price: 240,
      description: 'Configurable shelving for living and storage spaces',
    ),
    (
      name: 'Cabinet Unit',
      category: 'decor',
      price: 310,
      description: 'Compact cabinet for storage and display',
    ),
    (
      name: 'Patio Lounge',
      category: 'decor',
      price: 520,
      description: 'Outdoor lounge seating for patios and balconies',
    ),
    (
      name: 'Garden Set',
      category: 'decor',
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

    final owner = await User.db.findFirstRow(
      session,
      orderBy: (row) => row.createdAt,
    );
    if (owner == null) {
      throw PlaceifyException(message: 'Register at least one user before loading the catalog.',
        code: 'CATALOG_SEED_REQUIRES_USER',
      );
    }

    return Vendor.db.insertRow(
      session,
      Vendor(
        userId: owner.id!,
        shopName: 'Placeify Demo Store',
        description: 'Sample furniture for development and testing',
        rating: 4.8,
      ),
    );
  }
}
