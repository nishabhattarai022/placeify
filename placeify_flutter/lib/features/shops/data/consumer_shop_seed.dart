import 'package:placeify_flutter/features/admin/data/config/admin_seed_data.dart';
import 'package:placeify_flutter/features/vendor/data/config/vendor_mock_config.dart';
import 'package:placeify_flutter/features/vendor/domain/models/vendor_profile.dart';
import 'package:placeify_flutter/features/vendor/domain/models/vendor_product.dart';

/// Catalog items and profiles for approved vendors that do not use demo inventory.
abstract final class ConsumerShopSeed {
  static const catalogVendorIds = [
    AdminSeedData.approvedVendorId,
    ...AdminSeedData.catalogShopVendorIds,
  ];

  static List<VendorProduct> productsFor(String vendorId) {
    return _productsByVendor[vendorId] ?? const [];
  }

  static bool hasSeedProducts(String vendorId) =>
      _productsByVendor.containsKey(vendorId);

  static double averageRatingFor(String vendorId) =>
      _ratings[vendorId] ?? 4.5;

  /// Ensures storefront profiles exist even when admin seed already ran.
  static void ensureCatalogProfiles() {
    for (final profile in _catalogProfiles) {
      if (VendorMockConfig.profileFor(profile.id) != null) continue;
      VendorMockConfig.registerApprovedProfile(profile);
    }
  }

  static final Map<String, double> _ratings = {
    AdminSeedData.approvedVendorId: 4.72,
    AdminSeedData.shopVendorNestId: 4.58,
    AdminSeedData.shopVendorHimalayaId: 4.81,
    AdminSeedData.shopVendorCraftsId: 4.64,
    AdminSeedData.shopVendorUrbanId: 4.69,
  };

  static final List<VendorProfile> _catalogProfiles = [
    VendorProfile(
      id: AdminSeedData.shopVendorNestId,
      businessName: 'Nepal Nest Furniture',
      email: 'sunita.nest@placeify.demo',
      phone: '+977 9822222222',
      address: 'Lakeside Road 4, Pokhara, Gandaki 33700',
      tags: const ['Furniture', 'Beds'],
      bio: 'Locally sourced wooden furniture from Pokhara.',
      createdAt: DateTime(2026, 4, 2),
    ),
    VendorProfile(
      id: AdminSeedData.shopVendorHimalayaId,
      businessName: 'Himalayan Home Decor',
      email: 'anil.himalaya@placeify.demo',
      phone: '+977 9833333333',
      address: 'Durbar Marg 8, Kathmandu, Bagmati 44600',
      tags: const ['Decor', 'Lighting'],
      bio: 'Modern decor inspired by Himalayan aesthetics.',
      createdAt: DateTime(2026, 4, 10),
    ),
    VendorProfile(
      id: AdminSeedData.shopVendorCraftsId,
      businessName: 'Kathmandu Crafts Co.',
      email: 'ramesh.crafts@placeify.demo',
      phone: '+977 9811111111',
      address: 'Thamel Marg 12, Kathmandu, Bagmati 44600',
      tags: const ['Handicrafts', 'Decor'],
      bio: 'Traditional Nepali crafts and artisan home accents.',
      createdAt: DateTime(2026, 4, 18),
    ),
    VendorProfile(
      id: AdminSeedData.shopVendorUrbanId,
      businessName: 'Urban Loft Studio',
      email: 'priya.urban@placeify.demo',
      phone: '+977 9866666666',
      address: 'Jawalakhel Chowk 3, Lalitpur, Bagmati 44700',
      tags: const ['Seating', 'Desks'],
      bio: 'Compact modern furniture for city apartments.',
      createdAt: DateTime(2026, 5, 5),
    ),
  ];

  static final Map<String, List<VendorProduct>> _productsByVendor = {
    AdminSeedData.approvedVendorId: _harmonyHomeProducts,
    AdminSeedData.shopVendorNestId: _nestProducts,
    AdminSeedData.shopVendorHimalayaId: _himalayaProducts,
    AdminSeedData.shopVendorCraftsId: _craftsProducts,
    AdminSeedData.shopVendorUrbanId: _urbanProducts,
  };

