import 'package:placeify/features/admin/data/config/admin_seed_data.dart';
import 'package:placeify/features/vendor/domain/models/vendor_product.dart';

/// Catalog items for approved vendors that do not yet have vendor inventory.
abstract final class ConsumerShopSeed {
  static const _harmonyApprovedVendorId = AdminSeedData.approvedVendorId;

  static List<VendorProduct> productsFor(String vendorId) {
    if (vendorId == _harmonyApprovedVendorId) {
      return _harmonyHomeProducts;
    }
    return const [];
  }

  static bool hasSeedProducts(String vendorId) =>
      vendorId == _harmonyApprovedVendorId;

  static final List<VendorProduct> _harmonyHomeProducts = [
    VendorProduct(
      id: 'seed-p1',
      vendorId: _harmonyApprovedVendorId,
      name: 'Maya Accent Chair',
      sku: 'HH-SEED-CHR-001',
      price: 11800,
      originalPrice: 13500,
      stock: 10,
      imageUrls: const [
        'assets/images/splash/Tola_Lounge_Chair_Venice_Vegan_Suede_Sage_1_0.jpg',
      ],
      categoryId: 'chairs',
      brand: 'Harmony Home',
      description: 'Compact accent chair with vegan suede upholstery.',
      widthCm: 72,
      depthCm: 65,
      heightCm: 85,
      hasArView: true,
      createdAt: DateTime(2026, 3, 20),
    ),
    VendorProduct(
      id: 'seed-p2',
      vendorId: _harmonyApprovedVendorId,
      name: 'Lazimpat Lounge Chair',
      sku: 'HH-SEED-CHR-002',
      price: 14200,
      stock: 8,
      imageUrls: const [
        'assets/images/splash/pexels-suhailat-35160826.jpg',
      ],
      categoryId: 'chairs',
      brand: 'Harmony Home',
      description: 'Low-profile lounge chair for living rooms and studios.',
      widthCm: 74,
      depthCm: 70,
      heightCm: 86,
      hasArView: true,
      createdAt: DateTime(2026, 4, 5),
    ),
    VendorProduct(
      id: 'seed-p3',
      vendorId: _harmonyApprovedVendorId,
      name: 'Rai Dining Table',
      sku: 'HH-SEED-TBL-001',
      price: 36500,
      stock: 5,
      imageUrls: const [
        'assets/images/splash/3d-room-decor-with-furniture-minimalist-beige-tones.jpg',
      ],
      categoryId: 'tables',
      brand: 'Harmony Home',
      description: 'Solid wood dining table sized for four to six guests.',
      widthCm: 160,
      depthCm: 90,
      heightCm: 75,
      createdAt: DateTime(2026, 4, 12),
    ),
    VendorProduct(
      id: 'seed-p4',
      vendorId: _harmonyApprovedVendorId,
      name: 'Kathmandu Console',
      sku: 'HH-SEED-TBL-002',
      price: 22800,
      stock: 6,
      imageUrls: const [
        'assets/images/splash/pexels-blackcurrant-great-2016663774-35378675.jpg',
      ],
      categoryId: 'tables',
      brand: 'Harmony Home',
      description: 'Slim console table for entryways and hallway styling.',
      widthCm: 120,
      depthCm: 40,
      heightCm: 80,
      createdAt: DateTime(2026, 5, 2),
    ),
  ];
}
