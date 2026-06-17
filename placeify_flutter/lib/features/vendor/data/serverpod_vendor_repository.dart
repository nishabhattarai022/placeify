import 'dart:typed_data';

import 'package:placeify_client/placeify_client.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../../../core/config/placeify_server_client.dart';
import '../domain/models/picked_product_image.dart';
import '../domain/repositories/vendor_commerce_repository.dart';

class ServerpodVendorRepository implements VendorCommerceRepository {
  @override
  Future<VendorDashboard> getDashboard() async {
    _requireAuthenticated();
    try {
      return await client.vendor.getDashboard();
    } catch (error) {
      throw _mapError(error);
    }
  }

  @override
  Future<bool> hasShop() async {
    _requireAuthenticated();
    try {
      return await client.vendor.hasShop();
    } catch (_) {
      return false;
    }
  }

  @override
  Future<Vendor> createShop(
    String shopName, {
    required String description,
    required String phone,
    required String address,
  }) async {
    _requireAuthenticated();
    try {
      return await client.vendor.createShop(
        shopName,
        description: description,
        phone: phone,
        address: address,
      );
    } catch (error) {
      throw _mapError(error);
    }
  }

  @override
  Future<List<VendorShopOrder>> listShopOrders({OrderStatus? status}) async {
    _requireAuthenticated();
    try {
      return await client.vendor.listShopOrders(
        limit: 100,
        offset: 0,
        status: status,
      );
    } catch (error) {
      throw _mapError(error);
    }
  }

  @override
  Future<VendorShopOrder> getShopOrder(int orderId) async {
    _requireAuthenticated();
    try {
      return await client.vendor.getShopOrder(orderId);
    } catch (error) {
      throw _mapError(error);
    }
  }

  @override
  Future<List<Product>> listMyProducts() async {
    _requireAuthenticated();
    try {
      return await client.vendor.listMyProducts();
    } catch (error) {
      throw _mapError(error);
    }
  }

  @override
  Future<Product> createProduct({
    required String name,
    required String description,
    required double price,
    required int categoryId,
    required String materials,
    required double widthCm,
    required double depthCm,
    required double heightCm,
    required String careInstructions,
    required List<int> imageBytes,
    required String imageFileName,
    List<PickedProductImage?> extraViewPhotos = const [],
    double? weightKg,
    String? assemblyNote,
    String? warranty,
  }) async {
    _requireAuthenticated();
    try {
      final thumbnailUrl = await client.vendor.uploadProductImage(
        ByteData.sublistView(Uint8List.fromList(imageBytes)),
        imageFileName,
      );

      final viewImageUrls = <String>[];
      for (final photo in extraViewPhotos.take(5)) {
        if (photo == null) {
          if (viewImageUrls.isNotEmpty) viewImageUrls.add('');
          continue;
        }
        viewImageUrls.add(
          await client.vendor.uploadProductImage(
            ByteData.sublistView(photo.bytes),
            photo.fileName,
          ),
        );
      }

      return await client.vendor.createProduct(
        name,
        description,
        price,
        categoryId: categoryId,
        materials: materials,
        widthCm: widthCm,
        depthCm: depthCm,
        heightCm: heightCm,
        weightKg: weightKg,
        assemblyNote: assemblyNote,
        careInstructions: careInstructions,
        warranty: warranty,
        thumbnailUrl: thumbnailUrl,
        viewImageUrls: viewImageUrls.isEmpty ? null : viewImageUrls,
      );
    } catch (error) {
      throw _mapError(error);
    }
  }

  @override
  Future<Product> regenerateProductModel3d(int productId) async {
    _requireAuthenticated();
    try {
      return await client.vendor.regenerateProductModel3d(productId);
    } catch (error) {
      throw _mapError(error);
    }
  }

  void _requireAuthenticated() {
    if (!client.auth.isAuthenticated) {
      throw VendorCommerceRepositoryException(
        'Sign in to manage your shop.',
        code: 'AUTH_REQUIRED',
      );
    }
  }

