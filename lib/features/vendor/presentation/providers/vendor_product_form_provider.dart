import 'package:placeify/features/auth/presentation/providers/auth_provider.dart';
import 'package:placeify/features/vendor/data/mock_vendor_product_repository.dart';
import 'package:placeify/features/vendor/domain/models/vendor_product.dart';
import 'package:placeify/features/vendor/domain/models/vendor_product_form_state.dart';
import 'package:placeify/features/vendor/presentation/providers/vendor_products_provider.dart';
import 'package:placeify/features/vendor/presentation/providers/vendor_profile_provider.dart';
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

  Future<void> prepareForRoute({String? productId}) async {
    if (productId != null) {
      if (state.editingProductId == productId) return;
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
      hasArView: product.hasArView,
      isActive: product.isActive,
    );
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

    final listPrice = state.parsedListPrice;
    if (listPrice == null || listPrice <= 0) {
      return 'Enter a valid list price';
    }

    final discount = double.tryParse(state.discountPercent.trim());
    if (discount != null && (discount < 0 || discount > 100)) {
      return 'Discount must be between 0 and 100';
    }

    if (state.computedSalePrice <= 0) {
      return 'Sale price must be greater than zero';
    }

    final stock = int.tryParse(state.stock.trim());
    if (stock == null || stock < 0) return 'Enter a valid stock quantity';

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

  Future<bool> submit() async {
    final validationError = validate();
    if (validationError != null) {
      state = state.copyWith(submitError: validationError);
      return false;
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
        return false;
      }

      final repo = ref.read(vendorProductRepositoryProvider);
      VendorProduct? existing;
      if (state.isEditing) {
        existing = await repo.getProductById(state.editingProductId!);
      }

      final product = _buildProduct(vendorId, existing: existing);

      if (state.isEditing) {
        await repo.updateProduct(vendorId, product);
      } else {
        await repo.createProduct(vendorId, product);
      }

      ref.invalidate(vendorProductsProvider);
      state = VendorProductFormState.initial();
      return true;
    } on VendorProductActionException catch (e) {
      state = state.copyWith(isSubmitting: false, submitError: e.message);
      return false;
    } catch (_) {
      state = state.copyWith(
        isSubmitting: false,
        submitError: 'Could not save product. Try again.',
      );
      return false;
    }
  }

  VendorProduct _buildProduct(String vendorId, {VendorProduct? existing}) {
    final listPrice = state.parsedListPrice!;
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
      imageUrls: existing?.imageUrls ?? const [],
      createdAt: existing?.createdAt ?? DateTime.now(),
    );
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
