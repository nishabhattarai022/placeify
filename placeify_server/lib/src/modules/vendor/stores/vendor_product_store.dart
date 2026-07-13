import 'dart:async';
import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';

import '../../../generated/protocol.dart';
import '../../../shared/placeify_exception.dart';
import '../../../shared/session_service.dart';
import '../../marketplace/marketplace_events.dart';
import '../../product/product_pricing.dart';
import '../product_3d/product_3d_generation_future_call.dart';
import '../product_3d/product_model_3d_status.dart';
import '../vendor_product_image_storage.dart';
import 'vendor_access_guard.dart';

/// Product create/update pricing, lifecycle, and marketplace events.
class VendorProductStore {
  VendorProductStore({
    MarketplaceEventDispatcher? events,
    VendorAccessGuard? access,
    VendorProductImageStorage? imageStorage,
  })  : _events = events ?? marketplaceEventDispatcher,
        _access = access ?? VendorAccessGuard(),
        _images = imageStorage ?? VendorProductImageStorage();

  final MarketplaceEventDispatcher _events;
  final VendorAccessGuard _access;
  final VendorProductImageStorage _images;

  Product withPricing({
    required Product product,
    required double listPrice,
    double? discountPrice,
    double? discountPercentage,
    bool? featured,
  }) {
    final normalized = ProductPricing.normalizeDiscounts(
      listPrice: listPrice,
      discountPrice: discountPrice,
      discountPercentage: discountPercentage,
    );
    final priced = product.copyWith(
      price: listPrice,
      discountPrice: normalized.discountPrice,
      discountPercentage: normalized.discountPercentage,
      featured: featured ?? product.featured,
    );
    return priced.copyWith(isOffer: ProductPricing.hasActiveOffer(priced));
  }

  Future<void> dispatchProductEvents(
    Session session,
    Product product,
    UuidValue vendorId, {
    required bool created,
  }) async {
    if (created) {
      await _events.dispatch(
        session,
        ProductCreatedEvent(product: product, vendorId: vendorId),
      );
    }
    if (ProductPricing.hasActiveOffer(product)) {
      await _events.dispatch(
        session,
        DiscountActivatedEvent(product: product, vendorId: vendorId),
      );
    }
  }

