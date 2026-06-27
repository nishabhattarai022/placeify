import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:placeify_client/placeify_client.dart';

import '../../../core/config/resolve_media_url.dart';
import '../../../core/config/placeify_server_client.dart';
import '../../../core/utils/local_image_reader.dart';
import '../../../core/utils/local_image_store.dart';
import '../../cart/data/product_id_codec.dart';
import '../domain/models/vendor_product.dart';
import '../domain/repositories/vendor_product_repository.dart';
import 'mock_vendor_product_repository.dart' show VendorProductActionException;
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

    final imagePaths = _uploadableImagePaths(product.imageUrls);
    if (imagePaths.isEmpty) {
      throw VendorProductActionException('Add at least one product photo.');
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

    try {
      final sources = _orderedImageSources(product.imageUrls);
      final Product created;
      if (sources.length >= 4) {
        created = await _createProductWithMultiviewPhotos(
          product: product,
          imageSources: sources.take(4).toList(),
          description: description,
          materials: materials,
        );
      } else {
        final imageData = await _readImageByteData(
          imagePaths.first,
          fileName: _resolvedFileName(imagePaths.first),
        );
        if (imageData == null) {
          throw VendorProductActionException(
            'Photo file not found. Pick it again.',
          );
        }
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
          assemblyNote:
              product.brand.trim().isNotEmpty ? product.brand.trim() : null,
          warranty: product.offerLabel.trim().isNotEmpty
              ? product.offerLabel.trim()
              : null,
          generateModel3d: false,
        );
        created = await client.vendor.uploadProduct(
          input,
          imageData,
          _resolvedFileName(imagePaths.first),
        );
      }

      return _mapUploadedProduct(
        created,
        vendorId: vendorId,
        fallback: product,
      );
    } catch (error) {
      throw VendorProductActionException(_mapError(error));
    }
  }

  Future<Product> _createProductWithMultiviewPhotos({
    required VendorProduct product,
    required List<String> imageSources,
    required String description,
    required String materials,
  }) async {
    final multiview = await _uploadMultiviewUrlsFromSources(imageSources);

    return client.vendor.createProduct(
      product.name.trim(),
      description,
      product.price,
      categoryId: await _resolveCategoryId(product.categoryId),
      materials: materials,
      widthCm: product.widthCm,
      depthCm: product.depthCm,
      heightCm: product.heightCm,
      weightKg: product.weightKg > 0 ? product.weightKg : null,
      assemblyNote: product.brand.trim().isNotEmpty ? product.brand.trim() : null,
      careInstructions: 'See product description for care details.',
      warranty:
          product.offerLabel.trim().isNotEmpty ? product.offerLabel.trim() : null,
      thumbnailUrl: multiview.thumbnailUrl,
      viewImageUrls: multiview.viewImageUrls,
    );
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

    try {
      final sources = _orderedImageSources(product.imageUrls);
      final Product updated;
      if (sources.length >= 4) {
        updated = await _updateProductWithMultiviewPhotos(
          product: product,
          dbId: dbId,
          description: description,
          materials: materials,
          imageSources: sources.take(4).toList(),
        );
      } else {
        final input = await _buildUploadInput(
          product: product,
          dbId: dbId,
          description: description,
          materials: materials,
        );

        final imagePath = _firstUploadableImagePath(product.imageUrls);
        ByteData imageData = ByteData(0);
        var imageFileName = '';

        if (imagePath != null) {
          final bytes = await _readImageByteData(
            imagePath,
            fileName: _fileNameFromPath(imagePath),
          );
          if (bytes != null) {
            imageData = bytes;
            imageFileName = _fileNameFromPath(imagePath);
          }
        }

        updated = await client.vendor.uploadProduct(
          input,
          imageData,
          imageFileName,
        );
      }

      return _mapUploadedProduct(
        updated,
        vendorId: vendorId,
        fallback: product,
      );
    } catch (error) {
      throw VendorProductActionException(_mapError(error));
    }
  }

  Future<VendorProductUploadInput> _buildUploadInput({
    required VendorProduct product,
    required int dbId,
    required String description,
    required String materials,
    List<String>? viewImageUrls,
  }) async {
    return VendorProductUploadInput(
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
      generateModel3d: false,
      isActive: product.isActive,
      viewImageUrls: viewImageUrls,
    );
  }

  Future<Product> _updateProductWithMultiviewPhotos({
    required VendorProduct product,
    required int dbId,
    required String description,
    required String materials,
    required List<String> imageSources,
    bool forceReupload = false,
  }) async {
    final multiview = await _uploadMultiviewUrlsFromSources(
      imageSources,
      forceReupload: forceReupload,
    );
    final input = await _buildUploadInput(
      product: product,
      dbId: dbId,
      description: description,
      materials: materials,
      viewImageUrls: multiview.viewImageUrls,
    );

    final frontLocal = _normalizeLocalImagePath(imageSources.first);
    ByteData imageData = ByteData(0);
    var imageFileName = '';
    if (frontLocal != null) {
      final bytes = await _readImageByteData(
        frontLocal,
        fileName: _fileNameFromPath(frontLocal),
      );
      if (bytes != null) {
        imageData = bytes;
        imageFileName = _fileNameFromPath(frontLocal);
      }
    }

    return client.vendor.uploadProduct(
      input,
      imageData,
      imageFileName,
    );
  }

  Future<void> _syncMultiviewPhotosOnServer({
    required VendorProduct product,
    required int dbId,
    required List<String> imageSources,
    bool forceReupload = false,
  }) async {
    final description = product.description.trim().isNotEmpty
        ? product.description.trim()
        : product.name.trim();
    final materials = product.materials.trim();
    await _updateProductWithMultiviewPhotos(
      product: product,
      dbId: dbId,
      description: description,
      materials: materials,
      imageSources: imageSources.take(4).toList(),
      forceReupload: forceReupload,
    );
  }

  Future<VendorProduct> _mapUploadedProduct(
    Product created, {
    required String vendorId,
    required VendorProduct fallback,
  }) async {
    try {
      return await VendorProductMapper.fromApiProduct(
        created,
        vendorId: vendorId,
      );
    } catch (_) {
      final dbId = created.id;
      if (dbId == null) {
        throw VendorProductActionException(
          'Product saved, but the server response was incomplete. '
          'Refresh your product list.',
        );
      }
      return fallback.copyWith(id: ProductIdCodec.fromDatabaseId(dbId));
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
    String productId, {
    List<String>? imageSources,
  }) async {
    await _ensureShopReady();

    final dbId = ProductIdCodec.toDatabaseId(productId);
    if (dbId == null) {
      throw VendorProductActionException('Product not found.');
    }

    try {
      final existing = await getProductById(productId);
      if (existing == null) {
        throw VendorProductActionException('Product not found.');
      }

      final sources = _orderedImageSources(imageSources ?? existing.imageUrls);
      if (sources.length >= 4) {
        await _syncMultiviewPhotosOnServer(
          product: existing,
          dbId: dbId,
          imageSources: sources.take(4).toList(),
          forceReupload: true,
        );
      }

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

  List<String> _uploadableImagePaths(List<String> imageUrls) {
    final paths = <String>[];
    for (final source in imageUrls) {
      final normalized = _normalizeLocalImagePath(source);
      if (normalized == null) continue;
      paths.add(normalized);
    }
    return paths;
  }

  List<String> _orderedImageSources(List<String> imageUrls) {
    return imageUrls
        .map((source) => source.trim())
        .where((source) => source.isNotEmpty)
        .toList();
  }

  Future<({String thumbnailUrl, List<String> viewImageUrls})>
      _uploadMultiviewUrlsFromSources(
    List<String> sources, {
    bool forceReupload = false,
  }) async {
    if (sources.length < 4) {
      throw VendorProductActionException(
        'Please upload 4 photos (front, left, back, right) for 3D generation.',
      );
    }

    final slots = sources.take(4).toList();
    final thumbnailUrl = await _ensureServerImageUrl(
      slots[0],
      removeBackground: true,
      forceReupload: forceReupload,
    );

    final viewImageUrls = <String>[];
    for (final source in slots.skip(1)) {
      viewImageUrls.add(
        await _ensureServerImageUrl(
          source,
          removeBackground: false,
          forceReupload: forceReupload,
        ),
      );
    }

    if (viewImageUrls.length < 3) {
      throw VendorProductActionException(
        'Please upload 4 photos (front, left, back, right) for 3D generation.',
      );
    }

    return (thumbnailUrl: thumbnailUrl, viewImageUrls: viewImageUrls);
  }

  Future<String> _ensureServerImageUrl(
    String source, {
    required bool removeBackground,
    bool forceReupload = false,
  }) async {
    final localPath = _normalizeLocalImagePath(source);
    if (localPath != null) {
      final imageData = await _readImageByteData(
        localPath,
        fileName: _fileNameFromPath(localPath),
      );
      if (imageData == null) {
        throw VendorProductActionException(
          'Photo file not found. Pick it again.',
        );
      }
      return client.vendor.uploadProductImage(
        imageData,
        _resolvedFileName(localPath),
        removeBackground: removeBackground,
      );
    }

    final existing = _serverPathFromSource(source);
    if (existing != null) {
      if (!forceReupload) return existing;
      return _reuploadServerImage(existing, removeBackground: removeBackground);
    }

    throw VendorProductActionException('Photo file not found. Pick it again.');
  }

  Future<String> _reuploadServerImage(
    String serverPath, {
    required bool removeBackground,
  }) async {
    final url = await resolveMediaUrl(serverPath);
    if (url.isEmpty) {
      throw VendorProductActionException('Photo file not found. Pick it again.');
    }

    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200 || response.bodyBytes.isEmpty) {
      throw VendorProductActionException(
        'Could not refresh product photo from server. Re-pick the photo and try again.',
      );
    }

    final fileName = _fileNameFromPath(serverPath);
    return client.vendor.uploadProductImage(
      ByteData.view(
        response.bodyBytes.buffer,
        response.bodyBytes.offsetInBytes,
        response.bodyBytes.lengthInBytes,
      ),
      fileName.isNotEmpty ? fileName : 'product_photo.jpg',
      removeBackground: removeBackground,
    );
  }

  String? _serverPathFromSource(String source) {
    var trimmed = source.trim();
    if (trimmed.isEmpty) return null;

    final queryIndex = trimmed.indexOf('?');
    if (queryIndex >= 0) {
      trimmed = trimmed.substring(0, queryIndex);
    }

    if (trimmed.startsWith('/uploads/')) return trimmed;

    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      final uri = Uri.tryParse(trimmed);
      if (uri == null) return null;
      final uploadsIndex = uri.path.indexOf('/uploads/');
      if (uploadsIndex >= 0) {
        return uri.path.substring(uploadsIndex);
      }
    }

    return null;
  }

  String? _firstUploadableImagePath(List<String> imageUrls) {
    for (final source in imageUrls) {
      final normalized = _normalizeLocalImagePath(source);
      if (normalized == null) continue;
      return normalized;
    }
    return null;
  }

  String? _normalizeLocalImagePath(String source) {
    var trimmed = source.trim();
    if (trimmed.isEmpty) return null;
    if (trimmed.startsWith(LocalImageStore.scheme)) return trimmed;
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return null;
    }
    if (trimmed.startsWith('assets/')) return null;
    if (trimmed.startsWith('blob:')) return trimmed;
    if (trimmed.startsWith('file://')) {
      trimmed = Uri.parse(trimmed).toFilePath();
    }
    return trimmed;
  }

  Future<ByteData?> _readImageByteData(
    String source, {
    String? fileName,
  }) async {
    final data = await LocalImageReader.read(source, fileName: fileName);
    if (data == null) return null;
    return ByteData.sublistView(data.bytes);
  }

  String _resolvedFileName(String source) {
    final stored = LocalImageStore.readUri(source);
    if (stored != null) return stored.fileName;
    return _fileNameFromPath(source);
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
      return _messageForServerCode(
        error.code,
        error.message,
        fallback: fallback,
      );
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
    if (haystack.contains('MODEL3D_INSUFFICIENT_VIEWS')) {
      return 'Please upload 4 photos (front, left, back, right) for 3D generation. '
          'Add four images in the photo grid, save the product, then tap Build 3D.';
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
