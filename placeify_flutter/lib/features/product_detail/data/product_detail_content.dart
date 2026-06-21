import 'package:placeify_flutter/features/admin/data/config/admin_seed_data.dart';
import 'package:placeify_flutter/features/shops/data/consumer_shop_seed.dart';
import 'package:placeify_flutter/features/shops/data/vendor_product_mapper.dart';
import 'package:placeify_flutter/features/vendor/data/config/vendor_mock_config.dart';
import 'package:placeify_flutter/features/vendor/domain/models/vendor_product.dart';

import '../../cart/data/product_id_codec.dart';
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
  static const _placeholderCare =
      'See product description for care details.';
  static const _placeholderMaterials = 'Vendor-listed materials';

  static ProductDetailContent forProduct(Product product) {
    final legacyMock = _legacyMockByProductId[product.id];
    if (legacyMock != null) {
      return legacyMock;
    }

    if (_usesVendorProvidedDetails(product)) {
      return _fromVendorProvidedDetails(product);
    }

    if (VendorProductMapper.isShopProductId(product.id)) {
      final vendorProduct = _vendorProductForShopProduct(product);
      if (vendorProduct != null) {
        return _fromVendorProduct(vendorProduct, product);
      }
    }

    return _fromVendorProvidedDetails(product);
  }

  static bool _usesVendorProvidedDetails(Product product) {
    if (product.vendorId != null) return true;
    return ProductIdCodec.toDatabaseId(product.id) != null;
  }

  static ProductDetailContent _fromVendorProvidedDetails(Product product) {
    final description = product.description.trim();
    final materials = _parseListField(product.materials);
    final care = _parseCareInstructions(product.careInstructions);
    final warranty = _meaningfulText(product.warranty) ??
        _meaningfulText(product.offerLabel);

    return ProductDetailContent(
      description: description.isNotEmpty ? description : product.name,
      galleryImages: _galleryFromProduct(product),
      materials: materials,
      specs: _specsFromProduct(product),
      careInstructions: care,
      warranty: warranty,
    );
  }

  static ProductDetailContent _fromVendorProduct(
    VendorProduct vendorProduct,
    Product product,
  ) {
    final description = vendorProduct.description.trim();
    final materials = _parseListField(vendorProduct.materials);
    final warranty = _meaningfulText(vendorProduct.offerLabel);

    return ProductDetailContent(
      description: description.isNotEmpty ? description : product.name,
      galleryImages: vendorProduct.imageUrls.isNotEmpty
          ? vendorProduct.imageUrls
          : _galleryFromProduct(product),
      materials: materials,
      specs: _specsFromProduct(
        product.copyWith(
          description: vendorProduct.description,
          materials: vendorProduct.materials,
          weightKg: vendorProduct.weightKg > 0 ? vendorProduct.weightKg : null,
          brand: vendorProduct.brand.isNotEmpty
              ? vendorProduct.brand
              : product.brand,
          dimensions: ProductDimensions(
            widthCm: vendorProduct.widthCm,
            depthCm: vendorProduct.depthCm,
            heightCm: vendorProduct.heightCm,
          ),
          offerLabel: vendorProduct.offerLabel,
        ),
      ),
      careInstructions: const [],
      warranty: warranty,
    );
  }

  static List<ProductSpec> _specsFromProduct(Product product) {
    final specs = <ProductSpec>[];
    final dims = product.dimensions;

    if (dims.widthCm > 0 && dims.depthCm > 0 && dims.heightCm > 0) {
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
      final formatted =
          weight.toStringAsFixed(weight % 1 == 0 ? 0 : 1);
      specs.add(ProductSpec(label: 'Weight', value: '$formatted kg'));
    }

    final brand = product.brand.trim();
    if (brand.isNotEmpty && brand != 'Placeify vendor') {
      specs.add(ProductSpec(label: 'Brand', value: brand));
    }

    final sku = product.sku.trim();
    if (sku.isNotEmpty) {
      specs.add(ProductSpec(label: 'SKU', value: sku));
    }

    return specs;
  }

  static List<String> _parseListField(String raw) {
    final text = raw.trim();
    if (text.isEmpty || text == _placeholderMaterials) return const [];

    return text
        .split(RegExp(r'[,;\n]'))
        .map((part) => part.trim())
        .where((part) => part.isNotEmpty)
        .toList();
  }

  static List<String> _parseCareInstructions(String? raw) {
    final text = _meaningfulText(raw);
    if (text == null) return const [];
    return [text];
  }

  static String? _meaningfulText(String? value) {
    final text = value?.trim();
    if (text == null || text.isEmpty) return null;
    if (text == _placeholderCare) return null;
    if (text == _placeholderMaterials) return null;
    if (text == 'Warranty terms provided by the vendor at checkout') {
      return null;
    }
    return text;
  }

  static List<String> _galleryFromProduct(Product product) {
    final gallery = product.galleryImageUrls
        .where((url) => url.trim().isNotEmpty)
        .toList();
    if (gallery.isNotEmpty) return gallery;

    final imageUrl = product.imageUrl.trim();
    if (imageUrl.isNotEmpty && !_isPlaceholderAsset(imageUrl)) {
      return [imageUrl];
    }
    return const [];
  }

  static bool _isPlaceholderAsset(String url) {
    return url.startsWith('assets/icons/') ||
        url == 'assets/images/categories/chair.jpg';
  }

  static VendorProduct? _vendorProductForShopProduct(Product product) {
    final vendorId = product.vendorId;
    if (vendorId == null) return null;

    final prefix = 'shop-$vendorId-';
    if (!product.id.startsWith(prefix)) return null;
    final productId = product.id.substring(prefix.length);

    if (VendorMockConfig.isKnownVendor(vendorId)) {
      return VendorMockConfig.productById(productId);
    }
    if (vendorId == AdminSeedData.approvedVendorId ||
        ConsumerShopSeed.hasSeedProducts(vendorId)) {
      for (final seedProduct in ConsumerShopSeed.productsFor(vendorId)) {
        if (seedProduct.id == productId) return seedProduct;
      }
    }
    return null;
  }

  /// Legacy seeded mock copy for design previews (p1, p4, p5 only).
  static const Map<String, ProductDetailContent> _legacyMockByProductId = {
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
