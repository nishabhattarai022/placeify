import 'vendor_product_image_item.dart';

enum VendorProductDimensionUnit { cm, inch }

/// Draft state for the vendor product upload/edit form.
class VendorProductFormState {
  const VendorProductFormState({
    this.editingProductId,
    this.name = '',
    this.description = '',
    this.brand = '',
    this.sku = '',
    this.categoryId = '',
    this.materials = '',
    this.listPrice = '',
    this.discountPercent = '',
    this.offerLabel = '',
    this.width = '',
    this.height = '',
    this.depth = '',
    this.weight = '',
    this.stock = '',
    this.dimensionUnit = VendorProductDimensionUnit.cm,
    this.hasArView = false,
    this.isActive = true,
    this.isSubmitting = false,
    this.submitError,
    this.images = const [],
  });

  factory VendorProductFormState.initial() => const VendorProductFormState();

  static const cmPerInch = 2.54;

  final String? editingProductId;
  final String name;
  final String description;
  final String brand;
  final String sku;
  final String categoryId;
  final String materials;
  final String listPrice;
  final String discountPercent;
  final String offerLabel;
  final String width;
  final String height;
  final String depth;
  final String weight;
  final String stock;
  final VendorProductDimensionUnit dimensionUnit;
  final bool hasArView;
  final bool isActive;
  final bool isSubmitting;
  final String? submitError;
  final List<VendorProductImageItem> images;

  static const maxImages = 8;

  bool get isEditing => editingProductId != null;

  double? get parsedListPrice => _parsePositive(listPrice);

  double get parsedDiscountPercent {
    final value = double.tryParse(discountPercent.trim());
    if (value == null) return 0;
    return value.clamp(0, 100);
  }

  double get computedSalePrice {
    final list = parsedListPrice;
    if (list == null || list <= 0) return 0;
    return list * (1 - parsedDiscountPercent / 100);
  }

  VendorProductFormState copyWith({
    String? editingProductId,
    bool clearEditingProductId = false,
    String? name,
    String? description,
    String? brand,
    String? sku,
    String? categoryId,
    String? materials,
    String? listPrice,
    String? discountPercent,
    String? offerLabel,
    String? width,
    String? height,
    String? depth,
    String? weight,
    String? stock,
    VendorProductDimensionUnit? dimensionUnit,
    bool? hasArView,
    bool? isActive,
    bool? isSubmitting,
    String? submitError,
    bool clearSubmitError = false,
    List<VendorProductImageItem>? images,
  }) {
    return VendorProductFormState(
      editingProductId: clearEditingProductId
          ? null
          : (editingProductId ?? this.editingProductId),
      name: name ?? this.name,
      description: description ?? this.description,
      brand: brand ?? this.brand,
      sku: sku ?? this.sku,
      categoryId: categoryId ?? this.categoryId,
      materials: materials ?? this.materials,
      listPrice: listPrice ?? this.listPrice,
      discountPercent: discountPercent ?? this.discountPercent,
      offerLabel: offerLabel ?? this.offerLabel,
      width: width ?? this.width,
      height: height ?? this.height,
      depth: depth ?? this.depth,
      weight: weight ?? this.weight,
      stock: stock ?? this.stock,
      dimensionUnit: dimensionUnit ?? this.dimensionUnit,
      hasArView: hasArView ?? this.hasArView,
      isActive: isActive ?? this.isActive,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitError: clearSubmitError ? null : (submitError ?? this.submitError),
      images: images ?? this.images,
    );
  }

  static double displayToCm(double value, VendorProductDimensionUnit unit) {
    return unit == VendorProductDimensionUnit.inch
        ? value * cmPerInch
        : value;
  }

  static double cmToDisplay(double cm, VendorProductDimensionUnit unit) {
    return unit == VendorProductDimensionUnit.inch ? cm / cmPerInch : cm;
  }

  static String formatDimension(double value) {
    if (value == value.roundToDouble()) {
      return value.round().toString();
    }
    return value.toStringAsFixed(1);
  }

  static String convertDimensionString(
    String value,
    VendorProductDimensionUnit from,
    VendorProductDimensionUnit to,
  ) {
    if (from == to) return value;
    final trimmed = value.trim();
    if (trimmed.isEmpty) return value;

    final parsed = double.tryParse(trimmed);
    if (parsed == null) return value;

    final cm = displayToCm(parsed, from);
    return formatDimension(cmToDisplay(cm, to));
  }

  static double? _parsePositive(String value) {
    final parsed = double.tryParse(value.trim());
    if (parsed == null || parsed < 0) return null;
    return parsed;
  }
}
