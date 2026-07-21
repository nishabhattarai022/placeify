import 'package:image_picker/image_picker.dart';
import 'package:placeify_flutter/core/services/background_removal_service.dart';
import 'package:placeify_flutter/core/utils/local_image_store.dart';
import 'package:placeify_flutter/features/auth/presentation/providers/auth_provider.dart';
import 'package:placeify_flutter/features/vendor/data/mock_vendor_product_repository.dart'
    show VendorProductActionException;
import 'package:placeify_flutter/features/vendor/domain/models/vendor_product.dart';
import 'package:placeify_flutter/features/vendor/domain/models/vendor_product_form_state.dart';
import 'package:placeify_flutter/features/vendor/domain/models/vendor_product_image_item.dart';
import 'package:placeify_flutter/features/vendor/presentation/providers/vendor_products_provider.dart';
import 'package:placeify_flutter/features/vendor/presentation/providers/vendor_profile_provider.dart';
import 'package:placeify_flutter/features/vendor/presentation/providers/background_removal_cache_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'vendor_product_form_provider.g.dart';

@Riverpod(keepAlive: true)
class VendorProductForm extends _$VendorProductForm {
  @override
  VendorProductFormState build() => VendorProductFormState.initial();

  void update(VendorProductFormState Function(VendorProductFormState current) updater) {
    state = updater(state);
  }

  void resetDraft() {
    state = VendorProductFormState.initial();
  }

  Future<void> prepareForRoute({
    String? productId,
    bool forceReload = false,
  }) async {
    if (productId != null) {
      if (!forceReload && state.editingProductId == productId) return;
      await _loadProduct(productId);
      return;
    }

    if (state.editingProductId != null) {
      state = VendorProductFormState.initial();
    }
  }

  Future<void> _loadProduct(String productId) async {
    final repo = ref.read(vendorProductRepositoryProvider);
    final product = await repo.getProductById(productId);
    if (product == null) {
      state = state.copyWith(
        submitError: 'Product not found.',
      );
      return;
    }

    state = _stateFromProduct(product);
  }

  VendorProductFormState _stateFromProduct(VendorProduct product) {
    final listPrice = product.originalPrice ?? product.price;
    final discount = product.isOnSale
        ? product.discountPercent.toStringAsFixed(0)
        : '';

    return VendorProductFormState(
      editingProductId: product.id,
      name: product.name,
      description: product.description,
      brand: product.brand,
      sku: product.sku,
      categoryId: product.categoryId,
      materials: product.materials,
      warrantyNote: product.warrantyNote,
      shippingNote: product.shippingNote,
      listPrice: _formatNumber(listPrice),
      discountPercent: discount,
      offerLabel: product.offerLabel,
      width: VendorProductFormState.formatDimension(product.widthCm),
      height: VendorProductFormState.formatDimension(product.heightCm),
      depth: VendorProductFormState.formatDimension(product.depthCm),
      weight: product.weightKg > 0
          ? VendorProductFormState.formatDimension(product.weightKg)
          : '',
      stock: product.stock.toString(),
      lowStockThreshold: product.lowStockThreshold.toString(),
      hasArView: product.hasArView,
      isActive: product.isActive,
      images: product.imageUrls
          .map(VendorProductImageItem.fromRemoteUrl)
          .toList(),
    );
  }

  void addLocalImages(List<String> paths) {
    if (paths.isEmpty) return;

    final remaining = VendorProductFormState.maxImages - state.images.length;
    if (remaining <= 0) return;

    final additions = paths
        .take(remaining)
        .map(VendorProductImageItem.fromLocalPath)
        .toList();

    state = state.copyWith(images: [...state.images, ...additions]);
  }

