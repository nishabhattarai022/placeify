import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:placeify/features/home/data/mock_product_repository.dart';
import 'package:placeify/features/profile/presentation/widgets/shared/profile_form_field.dart';
import 'package:placeify/features/vendor/domain/models/vendor_product_form_state.dart';
import 'package:placeify/features/vendor/presentation/providers/vendor_product_form_provider.dart';
import 'package:placeify/features/vendor/presentation/widgets/product_image_picker_grid.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radii.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/services/haptic_service.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/animated_scale_tap.dart';
import '../../../core/widgets/toast_overlay.dart';

class VendorProductFormScreen extends ConsumerStatefulWidget {
  const VendorProductFormScreen({
    super.key,
    this.productId,
  });

  final String? productId;

  @override
  ConsumerState<VendorProductFormScreen> createState() =>
      _VendorProductFormScreenState();
}

class _VendorProductFormScreenState extends ConsumerState<VendorProductFormScreen> {
  bool _isDirty = false;

  final _formKey = GlobalKey<FormState>();
  final _nameKey = GlobalKey<FormFieldState<String>>();
  final _skuKey = GlobalKey<FormFieldState<String>>();
  final _categoryKey = GlobalKey<FormFieldState<String>>();
  final _listPriceKey = GlobalKey<FormFieldState<String>>();
  final _stockKey = GlobalKey<FormFieldState<String>>();

  late final TextEditingController _name;
  late final TextEditingController _description;
  late final TextEditingController _brand;
  late final TextEditingController _sku;
  late final TextEditingController _materials;
  late final TextEditingController _listPrice;
  late final TextEditingController _discountPercent;
  late final TextEditingController _offerLabel;
  late final TextEditingController _width;
  late final TextEditingController _height;
  late final TextEditingController _depth;
  late final TextEditingController _weight;
  late final TextEditingController _stock;
  late final TextEditingController _lowStockThreshold;

