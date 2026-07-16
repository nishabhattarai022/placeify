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

  final String? displayTitle;
  final List<String> materials;
  final List<ProductSpec> specs;
  final List<String> careInstructions;
  final String? warranty;

  String get shortDescription {
    if (description.length <= 160) return description;
    return '${description.substring(0, 157).trim()}...';
  }
}

abstract final class ProductDetailContentRepository {
  static ProductDetailContent forProduct(Product product) {
    final gallery = _galleryImages(product);
    final description = product.description.trim().isNotEmpty
        ? product.description.trim()
        : 'No description provided for this product yet.';

    return ProductDetailContent(
      description: description,
      galleryImages: gallery,
      materials: _materialsFrom(product),
      specs: _specsFrom(product),
      careInstructions: _careFrom(product),
      warranty: _warrantyFrom(product),
    );
  }

  static List<String> _galleryImages(Product product) {
    final live = _liveGalleryImages(product);
    if (live.isNotEmpty) return live;

    final trimmed = product.imageUrl.trim();
    if (trimmed.isEmpty) return const [];
    return [trimmed];
  }

  static List<String> _liveGalleryImages(Product product) {
    final images = <String>[];
    for (final url in product.imageUrls) {
      final trimmed = url.trim();
      if (!_isUsableLiveImage(trimmed) || images.contains(trimmed)) continue;
      images.add(trimmed);
    }
    if (images.isEmpty && _isUsableLiveImage(product.imageUrl)) {
      images.add(product.imageUrl.trim());
    }
    return images;
  }

  static bool _isUsableLiveImage(String url) {
    final trimmed = url.trim();
    if (trimmed.isEmpty) return false;
    if (trimmed.startsWith('assets/')) return false;
    return trimmed.startsWith('http://') ||
        trimmed.startsWith('https://') ||
        trimmed.startsWith('/uploads/');
  }

  static List<String> _materialsFrom(Product product) {
    final raw = product.materials?.trim();
    if (raw == null || raw.isEmpty) return const [];

    return raw
        .split(RegExp(r'[\n,;]+'))
        .map((part) => part.trim())
        .where((part) => part.isNotEmpty)
        .toList(growable: false);
  }

  static List<String> _careFrom(Product product) {
    final raw = product.careInstructions?.trim();
    if (raw == null || raw.isEmpty) return const [];

    return raw
        .split(RegExp(r'[\n;]+'))
        .map((part) => part.trim())
        .where((part) => part.isNotEmpty)
        .toList(growable: false);
  }

  static String? _warrantyFrom(Product product) {
    final warranty = product.warranty?.trim();
    if (warranty != null && warranty.isNotEmpty) return warranty;
    return null;
  }

  static List<ProductSpec> _specsFrom(Product product) {
    final specs = <ProductSpec>[];
    final dims = product.dimensions;
    final hasDimensions =
        dims.widthCm > 0 && dims.depthCm > 0 && dims.heightCm > 0;

    if (hasDimensions) {
      String fmt(double v) => v.toStringAsFixed(v % 1 == 0 ? 0 : 1);
      specs.add(
        ProductSpec(
          label: 'Dimensions',
          value:
              'W${fmt(dims.widthCm)} × D${fmt(dims.depthCm)} × H${fmt(dims.heightCm)} cm',
        ),
      );
    }

    final weight = product.weightKg;
    if (weight != null && weight > 0) {
      specs.add(
        ProductSpec(
          label: 'Weight',
          value: '${weight.toStringAsFixed(weight % 1 == 0 ? 0 : 1)} kg',
        ),
      );
    }

    final assembly = product.assemblyNote?.trim();
    if (assembly != null && assembly.isNotEmpty) {
      specs.add(ProductSpec(label: 'Assembly', value: assembly));
    }

    if (product.brand.trim().isNotEmpty) {
      specs.add(ProductSpec(label: 'Sold by', value: product.brand.trim()));
    }

    return specs;
  }
}
