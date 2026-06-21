import 'dart:io';
import 'dart:typed_data';

import 'package:placeify_client/placeify_client.dart';

import '../../../core/config/placeify_server_client.dart';
import '../../cart/data/product_id_codec.dart';
import '../domain/models/vendor_product.dart';
import '../domain/repositories/vendor_product_repository.dart';
import 'vendor_product_mapper.dart';

/// Serverpod-backed vendor product catalog (create/list via [client.vendor]).
class ServerpodVendorProductRepository implements VendorProductRepository {
  const ServerpodVendorProductRepository();

  @override
  Future<List<VendorProduct>> getProducts(String vendorId) async {
    await _ensureShopReady();
    final products = await client.vendor.listMyProducts();
    return [
      for (final product in products)
        await VendorProductMapper.fromApiProduct(
          product,
          vendorId: vendorId,
        ),
    ];
  }

  @override
  Future<VendorProduct?> getProductById(String productId) async {
    final dbId = ProductIdCodec.toDatabaseId(productId);
    if (dbId == null) return null;

    await _ensureShopReady();
    final products = await client.vendor.listMyProducts();
    for (final product in products) {
      if (product.id == dbId) {
        return VendorProductMapper.fromApiProduct(
          product,
          vendorId: product.vendorId.toString(),
        );
      }
    }
    return null;
  }

  @override
  Future<VendorProduct> createProduct(
    String vendorId,
    VendorProduct product,
  ) async {
    await _ensureShopReady();

    final imagePath = _firstUploadableImagePath(product.imageUrls);
    if (imagePath == null) {
      throw VendorProductActionException('Add at least one product photo.');
    }

    final file = File(imagePath);
    if (!await file.exists()) {
      throw VendorProductActionException('Photo file not found. Pick it again.');
    }

    if (product.widthCm <= 0 ||
        product.depthCm <= 0 ||
        product.heightCm <= 0) {
      throw VendorProductActionException(
        'Enter valid width, depth, and height.',
      );
    }

    final materials = product.materials.trim();
    if (materials.isEmpty) {
      throw VendorProductActionException('Enter product materials.');
    }

    final description = product.description.trim().isNotEmpty
        ? product.description.trim()
        : product.name.trim();

    final bytes = await file.readAsBytes();
    final imageData = ByteData.sublistView(bytes);
    final input = VendorProductUploadInput(
      name: product.name.trim(),
      description: description,
      price: product.price,
      materials: materials,
      widthCm: product.widthCm,
      depthCm: product.depthCm,
      heightCm: product.heightCm,
      careInstructions: 'See product description for care details.',
      categoryId: await _resolveCategoryId(product.categoryId),
      weightKg: product.weightKg > 0 ? product.weightKg : null,
      assemblyNote: product.brand.trim().isNotEmpty ? product.brand.trim() : null,
      warranty: product.offerLabel.trim().isNotEmpty
          ? product.offerLabel.trim()
          : null,
      // 3D models are built via regenerateProductModel3d (Build 3D), not on create.
      generateModel3d: false,
    );

    try {
      final created = await client.vendor.uploadProduct(
        input,
        imageData,
        _fileNameFromPath(imagePath),
      );
      return VendorProductMapper.fromApiProduct(
        created,
        vendorId: vendorId,
      );
    } catch (error) {
      throw VendorProductActionException(_mapError(error));
    }
  }