  Future<void> addPickedImages(List<XFile> files) async {
    if (files.isEmpty) return;

    final remaining = VendorProductFormState.maxImages - state.images.length;
    if (remaining <= 0) return;

    final additions = <VendorProductImageItem>[];
    for (final file in files.take(remaining)) {
      final bytes = await file.readAsBytes();
      final rawName = file.name.trim();
      final fileName = rawName.isNotEmpty ? rawName : 'product.jpg';

      // Keep bytes in [LocalImageStore] on every platform. Android gallery
      // paths are often temporary/content URIs that cannot be re-read later.
      final uri = LocalImageStore.register(bytes, fileName);
      additions.add(
        VendorProductImageItem.fromLocalBytes(
          path: uri,
          bytes: bytes,
          fileName: fileName,
        ),
      );
    }

    if (additions.isEmpty) return;
    state = state.copyWith(images: [...state.images, ...additions]);
  }

  void removeImage(String imageId) {
    state = state.copyWith(
      images: state.images.where((image) => image.id != imageId).toList(),
    );
  }

  void reorderImages(int oldIndex, int newIndex) {
    if (oldIndex == newIndex) return;

    var targetIndex = newIndex;
    if (oldIndex < newIndex) {
      targetIndex -= 1;
    }

    final images = List<VendorProductImageItem>.from(state.images);
    if (oldIndex < 0 ||
        oldIndex >= images.length ||
        targetIndex < 0 ||
        targetIndex >= images.length) {
      return;
    }

    final item = images.removeAt(oldIndex);
    images.insert(targetIndex, item);
    state = state.copyWith(images: images);
  }

  void setPrimaryImage(String imageId) {
    final index = state.images.indexWhere((image) => image.id == imageId);
    if (index <= 0) return;
    reorderImages(index, 0);
  }

  void _updateImage(String imageId, VendorProductImageItem Function(VendorProductImageItem) updater) {
    final images = state.images.map((image) {
      if (image.id != imageId) return image;
      return updater(image);
    }).toList();
    state = state.copyWith(images: images);
  }

  Future<String?> removeBackground(String imageId) async {
    final index = state.images.indexWhere((i) => i.id == imageId);
    if (index == -1) return 'Image not found.';
    final image = state.images[index];
    if (!image.isLocal || image.localPath == null) {
      return 'Only local photos support background removal.';
    }

    final cache = ref.read(backgroundRemovalCacheProvider.notifier);
    final cached = cache.getProcessedPath(imageId);
    if (cached != null) {
      _updateImage(
        imageId,
        (item) => item.copyWith(processedLocalPath: cached, clearBgError: true),
      );
      return null;
    }

    _updateImage(
      imageId,
      (item) => item.copyWith(isProcessingBg: true, clearBgError: true),
    );

    final service = BackgroundRemovalService();
    try {
      final result = await service.removeBackground(
        sourcePath: image.localPath!,
        sourceBytes: image.localBytes,
        fileName: image.fileName,
      );
      cache.cache(imageId, result.processedPath);
      _updateImage(
        imageId,
        (item) => item.copyWith(
          processedLocalPath: result.processedPath,
          processedLocalBytes: result.processedBytes,
          isProcessingBg: false,
        ),
      );
      return null;
    } on BackgroundRemovalException catch (e) {
      _updateImage(
        imageId,
        (item) => item.copyWith(
          isProcessingBg: false,
          bgRemovalError: e.message,
        ),
      );
      return e.message;
    } catch (_) {
      _updateImage(
        imageId,
        (item) => item.copyWith(
          isProcessingBg: false,
          bgRemovalError: 'Background removal failed.',
        ),
      );
      return 'Background removal failed.';
    }
  }

  void cancelBackgroundRemoval(String imageId) {
    ref.read(backgroundRemovalCacheProvider.notifier).remove(imageId);
    _updateImage(
      imageId,
      (item) => item.copyWith(clearProcessedPath: true, clearBgError: true),
    );
  }

  void restoreCachedBackgroundRemovals() {
    final cache = ref.read(backgroundRemovalCacheProvider);
    if (cache.isEmpty) return;

    final images = state.images.map((image) {
      final cached = cache[image.id];
      if (cached == null) return image;
      return image.copyWith(processedLocalPath: cached);
    }).toList();
    state = state.copyWith(images: images);
  }