  @override
  void initState() {
    super.initState();
    final form = ref.read(vendorProductFormProvider);
    _name = TextEditingController(text: form.name);
    _description = TextEditingController(text: form.description);
    _brand = TextEditingController(text: form.brand);
    _sku = TextEditingController(text: form.sku);
    _materials = TextEditingController(text: form.materials);
    _listPrice = TextEditingController(text: form.listPrice);
    _discountPercent = TextEditingController(text: form.discountPercent);
    _offerLabel = TextEditingController(text: form.offerLabel);
    _width = TextEditingController(text: form.width);
    _height = TextEditingController(text: form.height);
    _depth = TextEditingController(text: form.depth);
    _weight = TextEditingController(text: form.weight);
    _stock = TextEditingController(text: form.stock);
    _lowStockThreshold = TextEditingController(text: form.lowStockThreshold);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref
          .read(vendorProductFormProvider.notifier)
          .prepareForRoute(productId: widget.productId);
      if (mounted) {
        _syncControllersFromState(ref.read(vendorProductFormProvider));
      }
    });
  }

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    _brand.dispose();
    _sku.dispose();
    _materials.dispose();
    _listPrice.dispose();
    _discountPercent.dispose();
    _offerLabel.dispose();
    _width.dispose();
    _height.dispose();
    _depth.dispose();
    _weight.dispose();
    _stock.dispose();
    _lowStockThreshold.dispose();
    super.dispose();
  }

  void _syncControllersFromState(VendorProductFormState form) {
    void setIfDifferent(TextEditingController controller, String value) {
      if (controller.text != value) {
        controller.value = controller.value.copyWith(
          text: value,
          selection: TextSelection.collapsed(offset: value.length),
        );
      }
    }

    setIfDifferent(_name, form.name);
    setIfDifferent(_description, form.description);
    setIfDifferent(_brand, form.brand);
    setIfDifferent(_sku, form.sku);
    setIfDifferent(_materials, form.materials);
    setIfDifferent(_listPrice, form.listPrice);
    setIfDifferent(_discountPercent, form.discountPercent);
    setIfDifferent(_offerLabel, form.offerLabel);
    setIfDifferent(_width, form.width);
    setIfDifferent(_height, form.height);
    setIfDifferent(_depth, form.depth);
    setIfDifferent(_weight, form.weight);
    setIfDifferent(_stock, form.stock);
    setIfDifferent(_lowStockThreshold, form.lowStockThreshold);
  }

  void _flushControllersToNotifier() {
    final notifier = ref.read(vendorProductFormProvider.notifier);
    notifier.update(
      (state) => state.copyWith(
        name: _name.text,
        description: _description.text,
        brand: _brand.text,
        sku: _sku.text,
        materials: _materials.text,
        listPrice: _listPrice.text,
        discountPercent: _discountPercent.text,
        offerLabel: _offerLabel.text,
        width: _width.text,
        height: _height.text,
        depth: _depth.text,
        weight: _weight.text,
        stock: _stock.text,
        lowStockThreshold: _lowStockThreshold.text,
      ),
    );
  }

  void _scrollToFirstError() {
    final keys = [
      _nameKey,
      _skuKey,
      _categoryKey,
      _listPriceKey,
      _stockKey,
    ];
    for (final key in keys) {
      final fieldState = key.currentState;
      if (fieldState != null && fieldState.hasError) {
        Scrollable.ensureVisible(
          fieldState.context,
          alignment: 0.2,
          duration: const Duration(milliseconds: 300),
        );
        return;
      }
    }
  }

  Future<void> _onUpload() async {
    _flushControllersToNotifier();
    if (!(_formKey.currentState?.validate() ?? false)) {
      _scrollToFirstError();
      return;
    }

    final success = await ref.read(vendorProductFormProvider.notifier).submit();
    if (!mounted) return;

    if (success) {
      PlaceifyToast.show(
        context,
        widget.productId == null
            ? 'Product uploaded successfully'
            : 'Product updated successfully',
      );
      context.pop();
      return;
    }

    final error = ref.read(vendorProductFormProvider).submitError;
    if (error != null) {
      PlaceifyToast.show(context, error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final form = ref.watch(vendorProductFormProvider);
    final notifier = ref.read(vendorProductFormProvider.notifier);

    ref.listen<VendorProductFormState>(vendorProductFormProvider, (previous, next) {
      if (previous?.dimensionUnit != next.dimensionUnit ||
          previous?.editingProductId != next.editingProductId) {
        _syncControllersFromState(next);
      }
    });

    final isEditing = form.isEditing;
    final unitLabel =
        form.dimensionUnit == VendorProductDimensionUnit.cm ? 'cm' : 'in';

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          color: AppColors.espresso,
          onPressed: () => context.pop(),
        ),
        title: Text(
          isEditing ? 'Edit Product' : 'Upload Product',
          style: AppTypography.sectionTitle,
        ),
      ),
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                const Text(
                  'Product details',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.espresso,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  isEditing
                      ? 'Update pricing, inventory, and listing details.'
                      : 'Add a new product to your store catalog.',
                  style: AppTypography.bodyLight.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 20),
                const ProductImagePickerGrid(),
                const SizedBox(height: 20),
                ProfileFormField(
                  label: 'Product Name',
                  child: ProfileTextInput(
                    fieldKey: _nameKey,
                    controller: _name,
                    hint: 'e.g. Harmony Chair',
                    validator: (value) =>
                        value == null || value.trim().isEmpty
                            ? 'Enter a product name'
                            : null,
                    onChanged: (value) => notifier.update(
                      (state) => state.copyWith(name: value),
                    ),
                  ),
                ),
                ProfileFormField(
                  label: 'Description',
                  child: ProfileTextInput(
                    controller: _description,
                    hint: 'Describe materials, comfort, and key features',
                    maxLines: 4,
                    onChanged: (value) => notifier.update(
                      (state) => state.copyWith(description: value),
                    ),
                  ),
                ),
                ProfileFormField(
                  label: 'Brand',
                  child: ProfileTextInput(
                    controller: _brand,
                    hint: 'e.g. Oak & Linen Co.',
                    onChanged: (value) => notifier.update(
                      (state) => state.copyWith(brand: value),
                    ),
                  ),
                ),
                ProfileFormField(
                  label: 'SKU',
                  child: ProfileTextInput(
                    fieldKey: _skuKey,
                    controller: _sku,
                    hint: 'HH-CHR-001',
                    validator: (value) =>
                        value == null || value.trim().isEmpty ? 'Enter a SKU' : null,
                    onChanged: (value) => notifier.update(
                      (state) => state.copyWith(sku: value),
                    ),
                  ),
                ),
                ProfileFormField(
                  label: 'Category',
                  child: FormField<String>(
                    key: _categoryKey,
                    validator: (_) => ref.read(vendorProductFormProvider).categoryId.isEmpty
                        ? 'Select a category'
                        : null,
                    builder: (field) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _CategoryPicker(
                          categoryId: form.categoryId,
                          hasError: field.hasError,
                          onChanged: (categoryId) {
                            field.didChange(categoryId);
                            notifier.update(
                              (state) => state.copyWith(categoryId: categoryId),
                            );
                          },
                        ),
                        if (field.hasError)
                          Padding(
                            padding: const EdgeInsets.only(top: 6, left: 4),
                            child: Text(
                              field.errorText!,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.red,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                ProfileFormField(
                  label: 'Materials',
                  child: ProfileTextInput(
                    controller: _materials,
                    hint: 'e.g. Solid oak, linen upholstery',
                    onChanged: (value) => notifier.update(
                      (state) => state.copyWith(materials: value),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Pricing',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.espresso,
                  ),
                ),
                const SizedBox(height: 14),
                ProfileFormField(
                  label: 'List Price (NPR)',
                  child: ProfileTextInput(
                    fieldKey: _listPriceKey,
                    controller: _listPrice,
                    hint: '12500',
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                    ],
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Enter a list price';
                      }
                      final parsed = double.tryParse(value.trim());
                      if (parsed == null || parsed <= 0) {
                        return 'Enter a valid list price';
                      }
                      return null;
                    },
                    onChanged: (value) => notifier.update(
                      (state) => state.copyWith(listPrice: value),
                    ),
                  ),
                ),
                ProfileFormField(
                  label: 'Discount %',
                  child: ProfileTextInput(
                    controller: _discountPercent,
                    hint: '0',
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                    ],
                    onChanged: (value) => notifier.update(
                      (state) => state.copyWith(discountPercent: value),
                    ),
                  ),
                ),
                ProfileFormField(
                  label: 'Offer Label',
                  child: ProfileTextInput(
                    controller: _offerLabel,
                    hint: 'e.g. Summer Sale, Limited Offer',
                    onChanged: (value) => notifier.update(
                      (state) => state.copyWith(offerLabel: value),
                    ),
                  ),
                ),
                ListenableBuilder(
                  listenable: Listenable.merge([
                    _listPrice,
                    _discountPercent,
                  ]),
                  builder: (context, _) {
                    final salePrice = ref.read(vendorProductFormProvider).computedSalePrice;
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.warmWhite,
                        borderRadius: AppRadii.md,
                        border: Border.all(color: AppColors.creamDark, width: 1.5),
                      ),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'SALE PRICE',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.espresso,
                                letterSpacing: 0.07 * 12,
                              ),
                            ),
                          ),
                          Text(
                            Formatters.currencyFull(salePrice),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.accent,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Dimensions',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.espresso,
                        ),
                      ),
                    ),
                    _DimensionUnitToggle(
                      unit: form.dimensionUnit,
                      onChanged: notifier.toggleDimensionUnit,
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: ProfileFormField(
                        label: 'Width ($unitLabel)',
                        child: ProfileTextInput(
                          controller: _width,
                          hint: '0',
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[0-9.]'),
                            ),
                          ],
                          onChanged: (value) => notifier.update(
                            (state) => state.copyWith(width: value),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ProfileFormField(
                        label: 'Height ($unitLabel)',
                        child: ProfileTextInput(
                          controller: _height,
                          hint: '0',
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[0-9.]'),
                            ),
                          ],
                          onChanged: (value) => notifier.update(
                            (state) => state.copyWith(height: value),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                ProfileFormField(
                  label: 'Depth ($unitLabel)',
                  child: ProfileTextInput(
                    controller: _depth,
                    hint: '0',
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                    ],
                    onChanged: (value) => notifier.update(
                      (state) => state.copyWith(depth: value),
                    ),
                  ),
                ),
                ProfileFormField(
                  label: 'Weight (kg)',
                  child: ProfileTextInput(
                    controller: _weight,
                    hint: '0',
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                    ],
                    onChanged: (value) => notifier.update(
                      (state) => state.copyWith(weight: value),
                    ),
                  ),
                ),
                ProfileFormField(
                  label: 'Stock Quantity',
                  child: ProfileTextInput(
                    fieldKey: _stockKey,
                    controller: _stock,
                    hint: '0',
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Enter a stock quantity';
                      }
                      final parsed = int.tryParse(value.trim());
                      if (parsed == null || parsed < 0) {
                        return 'Enter a valid stock quantity';
                      }
                      return null;
                    },
                    onChanged: (value) => notifier.update(
                      (state) => state.copyWith(stock: value),
                    ),
                  ),
                ),
                ProfileFormField(
                  label: 'Low Stock Threshold',
                  child: ProfileTextInput(
                    controller: _lowStockThreshold,
                    hint: '5',
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (value) => notifier.update(
                      (state) => state.copyWith(lowStockThreshold: value),
                    ),
                  ),
                ),
                _FormSwitchRow(
                  label: 'AR View Available',
                  subtitle: 'Allow customers to preview this product in AR',
                  value: form.hasArView,
                  onChanged: (value) => notifier.update(
                    (state) => state.copyWith(hasArView: value),
                  ),
                ),
                _FormSwitchRow(
                  label: 'Visible in Store',
                  subtitle: 'Hidden products stay in your catalog but are not listed',
                  value: form.isActive,
                  onChanged: (value) => notifier.update(
                    (state) => state.copyWith(isActive: value),
                  ),
                ),
                  ],
                ),
              ),
            ),
          ),
          _UploadBottomBar(
            label: isEditing
                ? (_isDirty ? 'Save Changes' : 'No Changes')
                : 'Upload Product',
            muted: isEditing && !_isDirty,
            isLoading: form.isSubmitting,
            onTap: form.isSubmitting ? null : _onUpload,
          ),
        ],
      ),
    );
  }
}

