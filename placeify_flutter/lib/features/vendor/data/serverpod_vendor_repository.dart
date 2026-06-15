import 'dart:typed_data';

import 'package:placeify_client/placeify_client.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../../../../main.dart' show client;
import '../domain/models/picked_product_image.dart';
import '../domain/repositories/vendor_repository.dart';

class ServerpodVendorRepository implements VendorRepository {
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
      for (final photo in extraViewPhotos.take(3)) {
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
      throw VendorRepositoryException(
        'Sign in to manage your shop.',
        code: 'AUTH_REQUIRED',
      );
    }
  }

  VendorRepositoryException _mapError(Object error) {
    if (error is VendorRepositoryException) return error;
    if (error is PlaceifyException) {
      return _fromPlaceifyException(error);
    }
    final message = error is ServerpodClientException
        ? error.message
        : error.toString();
    if (message.contains('NoSuchMethodError') &&
        message.contains('regenerateProductModel3d')) {
      return VendorRepositoryException(
        'App is out of date. Stop Flutter and run `flutter run` again (not hot reload).',
        code: 'CLIENT_OUT_OF_DATE',
      );
    }
    if (message.contains('Not found') ||
        message.contains('No method') ||
        message.contains('Method not found')) {
      return VendorRepositoryException(
        'Server is missing Build 3D. Run `serverpod generate` in placeify_server, then restart the server.',
        code: 'SERVER_OUT_OF_DATE',
      );
    }
    if (message.contains('SHOP_NOT_FOUND') ||
        message.contains('Vendor profile not found')) {
      return VendorRepositoryException(
        'Create your shop to get started.',
        code: 'SHOP_NOT_FOUND',
      );
    }
    if (message.contains('FORBIDDEN') ||
        message.contains('permission')) {
      return VendorRepositoryException(
        'You do not have permission to perform this action.',
        code: 'FORBIDDEN',
      );
    }
    if (message.contains('VENDOR_EXISTS')) {
      return VendorRepositoryException(
        'You already have a shop.',
        code: 'VENDOR_EXISTS',
      );
    }
    if (message.contains('INVALID_SHOP_NAME')) {
      return VendorRepositoryException(
        'Enter a shop name.',
        code: 'INVALID_SHOP_NAME',
      );
    }
    if (message.contains('INVALID_SHOP_DESCRIPTION')) {
      return VendorRepositoryException(
        'Enter a shop description.',
        code: 'INVALID_SHOP_DESCRIPTION',
      );
    }
    if (message.contains('INVALID_PHONE')) {
      return VendorRepositoryException(
        'Enter a phone number.',
        code: 'INVALID_PHONE',
      );
    }
    if (message.contains('INVALID_ADDRESS')) {
      return VendorRepositoryException(
        'Enter your shop address.',
        code: 'INVALID_ADDRESS',
      );
    }
    if (message.contains('INVALID_MATERIALS')) {
      return VendorRepositoryException(
        'List the product materials.',
        code: 'INVALID_MATERIALS',
      );
    }
    if (message.contains('INVALID_DIMENSIONS')) {
      return VendorRepositoryException(
        'Enter valid width, depth, and height.',
        code: 'INVALID_DIMENSIONS',
      );
    }
    if (message.contains('INVALID_CARE')) {
      return VendorRepositoryException(
        'Add care instructions for customers.',
        code: 'INVALID_CARE',
      );
    }
    if (message.contains('FILE_TOO_LARGE')) {
      return VendorRepositoryException(
        'Image is too large. Use a photo under 8 MB.',
        code: 'FILE_TOO_LARGE',
      );
    }
    if (message.contains('ORDER_NOT_FOUND')) {
      return VendorRepositoryException(
        'Order not found.',
        code: 'ORDER_NOT_FOUND',
      );
    }
    if (message.contains('INVALID_FILE_TYPE')) {
      return VendorRepositoryException(
        'Use a JPG, PNG, or WEBP image.',
        code: 'INVALID_FILE_TYPE',
      );
    }
    if (message.contains('BG_REMOVAL_NOT_CONFIGURED')) {
      return VendorRepositoryException(
        'Photo processing is not set up on the server. '
        'Add a remove.bg API key to config/removebg_api_key.yaml.',
        code: 'BG_REMOVAL_NOT_CONFIGURED',
      );
    }
    if (message.contains('BG_REMOVAL_AUTH')) {
      return VendorRepositoryException(
        'Background removal quota or API key issue. Check your remove.bg account.',
        code: 'BG_REMOVAL_AUTH',
      );
    }
    if (message.contains('BG_REMOVAL_FAILED')) {
      final detail = message.split(': ').skip(1).join(': ').trim();
      return VendorRepositoryException(
        detail.isNotEmpty
            ? detail
            : 'Could not process the photo background. Try another image.',
        code: 'BG_REMOVAL_FAILED',
      );
    }
    if (message.contains('INVALID_FILE')) {
      return VendorRepositoryException(
        'Add a product photo before publishing.',
        code: 'INVALID_FILE',
      );
    }
    if (message.contains('INVALID_PRICE')) {
      return VendorRepositoryException(
        'Enter a price greater than zero.',
        code: 'INVALID_PRICE',
      );
    }
    if (message.contains('INVALID_PRODUCT')) {
      return VendorRepositoryException(
        'Enter a product name and description.',
        code: 'INVALID_PRODUCT',
      );
    }
    if (message.contains('MODEL3D_NO_THUMBNAIL')) {
      return VendorRepositoryException(
        'Add a product photo before building a 3D preview.',
        code: 'MODEL3D_NO_THUMBNAIL',
      );
    }
    if (message.contains('MODEL3D_THUMBNAIL_MISSING')) {
      return VendorRepositoryException(
        'Product photo file is missing on the server. Re-upload the photo, then try Build 3D again.',
        code: 'MODEL3D_THUMBNAIL_MISSING',
      );
    }
    if (message.contains('MODEL3D_TRIPO_FAILED')) {
      final detail = message.split(': ').skip(1).join(': ').trim();
      return VendorRepositoryException(
        detail.isNotEmpty
            ? detail
            : '3D generation failed. Add your Tripo key to config/tripo_api_key.yaml on the server.',
        code: 'MODEL3D_TRIPO_FAILED',
      );
    }
    if (message.contains('MODEL3D_GENERATION_FAILED')) {
      final detail = message.split(': ').skip(1).join(': ').trim();
      return VendorRepositoryException(
        detail.isNotEmpty
            ? detail
            : '3D model could not be generated. Re-upload the photo and try again.',
        code: 'MODEL3D_GENERATION_FAILED',
      );
    }
    if (message.contains('PRODUCT_NOT_FOUND')) {
      return VendorRepositoryException(
        'Product not found.',
        code: 'PRODUCT_NOT_FOUND',
      );
    }
    if (message.contains('Method not found') ||
        message.contains('regenerateProductModel3d')) {
      return VendorRepositoryException(
        'Server is out of date. Restart placeify_server after pulling the latest code.',
        code: 'SERVER_OUT_OF_DATE',
      );
    }
    if (message.contains('SocketException') ||
        message.contains('Connection refused') ||
        message.contains('Failed host lookup')) {
      return VendorRepositoryException(
        'Cannot reach the server. Make sure placeify_server is running.',
        code: 'NETWORK',
      );
    }
    if (message.isNotEmpty) {
      return VendorRepositoryException(message);
    }
    return VendorRepositoryException('Something went wrong. Try again.');
  }

  VendorRepositoryException _fromPlaceifyException(PlaceifyException error) {
    return _mapError('${error.code}: ${error.message}');
  }
}
