import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../shared/placeify_exception.dart';

/// Inserts demo categories, vendor, and products when the catalog is empty.
abstract final class CatalogSeed {
  static Future<void> ensureDemoCatalog(Session session) async {
    final count = await Product.db.count(session);
    if (count > 0) return;

    final vendor = await _ensureDemoVendor(session);

    final categories = <String, Category>{};
    for (final name in [
      'chairs',
      'sofas',
      'tables',
      'lights',
      'beds',
      'decor',
    ]) {
      categories[name] = await Category.db.insertRow(
        session,
        Category(
          name: name,
          description: name[0].toUpperCase() + name.substring(1),
        ),
      );
    }

    final seeds = <
        ({String name, String category, double price, String description})>[
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

    for (final seed in seeds) {
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
