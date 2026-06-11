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
    this.shopName,
  });

  final String description;
  final String? extendedDescription;
  final List<String> galleryImages;
  final String? displayTitle;
  final List<String> materials;
  final List<ProductSpec> specs;
  final List<String> careInstructions;
  final String? warranty;
  final String? shopName;

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
    if (mapped != null) {
      return ProductDetailContent(
        displayTitle: mapped.displayTitle,
        description: mapped.description,
        extendedDescription: mapped.extendedDescription,
        galleryImages: mapped.galleryImages.isNotEmpty
            ? mapped.galleryImages
            : _galleryFor(product),
        materials: mapped.materials,
        specs: mapped.specs.isNotEmpty ? mapped.specs : _defaultSpecs(product),
        careInstructions: mapped.careInstructions,
        warranty: mapped.warranty,
        shopName: product.shopName.isNotEmpty ? product.shopName : product.brand,
      );
    }

    final vendorMaterials = _lines(product.materials);
    final vendorCare = _lines(product.careInstructions);
    final hasVendorDetails =
        vendorMaterials.isNotEmpty || vendorCare.isNotEmpty;

    if (hasVendorDetails || product.description.trim().isNotEmpty) {
      return ProductDetailContent(
        description: product.description.trim().isNotEmpty
            ? product.description.trim()
            : product.name,
        extendedDescription: product.description.trim(),
        galleryImages: _galleryFor(product),
        materials: vendorMaterials,
        specs: _vendorSpecs(product),
        careInstructions: vendorCare,
        warranty: product.warranty ??
            (product.shopName.isNotEmpty
                ? 'Sold and fulfilled by ${product.shopName}'
                : null),
        shopName:
            product.shopName.isNotEmpty ? product.shopName : product.brand,
      );
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
      specs: _defaultSpecs(product),
      careInstructions: const [
        'Spot clean with a soft, damp cloth.',
        'Avoid direct sunlight to preserve fabric colour.',
        'Vacuum upholstery weekly with a soft brush.',
      ],
      warranty: '2-year limited warranty • Ships in 5–7 business days',
      shopName:
          product.shopName.isNotEmpty ? product.shopName : product.brand,
    );
  }

  static List<String> _lines(String text) {
    if (text.trim().isEmpty) return const [];
    return text
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();
  }

  static List<ProductSpec> _vendorSpecs(Product product) {
    final dims = product.dimensions;
    String fmt(double v) => v.toStringAsFixed(v % 1 == 0 ? 0 : 1);

    final specs = <ProductSpec>[
      ProductSpec(
        label: 'Dimensions',
        value:
            'W${fmt(dims.widthCm)} × D${fmt(dims.depthCm)} × H${fmt(dims.heightCm)} cm',
      ),
    ];

    if (product.weightKg != null && product.weightKg! > 0) {
      specs.add(
        ProductSpec(
          label: 'Weight',
          value: '${fmt(product.weightKg!)} kg',
        ),
      );
    }

    if (product.assemblyNote != null && product.assemblyNote!.trim().isNotEmpty) {
      specs.add(
        ProductSpec(label: 'Assembly', value: product.assemblyNote!.trim()),
      );
    }

    return specs;
  }

  static List<ProductSpec> _defaultSpecs(Product product) {
    final specs = _vendorSpecs(product);
    if (product.shopName.isNotEmpty) {
      specs.add(ProductSpec(label: 'Sold by', value: product.shopName));
    }
    return specs;
  }

  static List<String> _galleryFor(Product product) {
    if (!product.imageUrl.startsWith('assets/')) {
      return [product.imageUrl];
    }

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
      ],
      materials: [
        'Solid oak frame',
        'High-density foam seat',
        'Linen-blend upholstery',
      ],
      specs: [
        ProductSpec(label: 'Dimensions', value: 'W72 × D65 × H85 cm'),
        ProductSpec(label: 'Weight', value: '12 kg'),
        ProductSpec(label: 'Assembly', value: 'Minimal (legs only)'),
      ],
      careInstructions: [
        'Spot clean with a soft, damp cloth.',
        'Avoid direct sunlight to preserve fabric colour.',
      ],
      warranty: '2-year limited warranty • Ships in 5–7 business days',
    ),
  };
}
