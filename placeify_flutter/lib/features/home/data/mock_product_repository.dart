import '../domain/models/category.dart';
import '../domain/models/product.dart';
import '../domain/repositories/product_repository.dart';

abstract final class MockProductRepository implements ProductRepository {
  static const List<ProductCategory> categories = [
    ProductCategory(
      id: 'chairs',
      label: 'Chairs',
      svgIconAssetPath: 'assets/icons/ic_chair.svg',
      isActive: true,
    ),
    ProductCategory(
      id: 'sofas',
      label: 'Sofas',
      svgIconAssetPath: 'assets/icons/ic_sofa.svg',
    ),
    ProductCategory(
      id: 'tables',
      label: 'Tables',
      svgIconAssetPath: 'assets/icons/ic_table.svg',
    ),
    ProductCategory(
      id: 'lights',
      label: 'Lights',
      svgIconAssetPath: 'assets/icons/ic_lamp.svg',
    ),
    ProductCategory(
      id: 'beds',
      label: 'Beds',
      svgIconAssetPath: 'assets/icons/ic_bed.svg',
    ),
    ProductCategory(
      id: 'decor',
      label: 'Decor',
      svgIconAssetPath: 'assets/icons/ic_plant.svg',
    ),
  ];

  static final List<Product> products = [
    Product(
      id: 'p1',
      name: 'Astra',
      brand: 'Furnix',
      sku: 'LP01049',
      price: 56,
      originalPrice: 75,
      imageUrl:
          'assets/images/splash/Tola_Lounge_Chair_Venice_Vegan_Suede_Sage_1_0.jpg',
      svgIconPath: 'assets/icons/ic_chair.svg',
      hasArView: true,
      categoryId: 'chairs',
      dimensions: const ProductDimensions(
        widthCm: 72,
        depthCm: 65,
        heightCm: 85,
      ),
    ),
    Product(
      id: 'p5',
      name: 'Brixon',
      brand: 'Zenspace',
      sku: 'MS03695',
      price: 85,
      imageUrl: 'assets/images/splash/pexels-suhailat-35160826.jpg',
      svgIconPath: 'assets/icons/ic_chair.svg',
      hasArView: true,
      categoryId: 'chairs',
      dimensions: const ProductDimensions(
        widthCm: 70,
        depthCm: 68,
        heightCm: 88,
      ),
    ),
    Product(
      id: 'p6',
      name: 'Brixon',
      brand: 'Zenspace',
      sku: 'MS03712',
      price: 94,
      imageUrl:
          'assets/images/splash/Diane_Sofa_Venice_Vegan_Suede_Sage_1.jpg',
      svgIconPath: 'assets/icons/ic_chair.svg',
      hasArView: false,
      categoryId: 'chairs',
      dimensions: const ProductDimensions(
        widthCm: 74,
        depthCm: 70,
        heightCm: 86,
      ),
    ),
    Product(
      id: 'p2',
      name: 'Brixon Chair',
      brand: 'Zenspace',
      sku: 'MS03695',
      price: 85,
      imageUrl:
          'https://images.unsplash.com/photo-1506439773649-6e0eb8cfb237?w=400',
      svgIconPath: 'assets/icons/ic_sofa.svg',
      hasArView: true,
      categoryId: 'sofas',
      dimensions: const ProductDimensions(
        widthCm: 85,
        depthCm: 78,
        heightCm: 90,
      ),
    ),
    Product(
      id: 'p3',
      name: 'Odin 75',
      brand: 'Nordic Co',
      sku: 'SL25901',
      price: 94,
      imageUrl: 'assets/images/splash/462222_1_800.jpg',
      svgIconPath: 'assets/icons/ic_chair.svg',
      hasArView: true,
      categoryId: 'chairs',
      dimensions: const ProductDimensions(
        widthCm: 68,
        depthCm: 60,
        heightCm: 82,
      ),
    ),
    Product(
      id: 'p4',
      name: 'Harmony Chair',
      brand: 'Harmony',
      sku: 'HC80700',
      price: 110,
      originalPrice: 142,
      imageUrl:
          'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=400',
      svgIconPath: 'assets/icons/ic_sofa.svg',
      hasArView: true,
      categoryId: 'sofas',
      dimensions: const ProductDimensions(
        widthCm: 80,
        depthCm: 70,
        heightCm: 60,
      ),
    ),
    Product(
      id: 'p7',
      name: 'Walnut Desk',
      brand: 'Nordic Co',
      sku: 'WD12001',
      price: 320,
      imageUrl:
          'assets/images/splash/pexels-blackcurrant-great-2016663774-35378675.jpg',
      svgIconPath: 'assets/icons/ic_table.svg',
      hasArView: false,
      categoryId: 'desks',
      dimensions: const ProductDimensions(
        widthCm: 120,
        depthCm: 60,
        heightCm: 75,
      ),
    ),
    Product(
      id: 'p8',
      name: 'Studio Desk',
      brand: 'Forma',
      sku: 'SD22002',
      price: 280,
      imageUrl: 'assets/images/splash/462222_1_800.jpg',
      svgIconPath: 'assets/icons/ic_table.svg',
      hasArView: true,
      categoryId: 'desks',
      dimensions: const ProductDimensions(
        widthCm: 140,
        depthCm: 65,
        heightCm: 76,
      ),
    ),
    Product(
      id: 'p9',
      name: 'Cloud Bed',
      brand: 'Restwell',
      sku: 'CB33001',
      price: 890,
      imageUrl:
          'assets/images/splash/3d-room-decor-with-furniture-minimalist-beige-tones.jpg',
      svgIconPath: 'assets/icons/ic_bed.svg',
      hasArView: false,
      categoryId: 'beds',
      dimensions: const ProductDimensions(
        widthCm: 160,
        depthCm: 200,
        heightCm: 45,
      ),
    ),
    Product(
      id: 'p10',
      name: 'Linen Bed Frame',
      brand: 'Restwell',
      sku: 'LB33002',
      price: 720,
      imageUrl: 'assets/images/splash/462222_1_800.jpg',
      svgIconPath: 'assets/icons/ic_bed.svg',
      hasArView: true,
      categoryId: 'beds',
      dimensions: const ProductDimensions(
        widthCm: 150,
        depthCm: 200,
        heightCm: 42,
      ),
    ),
    Product(
      id: 'p11',
      name: 'Round Dining Table',
      brand: 'Gather',
      sku: 'RT44001',
      price: 450,
      imageUrl:
          'assets/images/splash/3d-room-decor-with-furniture-minimalist-beige-tones.jpg',
      svgIconPath: 'assets/icons/ic_table.svg',
      hasArView: true,
      categoryId: 'tables',
      dimensions: const ProductDimensions(
        widthCm: 110,
        depthCm: 110,
        heightCm: 75,
      ),
    ),
    Product(
      id: 'p12',
      name: 'Oak Console',
      brand: 'Gather',
      sku: 'OC44002',
      price: 380,
      imageUrl: 'assets/images/home/explore_hero.jpg',
      svgIconPath: 'assets/icons/ic_table.svg',
      hasArView: false,
      categoryId: 'tables',
      dimensions: const ProductDimensions(
        widthCm: 130,
        depthCm: 40,
        heightCm: 80,
      ),
    ),
    Product(
      id: 'p13',
      name: 'Modular Shelf',
      brand: 'Stow',
      sku: 'MS55001',
      price: 240,
      imageUrl: 'assets/images/splash/pexels-suhailat-35160826.jpg',
      svgIconPath: 'assets/icons/ic_plant.svg',
      hasArView: false,
      categoryId: 'storage',
      dimensions: const ProductDimensions(
        widthCm: 90,
        depthCm: 35,
        heightCm: 180,
      ),
    ),
    Product(
      id: 'p14',
      name: 'Cabinet Unit',
      brand: 'Stow',
      sku: 'CU55002',
      price: 310,
      imageUrl:
          'assets/images/splash/Tola_Lounge_Chair_Venice_Vegan_Suede_Sage_1_0.jpg',
      svgIconPath: 'assets/icons/ic_plant.svg',
      hasArView: true,
      categoryId: 'storage',
      dimensions: const ProductDimensions(
        widthCm: 100,
        depthCm: 45,
        heightCm: 160,
      ),
    ),
    Product(
      id: 'p15',
      name: 'Arc Floor Lamp',
      brand: 'Lumen',
      sku: 'FL66001',
      price: 180,
      imageUrl: 'assets/images/home/explore_hero.jpg',
      svgIconPath: 'assets/icons/ic_lamp.svg',
      hasArView: false,
      categoryId: 'lighting',
      dimensions: const ProductDimensions(
        widthCm: 40,
        depthCm: 40,
        heightCm: 165,
      ),
    ),
    Product(
      id: 'p16',
      name: 'Pendant Light',
      brand: 'Lumen',
      sku: 'PL66002',
      price: 120,
      imageUrl:
          'assets/images/splash/Diane_Sofa_Venice_Vegan_Suede_Sage_1.jpg',
      svgIconPath: 'assets/icons/ic_lamp.svg',
      hasArView: false,
      categoryId: 'lighting',
      dimensions: const ProductDimensions(
        widthCm: 35,
        depthCm: 35,
        heightCm: 45,
      ),
    ),
    Product(
      id: 'p17',
      name: 'Patio Lounge',
      brand: 'OpenAir',
      sku: 'PL77001',
      price: 520,
      imageUrl: 'assets/images/splash/pexels-suhailat-35160826.jpg',
      svgIconPath: 'assets/icons/ic_chair.svg',
      hasArView: true,
      categoryId: 'outdoor',
      dimensions: const ProductDimensions(
        widthCm: 75,
        depthCm: 80,
        heightCm: 85,
      ),
    ),
    Product(
      id: 'p18',
      name: 'Garden Set',
      brand: 'OpenAir',
      sku: 'GS77002',
      price: 680,
      imageUrl:
          'assets/images/splash/3d-room-decor-with-furniture-minimalist-beige-tones.jpg',
      svgIconPath: 'assets/icons/ic_table.svg',
      hasArView: false,
      categoryId: 'outdoor',
      dimensions: const ProductDimensions(
        widthCm: 120,
        depthCm: 120,
        heightCm: 75,
      ),
    ),
  ];

  @override
  List<ProductCategory> getCategories() => categories;

  @override
  List<Product> getProducts() => products;

  @override
  Product? getProductById(String id) {
    try {
      return products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Exposed for tests: images assigned to mock products must be unique.
  static List<String> mockProductImageUrls() =>
      products.map((p) => p.imageUrl).toList(growable: false);
}
