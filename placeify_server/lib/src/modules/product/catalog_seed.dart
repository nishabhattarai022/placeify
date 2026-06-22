import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../shared/placeify_exception.dart';

typedef _ProductSeed = ({
  String name,
  String category,
  double price,
  String description,
});

/// Inserts demo categories, vendor, and products when the catalog is empty.
abstract final class CatalogSeed {
  static const _categoryNames = [
    'chairs',
    'sofas',
    'tables',
    'lights',
    'beds',
    'decor',
  ];

  static const _starterProducts = <_ProductSeed>[
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
      name: 'Floor Lamp Oden',
      category: 'lights',
      price: 45,
      description: 'Scandinavian floor lamp',
    ),
  ];

  static Future<void> ensureDemoCatalog(Session session) async {
    final count = await Product.db.count(session);
    if (count > 0) return;

    final vendor = await _ensureDemoVendor(session);
    final categories = await _ensureCategories(session);
    await _insertProductsForVendor(session, vendorId: vendor.id!, categories: categories);
  }

  /// Copies the starter catalog to [vendorId] when the shop has no products yet.
  /// Lets approved vendors sell the same demo SKUs consumers see in Browse.
  static Future<int> ensureStarterProductsForVendor(
    Session session,
    UuidValue vendorId,
  ) async {
    final existing = await Product.db.count(
      session,
      where: (row) => row.vendorId.equals(vendorId),
    );
    if (existing > 0) return 0;

    final categories = await _ensureCategories(session);
    await _insertProductsForVendor(
      session,
      vendorId: vendorId,
      categories: categories,
    );
    return _starterProducts.length;
  }

  static Future<Map<String, Category>> _ensureCategories(Session session) async {
    final categories = <String, Category>{};
    for (final name in _categoryNames) {
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

  static Future<void> _insertProductsForVendor(
    Session session, {
    required UuidValue vendorId,
    required Map<String, Category> categories,
  }) async {
    for (final seed in _starterProducts) {
      final category = categories[seed.category];
      await Product.db.insertRow(
        session,
        Product(
          vendorId: vendorId,
          categoryId: category?.id,
          name: seed.name,
          description: seed.description,
          price: seed.price,
          status: ProductStatus.active,
        ),
      );
    }
  }

  static Future<Vendor> _ensureDemoVendor(Session session) async {
    final existing = await Vendor.db.findFirstRow(
      session,
      where: (row) => row.shopName.equals('Placeify Demo Store'),
    );
    if (existing != null) return existing;

    final owner = await _preferredDemoStoreOwner(session);
    if (owner == null) {
      throw PlaceifyException(
        message: 'Register at least one user before loading the catalog.',
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

  /// Prefer the first approved vendor account so demo orders land on a real shop.
  static Future<User?> _preferredDemoStoreOwner(Session session) async {
    final approvedVendorUsers = await User.db.find(
      session,
      where: (row) =>
          row.role.equals(UserRole.vendor) &
          row.status.equals(UserAccountStatus.approved),
      orderBy: (row) => row.createdAt,
      limit: 1,
    );
    if (approvedVendorUsers.isNotEmpty) {
      return approvedVendorUsers.first;
    }

    return User.db.findFirstRow(
      session,
      orderBy: (row) => row.createdAt,
    );
  }
}