class _UploadBottomBar extends StatelessWidget {
  const _UploadBottomBar({
    required this.label,
    required this.isLoading,
    this.muted = false,
    this.onTap,
  });

  final String label;
  final bool isLoading;
  final bool muted;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final pill = Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.vendorForest,
        borderRadius: BorderRadius.circular(999),
      ),
      alignment: Alignment.center,
      child: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : Text(
              label,
              style: GoogleFonts.dmSans(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: Colors.white,
              ),
            ),
    );

    return Container(
      color: AppColors.cream,
      padding: EdgeInsets.fromLTRB(18, 8, 18, 24 + bottomInset),
      child: AnimatedScaleTap(
        onTap: onTap,
        child: muted ? Opacity(opacity: 0.5, child: pill) : pill,
      ),
    );
  }
}

class _CategoryPicker extends StatelessWidget {
  const _CategoryPicker({
    required this.categoryId,
    required this.onChanged,
    this.hasError = false,
  });

  final String categoryId;
  final ValueChanged<String> onChanged;
  final bool hasError;

  String get _label {
    if (categoryId.isEmpty) return 'Select a category';
    for (final category in MockProductRepository.categories) {
      if (category.id == categoryId) return category.label;
    }
    return categoryId;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        HapticService.light();
        final selected = await showModalBottomSheet<String>(
          context: context,
          backgroundColor: AppColors.warmWhite,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (sheetContext) {
            return SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Select category',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.espresso,
                        ),
                      ),
                    ),
                  ),
                  for (final category in MockProductRepository.categories)
                    ListTile(
                      title: Text(category.label),
                      trailing: categoryId == category.id
                          ? const Icon(Icons.check, color: AppColors.accent)
                          : null,
                      onTap: () => Navigator.pop(sheetContext, category.id),
                    ),
                ],
              ),
            );
          },
        );

        if (selected != null) {
          onChanged(selected);
        }
      },
      borderRadius: AppRadii.md,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        decoration: BoxDecoration(
          color: AppColors.cream,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: hasError ? Colors.red : AppColors.creamDark,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                _label,
                style: TextStyle(
                  fontSize: 14,
                  color: categoryId.isEmpty
                      ? AppColors.textMuted
                      : AppColors.espresso,
                ),
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down,
              color: AppColors.espresso,
            ),
          ],
        ),
      ),
    );
  }
}

