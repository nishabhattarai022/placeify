import 'dart:io';
import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../shared/placeify_exception.dart';
import '../../shared/session_service.dart';

class VendorStore {
  Future<Vendor> requireVendorProfile(Session session) async {
    final user = await SessionService.requireRole(
      session,
      {UserRole.vendor, UserRole.admin},
    );

    final vendor = await Vendor.db.findFirstRow(
      session,
      where: (row) => row.userId.equals(user.id!),
    );
    if (vendor == null) {
      throw PlaceifyException(
        'Vendor profile not found.',
        code: 'VENDOR_NOT_FOUND',
      );
    }
    return vendor;
  }

  Future<Vendor> createShop(
    Session session,
    String shopName, {
    String? description,
    String? logoUrl,
  }) async {
    final user = await SessionService.requireUser(session);
    final existing = await Vendor.db.findFirstRow(
      session,
      where: (row) => row.userId.equals(user.id!),
    );
    if (existing != null) {
      throw PlaceifyException(
        'Vendor shop already exists.',
        code: 'VENDOR_EXISTS',
      );
    }

    await User.db.updateRow(
      session,
      user.copyWith(role: UserRole.vendor),
    );

    return Vendor.db.insertRow(
      session,
      Vendor(
        userId: user.id!,
        shopName: shopName.trim(),
        description: description?.trim(),
        logoUrl: logoUrl?.trim(),
      ),
    );
  }

  Future<Vendor> updateShop(
    Session session,
    String shopName, {
    String? description,
    String? logoUrl,
  }) async {
    final vendor = await requireVendorProfile(session);
    return Vendor.db.updateRow(
      session,
      vendor.copyWith(
        shopName: shopName.trim(),
        description: description?.trim(),
        logoUrl: logoUrl?.trim(),
      ),
    );
  }

  Future<List<Product>> listMyProducts(Session session) async {
    final vendor = await requireVendorProfile(session);
    return Product.db.find(
      session,
      where: (row) => row.vendorId.equals(vendor.id!),
      include: Product.include(category: Category.include()),
      orderBy: (row) => row.createdAt,
      orderDescending: true,
    );
  }

  Future<Product> createProduct(
    Session session,
    String name,
    String description,
    double price, {
    int? categoryId,
    String? model3dUrl,
    String? thumbnailUrl,
  }) async {
    final vendor = await requireVendorProfile(session);
    if (name.trim().isEmpty || description.trim().isEmpty) {
      throw PlaceifyException(
        'Name and description are required.',
        code: 'INVALID_PRODUCT',
      );
    }
    if (price <= 0) {
      throw PlaceifyException('Price must be positive.', code: 'INVALID_PRICE');
    }

    return Product.db.insertRow(
      session,
      Product(
        vendorId: vendor.id!,
        categoryId: categoryId,
        name: name.trim(),
        description: description.trim(),
        price: price,
        model3dUrl: model3dUrl?.trim(),
        thumbnailUrl: thumbnailUrl?.trim(),
        status: ProductStatus.active,
      ),
    );
  }

  Future<Product> updateProductThumbnail(
    Session session,
    int productId,
    String thumbnailUrl,
  ) async {
    final vendor = await requireVendorProfile(session);
    final product = await Product.db.findById(session, productId);
    if (product == null || product.vendorId != vendor.id) {
      throw PlaceifyException('Product not found.', code: 'PRODUCT_NOT_FOUND');
    }

    return Product.db.updateRow(
      session,
      product.copyWith(thumbnailUrl: thumbnailUrl.trim()),
    );
  }

  Future<String> uploadProductImage(
    Session session,
    ByteData fileData,
    String fileName,
  ) async {
    await requireVendorProfile(session);
    final sanitized = fileName.replaceAll(RegExp(r'[^a-zA-Z0-9._-]'), '_');
    final uploadsDir = Directory('web/static/uploads');
    if (!uploadsDir.existsSync()) {
      uploadsDir.createSync(recursive: true);
    }

    final storedName =
        '${DateTime.now().millisecondsSinceEpoch}_$sanitized';
    final file = File('web/static/uploads/$storedName');
    await file.writeAsBytes(fileData.buffer.asUint8List());
    return '/uploads/$storedName';
  }
}
