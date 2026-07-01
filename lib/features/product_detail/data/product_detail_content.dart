import 'package:placeify/features/shops/data/vendor_product_mapper.dart';
import 'package:placeify/features/vendor/domain/models/vendor_product.dart';

import '../../home/domain/models/product.dart';

/// A labeled spec row (e.g. "Frame" → "Solid oak").
class ProductSpec {
  const ProductSpec({required this.label, required this.value});

  final String label;
  final String value;
}

/// Copy and gallery images for the product detail screen.
class ProductDetailContent {
  const ProductDetailContent({
    required this.description,
    required this.galleryImages,
    this.extendedDescription,
    this.displayTitle,
    this.materials = const [],
    this.specs = const [],
    this.careInstructions = const [],
    this.warranty,
  });

  final String description;
  final String? extendedDescription;
  final List<String> galleryImages;

  /// Optional marketing title override (e.g. mockup "Crimson Comfort").
  final String? displayTitle;

  /// Bulleted list of materials (e.g. "Solid oak frame", "Linen upholstery").
  final List<String> materials;

  /// Labeled spec rows (Dimensions, Weight, Seat Height, etc.).
  final List<ProductSpec> specs;

  /// Care/maintenance tips shown in expanded view.
  final List<String> careInstructions;

  /// Warranty / origin note shown at the bottom of the expanded view.
  final String? warranty;

  String get shortDescription {
    if (description.length <= 160) return description;
    return '${description.substring(0, 157).trim()}...';
  }
}

abstract final class ProductDetailContentRepository {
  static const _sharedAngles = [
    'assets/images/splash/Tola_Lounge_Chair_Venice_Vegan_Suede_Sage_1_0.jpg',
    'assets/images/splash/pexels-suhailat-35160826.jpg',
    'assets/images/splash/Diane_Sofa_Venice_Vegan_Suede_Sage_1.jpg',
    'assets/images/splash/462222_1_800.jpg',
  ];

  static ProductDetailContent forProduct(Product product) {
    final mapped = _byProductId[product.id];
    final defaultSpecs = _defaultSpecs(product);

    if (mapped != null) {
      return ProductDetailContent(
        displayTitle: mapped.displayTitle,
        description: mapped.description,
        extendedDescription: mapped.extendedDescription,
        galleryImages: mapped.galleryImages.isNotEmpty
            ? mapped.galleryImages
            : _galleryFor(product),
        materials: mapped.materials,
        specs: mapped.specs.isNotEmpty ? mapped.specs : defaultSpecs,
        careInstructions: mapped.careInstructions,
        warranty: mapped.warranty,
      );
    }

    if (VendorProductMapper.isShopProductId(product.id)) {
      return _forShopProduct(product, defaultSpecs);
    }

    return ProductDetailContent(
      description:
          'The ${product.name} combines thoughtful craftsmanship with everyday comfort, '
          'making it a versatile piece for modern living spaces.',
      extendedDescription:
          'Built with quality materials and a balanced silhouette, it pairs easily with '
          'neutral palettes and natural textures throughout your home.',
      galleryImages: _galleryFor(product),
      materials: const [
        'Kiln-dried hardwood frame',
        'High-density foam cushioning',
        'Performance-grade upholstery',
      ],
      specs: defaultSpecs,
      careInstructions: const [
        'Spot clean with a soft, damp cloth.',
        'Avoid direct sunlight to preserve fabric colour.',
        'Vacuum upholstery weekly with a soft brush.',
      ],
      warranty: null,
    );
  }

  static List<ProductSpec> _defaultSpecs(Product product) {
    final dims = product.dimensions;
    String fmt(double v) => v.toStringAsFixed(v % 1 == 0 ? 0 : 1);
    return [
      ProductSpec(
        label: 'Dimensions',
        value:
            'W${fmt(dims.widthCm)} × D${fmt(dims.depthCm)} × H${fmt(dims.heightCm)} cm',
      ),
      const ProductSpec(label: 'Weight', value: '12 kg'),
      const ProductSpec(label: 'Assembly', value: 'Minimal (legs only)'),
      const ProductSpec(label: 'Origin', value: 'Designed in Kathmandu'),
    ];
  }

  static ProductDetailContent _forShopProduct(
    Product product,
    List<ProductSpec> defaultSpecs,
  ) {
    final vendorProduct = _vendorProductForShopProduct(product);
    final description = vendorProduct != null &&
            vendorProduct.description.trim().isNotEmpty
        ? vendorProduct.description
        : 'The ${product.name} combines thoughtful craftsmanship with everyday '
            'comfort, making it a versatile piece for modern living spaces.';
    final galleryImages = _galleryImagesFor(product, vendorProduct);

    return ProductDetailContent(
      description: description,
      extendedDescription:
          'Available from a local Placeify vendor. Built with quality materials '
          'and a balanced silhouette for Nepali homes.',
      galleryImages: galleryImages,
      materials: const [
        'Vendor-listed materials',
        'Quality-checked before dispatch',
      ],
      specs: defaultSpecs,
      careInstructions: const [
        'Follow the care label included with your order.',
        'Contact the vendor for product-specific maintenance advice.',
      ],
      warranty: vendorProduct?.fulfillmentNote,
    );
  }

  static VendorProduct? _vendorProductForShopProduct(Product product) {
    return VendorProductMapper.resolveVendorProduct(product.id);
  }

  static List<String> _galleryImagesFor(
    Product product,
    VendorProduct? vendorProduct,
  ) {
    final vendorImages = vendorProduct?.imageUrls
            .where((url) => url.trim().isNotEmpty)
            .toList() ??
        const <String>[];
    if (vendorImages.isNotEmpty) return vendorImages;

    return _galleryFor(product);
  }