  static final List<VendorProduct> _harmonyHomeProducts = [
    VendorProduct(
      id: 'seed-p1',
      vendorId: AdminSeedData.approvedVendorId,
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
      vendorId: AdminSeedData.approvedVendorId,
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
      vendorId: AdminSeedData.approvedVendorId,
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
      vendorId: AdminSeedData.approvedVendorId,
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

  static final List<VendorProduct> _nestProducts = [
    VendorProduct(
      id: 'nest-p1',
      vendorId: AdminSeedData.shopVendorNestId,
      name: 'Phewa Platform Bed',
      sku: 'NN-BED-001',
      price: 42500,
      stock: 6,
      imageUrls: const [
        'assets/images/splash/3d-room-decor-with-furniture-minimalist-beige-tones.jpg',
      ],
      categoryId: 'beds',
      brand: 'Nepal Nest',
      description: 'Low platform bed in warm oak with slatted headboard.',
      widthCm: 160,
      depthCm: 200,
      heightCm: 95,
      createdAt: DateTime(2026, 4, 8),
    ),
    VendorProduct(
      id: 'nest-p2',
      vendorId: AdminSeedData.shopVendorNestId,
      name: 'Lakeside Nightstand',
      sku: 'NN-TBL-001',
      price: 8900,
      stock: 14,
      imageUrls: const [
        'assets/images/splash/pexels-blackcurrant-great-2016663774-35378675.jpg',
      ],
      categoryId: 'tables',
      brand: 'Nepal Nest',
      description: 'Single-drawer nightstand with brass pull hardware.',
      widthCm: 45,
      depthCm: 40,
      heightCm: 52,
      createdAt: DateTime(2026, 4, 15),
    ),
    VendorProduct(
      id: 'nest-p3',
      vendorId: AdminSeedData.shopVendorNestId,
      name: 'Gandaki Bench',
      sku: 'NN-CHR-001',
      price: 15600,
      stock: 9,
      imageUrls: const [
        'assets/images/splash/462222_1_800.jpg',
      ],
      categoryId: 'chairs',
      brand: 'Nepal Nest',
      description: 'Solid wood dining bench with a gently curved seat.',
      widthCm: 140,
      depthCm: 38,
      heightCm: 45,
      createdAt: DateTime(2026, 4, 22),
    ),
    VendorProduct(
      id: 'nest-p4',
      vendorId: AdminSeedData.shopVendorNestId,
      name: 'Annapurna Wardrobe',
      sku: 'NN-DEC-001',
      price: 58200,
      originalPrice: 64000,
      stock: 3,
      imageUrls: const [
        'assets/images/splash/Diane_Sofa_Venice_Vegan_Suede_Sage_1.jpg',
      ],
      categoryId: 'decor',
      brand: 'Nepal Nest',
      description: 'Two-door wardrobe with interior shelving and hanging rail.',
      widthCm: 120,
      depthCm: 58,
      heightCm: 200,
      createdAt: DateTime(2026, 5, 1),
    ),
  ];

  static final List<VendorProduct> _himalayaProducts = [
    VendorProduct(
      id: 'him-p1',
      vendorId: AdminSeedData.shopVendorHimalayaId,
      name: 'Everest Table Lamp',
      sku: 'HH-DEC-001',
      price: 4200,
      stock: 22,
      imageUrls: const [
        'assets/images/splash/462222_1_800.jpg',
      ],
      categoryId: 'decor',
      brand: 'Himalayan Home',
      description: 'Ceramic base lamp with linen shade in warm ivory.',
      widthCm: 28,
      depthCm: 28,
      heightCm: 52,
      createdAt: DateTime(2026, 4, 12),
    ),
    VendorProduct(
      id: 'him-p2',
      vendorId: AdminSeedData.shopVendorHimalayaId,
      name: 'Prayer Flag Wall Set',
      sku: 'HH-DEC-002',
      price: 2800,
      stock: 30,
      imageUrls: const [
        'assets/images/splash/Tola_Lounge_Chair_Venice_Vegan_Suede_Sage_1_0.jpg',
      ],
      categoryId: 'decor',
      brand: 'Himalayan Home',
      description: 'Hand-printed cotton wall hangings in five traditional colors.',
      widthCm: 20,
      depthCm: 2,
      heightCm: 150,
      createdAt: DateTime(2026, 4, 18),
    ),
    VendorProduct(
      id: 'him-p3',
      vendorId: AdminSeedData.shopVendorHimalayaId,
      name: 'Singing Bowl Stand',
      sku: 'HH-DEC-003',
      price: 3600,
      stock: 16,
      imageUrls: const [
        'assets/images/splash/pexels-suhailat-35160826.jpg',
      ],
      categoryId: 'decor',
      brand: 'Himalayan Home',
      description: 'Turned walnut stand sized for meditation bowls.',
      widthCm: 18,
      depthCm: 18,
      heightCm: 12,
      createdAt: DateTime(2026, 4, 25),
    ),
    VendorProduct(
      id: 'him-p4',
      vendorId: AdminSeedData.shopVendorHimalayaId,
      name: 'Valley Floor Mirror',
      sku: 'HH-DEC-004',
      price: 12400,
      stock: 7,
      imageUrls: const [
        'assets/images/splash/pexels-blackcurrant-great-2016663774-35378675.jpg',
      ],
      categoryId: 'decor',
      brand: 'Himalayan Home',
      description: 'Arched floor mirror with a slim teak frame.',
      widthCm: 60,
      depthCm: 4,
      heightCm: 170,
      createdAt: DateTime(2026, 5, 3),
    ),
  ];

  static final List<VendorProduct> _craftsProducts = [
    VendorProduct(
      id: 'craft-p1',
      vendorId: AdminSeedData.shopVendorCraftsId,
      name: 'Thangka Wall Panel',
      sku: 'KC-DEC-001',
      price: 9800,
      stock: 11,
      imageUrls: const [
        'assets/images/splash/Tola_Lounge_Chair_Venice_Vegan_Suede_Sage_1_0.jpg',
      ],
      categoryId: 'decor',
      brand: 'Kathmandu Crafts',
      description: 'Hand-painted canvas panel mounted on a cedar frame.',
      widthCm: 50,
      depthCm: 3,
      heightCm: 70,
      createdAt: DateTime(2026, 4, 20),
    ),
    VendorProduct(
      id: 'craft-p2',
      vendorId: AdminSeedData.shopVendorCraftsId,
      name: 'Brass Lotus Bowl',
      sku: 'KC-DEC-002',
      price: 3200,
      stock: 25,
      imageUrls: const [
        'assets/images/splash/462222_1_800.jpg',
      ],
      categoryId: 'decor',
      brand: 'Kathmandu Crafts',
      description: 'Hammered brass bowl for fruit, keys, or centerpieces.',
      widthCm: 24,
      depthCm: 24,
      heightCm: 8,
      createdAt: DateTime(2026, 4, 24),
    ),
    VendorProduct(
      id: 'craft-p3',
      vendorId: AdminSeedData.shopVendorCraftsId,
      name: 'Lokta Paper Tray Set',
      sku: 'KC-DEC-003',
      price: 2400,
      stock: 18,
      imageUrls: const [
        'assets/images/splash/pexels-suhailat-35160826.jpg',
      ],
      categoryId: 'decor',
      brand: 'Kathmandu Crafts',
      description: 'Nested trays handmade from recycled lokta paper.',
      widthCm: 30,
      depthCm: 30,
      heightCm: 6,
      createdAt: DateTime(2026, 5, 1),
    ),
    VendorProduct(
      id: 'craft-p4',
      vendorId: AdminSeedData.shopVendorCraftsId,
      name: 'Carved Window Frame',
      sku: 'KC-DEC-004',
      price: 18600,
      originalPrice: 21000,
      stock: 4,
      imageUrls: const [
        'assets/images/splash/3d-room-decor-with-furniture-minimalist-beige-tones.jpg',
      ],
      categoryId: 'decor',
      brand: 'Kathmandu Crafts',
      description: 'Replica Newari window frame for wall display.',
      widthCm: 80,
      depthCm: 5,
      heightCm: 80,
      createdAt: DateTime(2026, 5, 8),
    ),
  ];

  static final List<VendorProduct> _urbanProducts = [
    VendorProduct(
      id: 'urban-p1',
      vendorId: AdminSeedData.shopVendorUrbanId,
      name: 'Jawalakhel Desk',
      sku: 'UL-TBL-001',
      price: 19800,
      stock: 12,
      imageUrls: const [
        'assets/images/splash/pexels-blackcurrant-great-2016663774-35378675.jpg',
      ],
      categoryId: 'tables',
      brand: 'Urban Loft',
      description: 'Slim writing desk with cable pass-through and oak top.',
      widthCm: 110,
      depthCm: 55,
      heightCm: 75,
      hasArView: true,
      createdAt: DateTime(2026, 5, 6),
    ),
    VendorProduct(
      id: 'urban-p2',
      vendorId: AdminSeedData.shopVendorUrbanId,
      name: 'Patan Armless Sofa',
      sku: 'UL-SOF-001',
      price: 32400,
      stock: 5,
      imageUrls: const [
        'assets/images/splash/Diane_Sofa_Venice_Vegan_Suede_Sage_1.jpg',
      ],
      categoryId: 'sofas',
      brand: 'Urban Loft',
      description: 'Two-seater sofa with clean lines and removable cushions.',
      widthCm: 160,
      depthCm: 85,
      heightCm: 78,
      hasArView: true,
      createdAt: DateTime(2026, 5, 10),
    ),
    VendorProduct(
      id: 'urban-p3',
      vendorId: AdminSeedData.shopVendorUrbanId,
      name: 'Loft Bar Stool',
      sku: 'UL-CHR-001',
      price: 7600,
      stock: 20,
      imageUrls: const [
        'assets/images/splash/Tola_Lounge_Chair_Venice_Vegan_Suede_Sage_1_0.jpg',
      ],
      categoryId: 'chairs',
      brand: 'Urban Loft',
      description: 'Counter-height stool with powder-coated steel legs.',
      widthCm: 42,
      depthCm: 42,
      heightCm: 65,
      createdAt: DateTime(2026, 5, 14),
    ),
    VendorProduct(
      id: 'urban-p4',
      vendorId: AdminSeedData.shopVendorUrbanId,
      name: 'City Shelf Unit',
      sku: 'UL-DEC-001',
      price: 14200,
      stock: 8,
      imageUrls: const [
        'assets/images/splash/462222_1_800.jpg',
      ],
      categoryId: 'decor',
      brand: 'Urban Loft',
      description: 'Five-tier open shelving for books and display objects.',
      widthCm: 80,
      depthCm: 30,
      heightCm: 180,
      createdAt: DateTime(2026, 5, 18),
    ),
  ];
}