  @override
  Future<VendorProduct> updateProduct(
    String vendorId,
    VendorProduct product,
  ) async {
    await _ensureShopReady();

    final dbId = ProductIdCodec.toDatabaseId(product.id);
    if (dbId == null) {
      throw VendorProductActionException('Product not found.');
    }

    if (product.widthCm <= 0 ||
        product.depthCm <= 0 ||
        product.heightCm <= 0) {
      throw VendorProductActionException(
        'Enter valid width, depth, and height.',
      );
    }

    final materials = product.materials.trim();
    if (materials.isEmpty) {
      throw VendorProductActionException('Enter product materials.');
    }

    final description = product.description.trim().isNotEmpty
        ? product.description.trim()
        : product.name.trim();

    final input = VendorProductUploadInput(
      productId: dbId,
      name: product.name.trim(),
      description: description,
      price: product.price,
      materials: materials,
      widthCm: product.widthCm,
      depthCm: product.depthCm,
      heightCm: product.heightCm,
      careInstructions: 'See product description for care details.',
      categoryId: await _resolveCategoryId(product.categoryId),
      weightKg: product.weightKg > 0 ? product.weightKg : null,
      assemblyNote: product.brand.trim().isNotEmpty ? product.brand.trim() : null,
      warranty: product.offerLabel.trim().isNotEmpty
          ? product.offerLabel.trim()
          : null,
      // Avoid blocking saves on Tripo (1–3+ min); use Build 3D on the edit screen.
      generateModel3d: false,
      isActive: product.isActive,
    );

    try {
      final imagePath = _firstUploadableImagePath(product.imageUrls);
      ByteData imageData = ByteData(0);
      var imageFileName = '';

      if (imagePath != null) {
        final file = File(imagePath);
        if (await file.exists()) {
          final bytes = await file.readAsBytes();
          imageData = ByteData.sublistView(bytes);
          imageFileName = _fileNameFromPath(imagePath);
        }
      }

      final updated = await client.vendor.uploadProduct(
        input,
        imageData,
        imageFileName,
      );

      return VendorProductMapper.fromApiProduct(
        updated,
        vendorId: vendorId,
      );
    } catch (error) {
      throw VendorProductActionException(_mapError(error));
    }
  }

  @override
  Future<void> deleteProducts(
    String vendorId,
    List<String> productIds,
  ) async {
    throw VendorProductActionException(
      'Deleting products on the server is not supported yet.',
    );
  }

  @override
  Future<VendorProduct> regenerateProductModel3d(
    String vendorId,
    String productId,
  ) async {
    await _ensureShopReady();

    final dbId = ProductIdCodec.toDatabaseId(productId);
    if (dbId == null) {
      throw VendorProductActionException('Product not found.');
    }

    try {
      final updated = await client.vendor.regenerateProductModel3d(dbId);
      return VendorProductMapper.fromApiProduct(
        updated,
        vendorId: vendorId,
      );
    } catch (error) {
      throw VendorProductActionException(_map3dError(error));
    }
  }

  Future<void> _ensureShopReady() async {
    try {
      if (await client.vendor.hasShop()) return;
    } catch (_) {
      // Fall through to shop creation attempt.
    }

    final profile = await client.user.getCurrentUser();
    if (profile == null) {
      throw VendorProductActionException('Sign in to upload products.');
    }

    final phone = profile.phone?.trim();
    final address = profile.address?.trim();
    if (phone == null ||
        phone.isEmpty ||
        address == null ||
        address.isEmpty) {
      throw VendorProductActionException(
        'Complete your phone and address in Profile settings before uploading.',
      );
    }

    try {
      await client.vendor.createShop(
        profile.name,
        description: 'Placeify vendor shop for ${profile.name}.',
        phone: phone,
        address: address,
      );
    } catch (error) {
      final message = _mapError(error);
      if (message.contains('already exists')) return;
      throw VendorProductActionException(message);
    }
  }

  String _fileNameFromPath(String path) {
    final normalized = path.replaceAll('\\', '/');
    final index = normalized.lastIndexOf('/');
    if (index < 0) return normalized;
    return normalized.substring(index + 1);
  }

  Future<int?> _resolveCategoryId(String categorySlug) async {
    final slug = categorySlug.trim();
    if (slug.isEmpty) return null;

    try {
      final categories = await client.product.listCategories();
      for (final category in categories) {
        if (category.name == slug) return category.id;
      }
    } catch (_) {
      return null;
    }
    return null;
  }