class _DimensionUnitToggle extends StatelessWidget {
  const _DimensionUnitToggle({
    required this.unit,
    required this.onChanged,
  });

  final VendorProductDimensionUnit unit;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: AppColors.warmWhite,
        borderRadius: AppRadii.pill,
        border: Border.all(color: AppColors.creamDark, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _UnitButton(
            label: 'cm',
            selected: unit == VendorProductDimensionUnit.cm,
            onTap: () {
              if (unit != VendorProductDimensionUnit.cm) onChanged();
            },
          ),
          _UnitButton(
            label: 'in',
            selected: unit == VendorProductDimensionUnit.inch,
            onTap: () {
              if (unit != VendorProductDimensionUnit.inch) onChanged();
            },
          ),
        ],
      ),
    );
  }
}

class _UnitButton extends StatelessWidget {
  const _UnitButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticService.selection();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? AppColors.espresso : Colors.transparent,
          borderRadius: AppRadii.pill,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _FormSwitchRow extends StatelessWidget {
  const _FormSwitchRow({
    required this.label,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.warmWhite,
          borderRadius: AppRadii.md,
          border: Border.all(color: AppColors.creamDark, width: 1.5),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.espresso,
                      letterSpacing: 0.07 * 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTypography.bodyLight.copyWith(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
            Switch.adaptive(
              value: value,
              activeTrackColor: AppColors.vendorForest,
              onChanged: (next) {
                HapticService.selection();
                onChanged(next);
              },
            ),
          ],
        ),
      ),
    );
  }
}