  static List<String> _galleryFor(Product product) {
    final images = <String>[product.imageUrl];
    for (final asset in _sharedAngles) {
      if (asset != product.imageUrl && !images.contains(asset)) {
        images.add(asset);
      }
      if (images.length >= 5) break;
    }
    return images;
  }

  static const Map<String, ProductDetailContent> _byProductId = {
    'p1': ProductDetailContent(
      description:
          'The Astra chair features a sculpted seat and tapered legs, '
          'bringing relaxed elegance to living rooms and reading nooks.',
      extendedDescription:
          'Upholstered for everyday comfort with a compact footprint, Astra works in '
          'pairs around a coffee table or as a standalone accent by the window.',
      galleryImages: [
        'assets/images/splash/Tola_Lounge_Chair_Venice_Vegan_Suede_Sage_1_0.jpg',
        'assets/images/splash/pexels-suhailat-35160826.jpg',
        'assets/images/splash/462222_1_800.jpg',
        'assets/images/splash/Diane_Sofa_Venice_Vegan_Suede_Sage_1.jpg',
        'assets/images/splash/Tola_Lounge_Chair_Venice_Vegan_Suede_Sage_1_0.jpg',
      ],
      materials: [
        'Solid ash hardwood frame',
        'Vegan suede upholstery (Venice, Sage)',
        'High-resilience foam cushioning',
        'Solid oak tapered legs with matte finish',
      ],
      specs: [
        ProductSpec(label: 'Dimensions', value: 'W62 × D58 × H78 cm'),
        ProductSpec(label: 'Seat Height', value: '44 cm'),
        ProductSpec(label: 'Weight', value: '9.4 kg'),
        ProductSpec(label: 'Assembly', value: 'Tool-free legs (5 min)'),
        ProductSpec(label: 'Origin', value: 'Crafted in Pokhara'),
      ],
      careInstructions: [
        'Spot clean upholstery with a damp microfibre cloth.',
        'Buff legs monthly with a soft, dry cloth.',
        'Keep away from radiators and direct sunlight.',
      ],
      warranty: '3-year structural warranty • 30-day returns',
    ),
    'p4': ProductDetailContent(
      displayTitle: 'Verruna Luxe Sofa',
      description:
          'The Crimson Comfort chair boasts a sturdy, hand-carved frame, ensuring durability '
          'while adding a touch of classical charm to your interior.',
      extendedDescription:
          'Its generous seat and balanced proportions make it ideal for lounges, '
          'studios, and open-plan spaces where comfort meets timeless design.',
      galleryImages: [
        'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=800',
        'assets/images/splash/pexels-suhailat-35160826.jpg',
        'assets/images/splash/Tola_Lounge_Chair_Venice_Vegan_Suede_Sage_1_0.jpg',
        'assets/images/splash/462222_1_800.jpg',
        'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=400',
      ],
      materials: [
        'Hand-carved beech wood frame',
        'Italian boucle upholstery',
        'Memory-foam seat with sinuous spring base',
        'Brushed steel internal supports',
      ],
      specs: [
        ProductSpec(label: 'Dimensions', value: 'W68 × D72 × H82 cm'),
        ProductSpec(label: 'Seat Height', value: '46 cm'),
        ProductSpec(label: 'Weight', value: '14.2 kg'),
        ProductSpec(label: 'Max Load', value: '150 kg'),
        ProductSpec(label: 'Assembly', value: 'Fully assembled'),
        ProductSpec(label: 'Origin', value: 'Designed in Kathmandu'),
      ],
      careInstructions: [
        'Vacuum boucle weekly with an upholstery brush.',
        'Blot spills immediately; never rub the fabric.',
        'Rotate seat cushion monthly to even out wear.',
      ],
      warranty: '5-year frame warranty • Free returns within 14 days',
    ),
    'p5': ProductDetailContent(
      description:
          'The Brixon chair blends soft upholstery with a warm wooden base, '
          'creating a welcoming seat for dining and conversation.',
      extendedDescription:
          'Designed for daily use, its supportive back and refined silhouette suit '
          'both minimalist and rustic interior styles.',
      galleryImages: [
        'assets/images/splash/pexels-suhailat-35160826.jpg',
        'assets/images/splash/Tola_Lounge_Chair_Venice_Vegan_Suede_Sage_1_0.jpg',
        'assets/images/splash/Diane_Sofa_Venice_Vegan_Suede_Sage_1.jpg',
        'assets/images/splash/462222_1_800.jpg',
        'assets/images/splash/pexels-suhailat-35160826.jpg',
      ],
      materials: [
        'Solid walnut hardwood base',
        'Recycled wool blend upholstery',
        'Plywood seat shell with natural veneer',
        'Eco-friendly water-based finish',
      ],
      specs: [
        ProductSpec(label: 'Dimensions', value: 'W56 × D60 × H80 cm'),
        ProductSpec(label: 'Seat Height', value: '45 cm'),
        ProductSpec(label: 'Weight', value: '7.8 kg'),
        ProductSpec(label: 'Assembly', value: 'Tool-free legs (3 min)'),
        ProductSpec(label: 'Origin', value: 'Made in Bhaktapur'),
      ],
      careInstructions: [
        'Wipe wooden base with a slightly damp cloth.',
        'Vacuum wool upholstery on a low setting.',
        'Avoid placing directly under air conditioners.',
      ],
      warranty: '2-year limited warranty • Ships in 5–7 business days',
    ),
  };
}