  Future<List<Product>> listMyProducts(Session session) async {
    final vendor = await _access.requireOwnedVendor(session);
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
    String? materials,
    double? widthCm,
    double? depthCm,
    double? heightCm,
    double? weightKg,
    String? assemblyNote,
    String? careInstructions,
    String? warranty,
    String? model3dUrl,
    String? thumbnailUrl,
    List<String>? viewImageUrls,
  }) async {
    final vendor = await _access.requireOwnedVendor(session);
    if (name.trim().isEmpty || description.trim().isEmpty) {
      throw PlaceifyException(
        message: 'Name and description are required.',
        code: 'INVALID_PRODUCT',
      );
    }
    if (price <= 0) {
      throw PlaceifyException(
        message: 'Price must be positive.',
        code: 'INVALID_PRICE',
      );
    }

    final trimmedMaterials = materials?.trim();
    if (trimmedMaterials == null || trimmedMaterials.isEmpty) {
      throw PlaceifyException(
        message: 'Materials are required.',
        code: 'INVALID_MATERIALS',
      );
    }

    if (widthCm == null || depthCm == null || heightCm == null) {
      throw PlaceifyException(
        message: 'Product dimensions are required.',
        code: 'INVALID_DIMENSIONS',
      );
    }
    if (widthCm <= 0 || depthCm <= 0 || heightCm <= 0) {
      throw PlaceifyException(
        message: 'Dimensions must be positive.',
        code: 'INVALID_DIMENSIONS',
      );
    }

    final trimmedCare = careInstructions?.trim();
    if (trimmedCare == null || trimmedCare.isEmpty) {
      throw PlaceifyException(
        message: 'Care instructions are required.',
        code: 'INVALID_CARE',
      );
    }

    var resolvedCategoryId = categoryId;
    if (resolvedCategoryId == null) {
      final defaultCategory = await Category.db.findFirstRow(
        session,
        where: (row) => row.name.equals('chairs'),
      );
      resolvedCategoryId = defaultCategory?.id;
    }

    return Product.db.insertRow(
      session,
      Product(
        vendorId: vendor.id!,
        categoryId: resolvedCategoryId,
        name: name.trim(),
        description: description.trim(),
        price: price,
        materials: trimmedMaterials,
        widthCm: widthCm,
        depthCm: depthCm,
        heightCm: heightCm,
        weightKg: weightKg,
        assemblyNote: assemblyNote?.trim(),
        careInstructions: trimmedCare,
        warranty: warranty?.trim(),
        model3dUrl: model3dUrl?.trim(),
        thumbnailUrl: thumbnailUrl?.trim(),
        viewImageUrls: VendorProductImageStorage.normalizeViewImageUrls(
          viewImageUrls,
        ),
        status: ProductStatus.active,
      ),
    );
  }

  /// Creates or updates a product. When [input.productId] is set, updates that
  /// product; a photo is optional on update (empty [imageData] keeps the current
  /// thumbnail). New products require a photo.
  Future<Product> uploadProduct(
    Session session,
    VendorProductUploadInput input,
    ByteData imageData,
    String imageFileName,
  ) async {
    await _access.requireOwnedVendor(session);

    final existingProductId = input.productId;
    if (existingProductId != null) {
      return _updateExistingProduct(
        session,
        existingProductId,
        input,
        imageData,
        imageFileName,
      );
    }

    if (imageData.lengthInBytes == 0) {
      throw PlaceifyException(
        message: 'Product photo is required.',
        code: 'INVALID_FILE',
      );
    }

    final thumbnailUrl = await _images.persistProductImage(
      session,
      imageData,
      imageFileName,
      removeBackground: true,
    );

    var product = await createProduct(
      session,
      input.name,
      input.description,
      input.price,
      categoryId: input.categoryId,
      materials: input.materials,
      widthCm: input.widthCm,
      depthCm: input.depthCm,
      heightCm: input.heightCm,
      weightKg: input.weightKg,
      assemblyNote: input.assemblyNote,
      careInstructions: input.careInstructions,
      warranty: input.warranty,
      thumbnailUrl: thumbnailUrl,
    );

    product = await Product.db.updateRow(
      session,
      withPricing(
        product: product,
        listPrice: input.price,
        discountPrice: input.discountPrice,
        discountPercentage: input.discountPercentage,
        featured: input.featured,
      ),
    );

    if (input.generateModel3d) {
      product = await _queueProductModel3dGeneration(session, product);
    }

    final loaded = await _loadProductWithCategory(session, product);
    await dispatchProductEvents(
      session,
      loaded,
      (await _access.requireOwnedVendor(session)).id!,
      created: true,
    );
    return loaded;
  }

  Future<Product> _updateExistingProduct(
    Session session,
    int productId,
    VendorProductUploadInput input,
    ByteData imageData,
    String imageFileName,
  ) async {
    final vendor = await _access.requireOwnedVendor(session);
    final product = await Product.db.findById(session, productId);
    if (product == null || product.vendorId != vendor.id) {
      throw PlaceifyException(
        message: 'Product not found.',
        code: 'PRODUCT_NOT_FOUND',
      );
    }

    if (input.name.trim().isEmpty || input.description.trim().isEmpty) {
      throw PlaceifyException(
        message: 'Name and description are required.',
        code: 'INVALID_PRODUCT',
      );
    }
    if (input.price <= 0) {
      throw PlaceifyException(
        message: 'Price must be positive.',
        code: 'INVALID_PRICE',
      );
    }

    final trimmedMaterials = input.materials.trim();
    if (trimmedMaterials.isEmpty) {
      throw PlaceifyException(
        message: 'Materials are required.',
        code: 'INVALID_MATERIALS',
      );
    }

    if (input.widthCm <= 0 || input.depthCm <= 0 || input.heightCm <= 0) {
      throw PlaceifyException(
        message: 'Dimensions must be positive.',
        code: 'INVALID_DIMENSIONS',
      );
    }

    final trimmedCare = input.careInstructions.trim();
    if (trimmedCare.isEmpty) {
      throw PlaceifyException(
        message: 'Care instructions are required.',
        code: 'INVALID_CARE',
      );
    }

    var resolvedCategoryId = input.categoryId ?? product.categoryId;
    if (resolvedCategoryId == null) {
      final defaultCategory = await Category.db.findFirstRow(
        session,
        where: (row) => row.name.equals('chairs'),
      );
      resolvedCategoryId = defaultCategory?.id;
    }

    var thumbnailUrl = product.thumbnailUrl;
    if (imageData.lengthInBytes > 0) {
      thumbnailUrl = await _images.persistProductImage(
        session,
        imageData,
        imageFileName,
        removeBackground: true,
      );
    }

    var updated = await Product.db.updateRow(
      session,
      withPricing(
        product: product.copyWith(
          categoryId: resolvedCategoryId,
          name: input.name.trim(),
          description: input.description.trim(),
          materials: trimmedMaterials,
          widthCm: input.widthCm,
          depthCm: input.depthCm,
          heightCm: input.heightCm,
          weightKg: input.weightKg,
          assemblyNote: input.assemblyNote?.trim(),
          careInstructions: trimmedCare,
          warranty: input.warranty?.trim(),
          thumbnailUrl: thumbnailUrl?.trim(),
          viewImageUrls: input.viewImageUrls != null
              ? VendorProductImageStorage.normalizeViewImageUrls(
                  input.viewImageUrls,
                )
              : product.viewImageUrls,
          status: input.isActive ? ProductStatus.active : ProductStatus.removed,
          removedReason: input.isActive
              ? (product.removedById == null ? null : product.removedReason)
              : 'Hidden by vendor',
          removedById: input.isActive ? product.removedById : null,
          removedAt: input.isActive
              ? (product.removedById == null ? null : product.removedAt)
              : DateTime.now(),
        ),
        listPrice: input.price,
        discountPrice: input.discountPrice,
        discountPercentage: input.discountPercentage,
        featured: input.featured,
      ),
    );

    if (input.generateModel3d) {
      updated = await _queueProductModel3dGeneration(session, updated);
    }

    final loaded = await _loadProductWithCategory(session, updated);
    await dispatchProductEvents(
      session,
      loaded,
      vendor.id!,
      created: false,
    );
    return loaded;
  }

  Future<Product> _loadProductWithCategory(
    Session session,
    Product product,
  ) async {
    final productId = product.id;
    if (productId == null) return product;

    final loaded = await Product.db.findById(
      session,
      productId,
      include: Product.include(category: Category.include()),
    );
    return loaded ?? product;
  }

  /// Marks [product] as building and starts Tripo generation in the background.
  Future<Product> _queueProductModel3dGeneration(
    Session session,
    Product product,
  ) async {
    final productId = product.id;
    if (productId == null) return product;

    final now = DateTime.now();
    final building = await Product.db.updateRow(
      session,
      product.copyWith(
        model3dStatus: ProductModel3dStatus.building,
        model3dError: null,
        updatedAt: now,
      ),
    );

    // Run off the request session so regenerate returns immediately and
    // cannot fail the HTTP call if scheduling/background setup has issues.
    unawaited(
      runProduct3dGenerationInBackground(session.serverpod, productId),
    );

    session.log(
      'Started background Tripo generation for product $productId',
      level: LogLevel.info,
    );

    return building;
  }

  /// Starts Tripo 3D generation in the background and returns immediately.
  ///
  /// Sets [Product.model3dStatus] to building, enqueues a FutureCall, and
  /// returns so the vendor is not blocked on the HTTP request. The GLB URL is
  /// written when the job finishes (keeps any existing [Product.model3dUrl]
  /// until then so shoppers still see the previous model during regenerate).
  Future<Product> regenerateProductModel3d(
    Session session,
    int productId,
  ) async {
    final vendor = await _access.requireOwnedVendor(session);
    final product = await Product.db.findById(session, productId);
    if (product == null || product.vendorId != vendor.id) {
      throw PlaceifyException(
        message: 'Product not found.',
        code: 'PRODUCT_NOT_FOUND',
      );
    }

    final building = await _queueProductModel3dGeneration(session, product);
    return _loadProductWithCategory(session, building);
  }

  Future<Product> updateProductThumbnail(
    Session session,
    int productId,
    String thumbnailUrl,
  ) async {
    final vendor = await _access.requireVendorProfile(session);
    final product = await Product.db.findById(session, productId);
    if (product == null || product.vendorId != vendor.id) {
      throw PlaceifyException(
        message: 'Product not found.',
        code: 'PRODUCT_NOT_FOUND',
      );
    }

    return Product.db.updateRow(
      session,
      product.copyWith(thumbnailUrl: thumbnailUrl.trim()),
    );
  }

  Future<String> uploadProductImage(
    Session session,
    ByteData fileData,
    String fileName, {
    bool removeBackground = false,
  }) async {
    await _access.requireOwnedVendor(session);
    return _images.persistProductImage(
      session,
      fileData,
      fileName,
      removeBackground: removeBackground,
    );
  }

  Future<Product> deleteProduct(Session session, int productId) async {
    final product = await _requireMutableProduct(session, productId);
    if (product.isDeleted) return product;

    final now = DateTime.now();
    return Product.db.updateRow(
      session,
      product.copyWith(
        isDeleted: true,
        deletedAt: now,
        updatedAt: now,
      ),
    );
  }

  Future<Product> restoreProduct(Session session, int productId) async {
    final product = await _requireMutableProduct(session, productId);
    if (!product.isDeleted && product.status == ProductStatus.active) {
      return product;
    }

    final now = DateTime.now();
    return Product.db.updateRow(
      session,
      product.copyWith(
        isDeleted: false,
        deletedAt: null,
        status: ProductStatus.active,
        updatedAt: now,
      ),
    );
  }

  Future<Product> archiveProduct(Session session, int productId) async {
    final product = await _requireMutableProduct(session, productId);
    final now = DateTime.now();
    return Product.db.updateRow(
      session,
      product.copyWith(
        status: ProductStatus.removed,
        updatedAt: now,
      ),
    );
  }

  Future<Product> _requireMutableProduct(
    Session session,
    int productId,
  ) async {
    final product = await Product.db.findById(session, productId);
    if (product == null) {
      throw PlaceifyException(
        message: 'Product not found.',
        code: 'PRODUCT_NOT_FOUND',
      );
    }

    final user = await SessionService.requireUser(session);
    if (user.role == UserRole.admin) {
      return product;
    }

    final vendor = await _access.requireOwnedVendor(session);
    if (product.vendorId != vendor.id) {
      throw PlaceifyException(
        message: 'Product not found.',
        code: 'PRODUCT_NOT_FOUND',
      );
    }
    return product;
  }
}