  VendorCommerceRepositoryException _mapError(Object error) {
    if (error is VendorCommerceRepositoryException) return error;
    if (error is PlaceifyException) {
      return _fromPlaceifyException(error);
    }
    final message = error is ServerpodClientException
        ? error.message
        : error.toString();
    if (message.contains('NoSuchMethodError') &&
        message.contains('regenerateProductModel3d')) {
      return VendorCommerceRepositoryException(
        'App is out of date. Stop Flutter and run `flutter run` again (not hot reload).',
        code: 'CLIENT_OUT_OF_DATE',
      );
    }
    if (message.contains('Not found') ||
        message.contains('No method') ||
        message.contains('Method not found')) {
      return VendorCommerceRepositoryException(
        'Server is missing Build 3D. Run `serverpod generate` in placeify_server, then restart the server.',
        code: 'SERVER_OUT_OF_DATE',
      );
    }
    if (message.contains('SHOP_NOT_FOUND') ||
        message.contains('Vendor profile not found')) {
      return VendorCommerceRepositoryException(
        'Create your shop to get started.',
        code: 'SHOP_NOT_FOUND',
      );
    }
    if (message.contains('FORBIDDEN') ||
        message.contains('permission')) {
      return VendorCommerceRepositoryException(
        'You do not have permission to perform this action.',
        code: 'FORBIDDEN',
      );
    }
    if (message.contains('VENDOR_EXISTS')) {
      return VendorCommerceRepositoryException(
        'You already have a shop.',
        code: 'VENDOR_EXISTS',
      );
    }
    if (message.contains('INVALID_SHOP_NAME')) {
      return VendorCommerceRepositoryException(
        'Enter a shop name.',
        code: 'INVALID_SHOP_NAME',
      );
    }
    if (message.contains('INVALID_SHOP_DESCRIPTION')) {
      return VendorCommerceRepositoryException(
        'Enter a shop description.',
        code: 'INVALID_SHOP_DESCRIPTION',
      );
    }
    if (message.contains('INVALID_PHONE')) {
      return VendorCommerceRepositoryException(
        'Enter a phone number.',
        code: 'INVALID_PHONE',
      );
    }
    if (message.contains('INVALID_ADDRESS')) {
      return VendorCommerceRepositoryException(
        'Enter your shop address.',
        code: 'INVALID_ADDRESS',
      );
    }
    if (message.contains('INVALID_MATERIALS')) {
      return VendorCommerceRepositoryException(
        'List the product materials.',
        code: 'INVALID_MATERIALS',
      );
    }
    if (message.contains('INVALID_DIMENSIONS')) {
      return VendorCommerceRepositoryException(
        'Enter valid width, depth, and height.',
        code: 'INVALID_DIMENSIONS',
      );
    }
    if (message.contains('INVALID_CARE')) {
      return VendorCommerceRepositoryException(
        'Add care instructions for customers.',
        code: 'INVALID_CARE',
      );
    }
    if (message.contains('FILE_TOO_LARGE')) {
      return VendorCommerceRepositoryException(
        'Image is too large. Use a photo under 8 MB.',
        code: 'FILE_TOO_LARGE',
      );
    }
    if (message.contains('ORDER_NOT_FOUND')) {
      return VendorCommerceRepositoryException(
        'Order not found.',
        code: 'ORDER_NOT_FOUND',
      );
    }
    if (message.contains('INVALID_FILE_TYPE')) {
      return VendorCommerceRepositoryException(
        'Use a JPG, PNG, or WEBP image.',
        code: 'INVALID_FILE_TYPE',
      );
    }
    if (message.contains('BG_REMOVAL_NOT_CONFIGURED')) {
      return VendorCommerceRepositoryException(
        'Photo processing is not set up on the server. '
        'Add a remove.bg API key to config/removebg_api_key.yaml.',
        code: 'BG_REMOVAL_NOT_CONFIGURED',
      );
    }
    if (message.contains('BG_REMOVAL_AUTH')) {
      return VendorCommerceRepositoryException(
        'Background removal quota or API key issue. Check your remove.bg account.',
        code: 'BG_REMOVAL_AUTH',
      );
    }
    if (message.contains('BG_REMOVAL_FAILED')) {
      final detail = message.split(': ').skip(1).join(': ').trim();
      return VendorCommerceRepositoryException(
        detail.isNotEmpty
            ? detail
            : 'Could not process the photo background. Try another image.',
        code: 'BG_REMOVAL_FAILED',
      );
    }
    if (message.contains('INVALID_FILE')) {
      return VendorCommerceRepositoryException(
        'Add a product photo before publishing.',
        code: 'INVALID_FILE',
      );
    }
    if (message.contains('INVALID_PRICE')) {
      return VendorCommerceRepositoryException(
        'Enter a price greater than zero.',
        code: 'INVALID_PRICE',
      );
    }
    if (message.contains('INVALID_PRODUCT')) {
      return VendorCommerceRepositoryException(
        'Enter a product name and description.',
        code: 'INVALID_PRODUCT',
      );
    }
    if (message.contains('MODEL3D_NO_THUMBNAIL')) {
      return VendorCommerceRepositoryException(
        'Add a product photo before building a 3D preview.',
        code: 'MODEL3D_NO_THUMBNAIL',
      );
    }
    if (message.contains('MODEL3D_THUMBNAIL_MISSING')) {
      return VendorCommerceRepositoryException(
        'Product photo file is missing on the server. Re-upload the photo, then try Build 3D again.',
        code: 'MODEL3D_THUMBNAIL_MISSING',
      );
    }
    if (message.contains('MODEL3D_INSUFFICIENT_VIEWS')) {
      return VendorCommerceRepositoryException(
        'Please upload at least 5 images for accurate 3D reconstruction.',
        code: 'MODEL3D_INSUFFICIENT_VIEWS',
      );
    }
    if (message.contains('MODEL3D_TRIPO_SOURCE_MISSING')) {
      return VendorCommerceRepositoryException(
        'Re-upload all product photos so 3D can use your originals (not white-background catalog images), then try Build 3D again.',
        code: 'MODEL3D_TRIPO_SOURCE_MISSING',
      );
    }
    if (message.contains('MODEL3D_TRIPO_FAILED')) {
      final detail = message.split(': ').skip(1).join(': ').trim();
      return VendorCommerceRepositoryException(
        detail.isNotEmpty
            ? detail
            : '3D generation failed. Add your Tripo key to config/tripo_api_key.yaml on the server.',
        code: 'MODEL3D_TRIPO_FAILED',
      );
    }
    if (message.contains('MODEL3D_GENERATION_FAILED')) {
      final detail = message.split(': ').skip(1).join(': ').trim();
      return VendorCommerceRepositoryException(
        detail.isNotEmpty
            ? detail
            : '3D model could not be generated. Re-upload the photo and try again.',
        code: 'MODEL3D_GENERATION_FAILED',
      );
    }
    if (message.contains('PRODUCT_NOT_FOUND')) {
      return VendorCommerceRepositoryException(
        'Product not found.',
        code: 'PRODUCT_NOT_FOUND',
      );
    }
    if (message.contains('Method not found') ||
        message.contains('regenerateProductModel3d')) {
      return VendorCommerceRepositoryException(
        'Server is out of date. Restart placeify_server after pulling the latest code.',
        code: 'SERVER_OUT_OF_DATE',
      );
    }
    if (message.contains('SocketException') ||
        message.contains('Connection refused') ||
        message.contains('Failed host lookup')) {
      return VendorCommerceRepositoryException(
        'Cannot reach the server. Make sure placeify_server is running.',
        code: 'NETWORK',
      );
    }
    if (message.isNotEmpty) {
      return VendorCommerceRepositoryException(message);
    }
    return VendorCommerceRepositoryException('Something went wrong. Try again.');
  }

  VendorCommerceRepositoryException _fromPlaceifyException(PlaceifyException error) {
    return _mapError('${error.code}: ${error.message}');
  }
}