  void toggleDimensionUnit() {
    final current = state.dimensionUnit;
    final next = current == VendorProductDimensionUnit.cm
        ? VendorProductDimensionUnit.inch
        : VendorProductDimensionUnit.cm;

    state = state.copyWith(
      dimensionUnit: next,
      width: VendorProductFormState.convertDimensionString(
        state.width,
        current,
        next,
      ),
      height: VendorProductFormState.convertDimensionString(
        state.height,
        current,
        next,
      ),
      depth: VendorProductFormState.convertDimensionString(
        state.depth,
        current,
        next,
      ),
    );
  }

  String? validate() {
    if (state.name.trim().isEmpty) return 'Enter a product name';
    if (state.sku.trim().isEmpty) return 'Enter a SKU';
    if (state.categoryId.trim().isEmpty) return 'Select a category';
    if (state.materials.trim().isEmpty) return 'Enter product materials';
    if (state.images.length < VendorProductFormState.requiredImages) {
      return 'Add the 4 required photos: front, left, back, right';
    }

    final listPrice = state.parsedListPrice;
    if (listPrice == null || listPrice <= 0) {
      return 'Enter a valid list price';
    }

    if (state.isEditing) {
      final discount = double.tryParse(state.discountPercent.trim());
      if (discount != null && (discount < 0 || discount > 100)) {
        return 'Discount must be between 0 and 100';
      }

      if (state.computedSalePrice <= 0) {
        return 'Sale price must be greater than zero';
      }
    }

    final stock = int.tryParse(state.stock.trim());
    if (stock == null || stock < 0) return 'Enter a valid stock quantity';

    for (final field in [
      (state.width, 'width'),
      (state.height, 'height'),
      (state.depth, 'depth'),
    ]) {
      final value = field.$1.trim();
      if (value.isEmpty) return 'Enter ${field.$2}';
      final parsed = double.tryParse(value);
      if (parsed == null || parsed <= 0) {
        return 'Enter a valid ${field.$2} greater than zero';
      }
    }

    for (final field in [
      (state.width, 'width'),
      (state.height, 'height'),
      (state.depth, 'depth'),
      (state.weight, 'weight'),
    ]) {
      final value = field.$1.trim();
      if (value.isEmpty) continue;
      final parsed = double.tryParse(value);
      if (parsed == null || parsed < 0) {
        return 'Enter a valid ${field.$2}';
      }
    }

    return null;
  }

  Future<VendorProduct?> submit({bool resetOnSuccess = true}) async {
    final validationError = validate();
    if (validationError != null) {
      state = state.copyWith(submitError: validationError);
      return null;
    }

    state = state.copyWith(isSubmitting: true, clearSubmitError: true);

    try {
      final user = await ref.read(currentUserProvider.future);
      final vendorId = user?.vendorId;
      if (vendorId == null) {
        state = state.copyWith(
          isSubmitting: false,
          submitError: 'Vendor account not found.',
        );
        return null;
      }

      VendorProduct? existing;
      if (state.isEditing) {
        final repo = ref.read(vendorProductRepositoryProvider);
        existing = await repo.getProductById(state.editingProductId!);
      }

      final product = _buildProduct(vendorId, existing: existing);
      final productsNotifier = ref.read(vendorProductsProvider.notifier);

      final ({VendorProduct? product, String? error}) result;
      if (state.isEditing) {
        result = await productsNotifier.updateProduct(product);
      } else {
        result = await productsNotifier.createProduct(product);
      }

      if (result.error != null) {
        state = state.copyWith(isSubmitting: false, submitError: result.error);
        return null;
      }

      final saved = result.product;
      if (saved == null) {
        state = state.copyWith(
          isSubmitting: false,
          submitError: 'Could not save product. Try again.',
        );
        return null;
      }

      if (resetOnSuccess) {
        state = VendorProductFormState.initial();
      } else {
        state = state.copyWith(isSubmitting: false, clearSubmitError: true);
      }
      return saved;
    } catch (error) {
      state = state.copyWith(
        isSubmitting: false,
        submitError: _formatSubmitError(error),
      );
      return null;
    }
  }