  String? _firstUploadableImagePath(List<String> imageUrls) {
    for (final source in imageUrls) {
      final trimmed = source.trim();
      if (trimmed.isEmpty) continue;
      if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
        continue;
      }
      if (trimmed.startsWith('assets/')) continue;
      return trimmed;
    }
    return null;
  }

  String _map3dError(Object error) => _mapError(
        error,
        fallback:
            'Could not build 3D preview. Check your connection and try again.',
      );

  String _mapError(
    Object error, {
    String fallback =
        'Could not upload product. Check your connection and try again.',
  }) {
    if (error is VendorProductActionException) return error.message;

    if (error is PlaceifyException) {
      return _messageForServerCode(error.code, error.message);
    }

    final raw = error is ServerpodClientException
        ? error.message
        : error.toString();

    if (_looksLikeRequestTimeout(raw)) {
      return '3D generation is still running or took too long. '
          'Wait a minute and check the product again, or retry Build 3D.';
    }

    if (_looksLikeConnectionError(raw)) {
      return 'Cannot reach the server. Make sure placeify_server is running and your phone is on the same Wi‑Fi as this Mac.';
    }

    return _messageForServerCode(null, raw, fallback: fallback);
  }

  bool _looksLikeConnectionError(String raw) {
    final lower = raw.toLowerCase();
    return lower.contains('socketexception') ||
        lower.contains('connection refused') ||
        lower.contains('failed host lookup') ||
        lower.contains('network is unreachable') ||
        lower.contains('timed out') ||
        lower.contains('future not completed');
  }

  bool _looksLikeRequestTimeout(String raw) {
    final lower = raw.toLowerCase();
    return lower.contains('future not completed') ||
        lower.contains('timeoutexception') ||
        (lower.contains('timed out') && !lower.contains('tripo generation timed out'));
  }

  String _messageForServerCode(
    String? code,
    String raw, {
    String fallback =
        'Could not upload product. Check your connection and try again.',
  }) {
    final haystack = '${code ?? ''} $raw';

    if (haystack.contains('SHOP_NOT_FOUND')) {
      return 'Create your vendor shop before uploading products.';
    }
    if (haystack.contains('VENDOR_NOT_APPROVED')) {
      return 'Vendor account is pending admin approval.';
    }
    if (haystack.contains('ACCOUNT_INACTIVE')) {
      return 'Vendor account is deactivated.';
    }
    if (haystack.contains('BG_REMOVAL_NOT_CONFIGURED')) {
      return 'Photo processing is not set up on the server. '
          'Add a remove.bg API key to config/removebg_api_key.yaml.';
    }
    if (haystack.contains('BG_REMOVAL_AUTH')) {
      return 'Background removal quota or API key issue. Check your remove.bg account.';
    }
    if (haystack.contains('BG_REMOVAL_FAILED')) {
      return 'Could not process the photo background. Try another image.';
    }
    if (haystack.contains('INVALID_PHONE') || haystack.contains('INVALID_ADDRESS')) {
      return 'Complete your phone and address in Profile settings before uploading.';
    }
    if (haystack.contains('PRODUCT_NOT_FOUND')) {
      return 'Product not found.';
    }
    if (haystack.contains('MODEL3D_NO_THUMBNAIL')) {
      return 'Add a product photo before building a 3D preview.';
    }
    if (haystack.contains('MODEL3D_THUMBNAIL_MISSING')) {
      return 'Product photo file is missing on the server. Re-upload the photo, then try Build 3D again.';
    }
    if (haystack.contains('MODEL3D_INVALID_IMAGE')) {
      return 'Product photo must be JPG, PNG, or WEBP to build a 3D preview.';
    }
    if (haystack.contains('MODEL3D_TRIPO_FAILED') ||
        haystack.contains('MODEL3D_GENERATION_FAILED') ||
        haystack.contains('Tripo API key')) {
      if (raw.contains('Tripo API key') || raw.contains('tripo_api_key')) {
        return 'Tripo API key is missing or invalid. Add a real key to placeify_server/config/tripo_api_key.yaml and restart the server.';
      }
      return '3D generation failed. Check your Tripo API key and account credits, then try again.';
    }
    if (haystack.contains('INVALID_FILE') || haystack.contains('INVALID_FILE_TYPE')) {
      return 'Use a JPG, PNG, or WEBP photo under 8 MB.';
    }
    if (haystack.contains('INVALID_MATERIALS')) {
      return 'Enter product materials.';
    }
    if (haystack.contains('INVALID_DIMENSIONS')) {
      return 'Enter valid width, depth, and height.';
    }
    if (haystack.contains('INVALID_CARE')) {
      return 'Care instructions are required.';
    }
    if (haystack.contains('Method not found') ||
        haystack.contains('regenerateProductModel3d')) {
      return 'Server is missing Build 3D support. Restart placeify_server after pulling the latest code.';
    }

    // PlaceifyException often surfaces as "CODE: message" in Serverpod errors.
    final colonIndex = raw.indexOf(': ');
    if (colonIndex > 0 && colonIndex < 40) {
      final message = raw.substring(colonIndex + 2).trim();
      if (message.isNotEmpty && !message.startsWith('Exception')) {
        return message.length <= 200 ? message : fallback;
      }
    }

    return fallback;
  }
}