  String _formatSubmitError(Object error) {
    if (error is VendorProductActionException) return error.message;
    final text = error.toString().replaceFirst('Exception: ', '').trim();
    if (text.contains('Photo file not found')) {
      return 'Photo file not found. Re-pick your product photos and try again.';
    }
    if (text.contains('SocketException') ||
        text.contains('Connection refused') ||
        text.contains('Failed host lookup')) {
      return 'Cannot reach the server. Make sure placeify_server is running '
          'and your phone is on the same Wi‑Fi network.';
    }
    if (text.isNotEmpty && text.length <= 200) return text;
    return 'Could not save product. Try again.';
  }

  VendorProduct _buildProduct(String vendorId, {VendorProduct? existing}) {
    final listPrice = state.parsedListPrice!;

    if (state.isEditing) {
      final salePrice = state.computedSalePrice;
      final hasDiscount = state.parsedDiscountPercent > 0;

      return VendorProduct(
        id: state.editingProductId ?? '',
        vendorId: vendorId,
        name: state.name.trim(),
        sku: state.sku.trim(),
        price: salePrice,
        originalPrice: hasDiscount ? listPrice : null,
        stock: int.parse(state.stock.trim()),
        categoryId: state.categoryId,
        description: state.description.trim(),
        brand: state.brand.trim(),
        offerLabel: state.offerLabel.trim(),
        widthCm: _dimensionToCm(state.width),
        heightCm: _dimensionToCm(state.height),
        depthCm: _dimensionToCm(state.depth),
        weightKg: _optionalDimensionToCm(state.weight),
        hasArView: state.hasArView,
        isActive: state.isActive,
        materials: state.materials.trim(),
        warrantyNote: state.warrantyNote.trim(),
        shippingNote: state.shippingNote.trim(),
        imageUrls: state.images.map((image) => image.displaySource).toList(),
        lowStockThreshold: _parseLowStockThreshold(),
        createdAt: existing?.createdAt ?? DateTime.now(),
      );
    }

    return VendorProduct(
      id: state.editingProductId ?? '',
      vendorId: vendorId,
      name: state.name.trim(),
      sku: state.sku.trim(),
      price: listPrice,
      stock: int.parse(state.stock.trim()),
      categoryId: state.categoryId,
      description: state.description.trim(),
      brand: state.brand.trim(),
      widthCm: _dimensionToCm(state.width),
      heightCm: _dimensionToCm(state.height),
      depthCm: _dimensionToCm(state.depth),
      weightKg: _optionalDimensionToCm(state.weight),
      hasArView: state.hasArView,
      isActive: state.isActive,
      materials: state.materials.trim(),
      warrantyNote: state.warrantyNote.trim(),
      shippingNote: state.shippingNote.trim(),
      imageUrls: state.images.map((image) => image.displaySource).toList(),
      lowStockThreshold: _parseLowStockThreshold(),
      createdAt: existing?.createdAt ?? DateTime.now(),
    );
  }

  int _parseLowStockThreshold() {
    final parsed = int.tryParse(state.lowStockThreshold.trim());
    if (parsed == null || parsed < 0) return 5;
    return parsed;
  }

  double _dimensionToCm(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return 0;
    final parsed = double.parse(trimmed);
    return VendorProductFormState.displayToCm(parsed, state.dimensionUnit);
  }

  double _optionalDimensionToCm(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return 0;
    return double.parse(trimmed);
  }

  String _formatNumber(double value) {
    if (value == value.roundToDouble()) {
      return value.round().toString();
    }
    return value.toStringAsFixed(2);
  }
}
