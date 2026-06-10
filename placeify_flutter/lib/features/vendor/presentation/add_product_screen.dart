import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radii.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/widgets/form_text_field.dart';
import '../../../core/widgets/toast_overlay.dart';
import '../data/product_image_service.dart';
import '../domain/repositories/vendor_repository.dart';
import 'providers/vendor_dashboard_provider.dart';
import 'widgets/product_photo_picker.dart';
import 'widgets/vendor_form_widgets.dart';

class AddProductScreen extends ConsumerStatefulWidget {
  const AddProductScreen({super.key});

  @override
  ConsumerState<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends ConsumerState<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _materialsController = TextEditingController();
  final _widthController = TextEditingController();
  final _depthController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _assemblyController = TextEditingController();
  final _careController = TextEditingController();
  final _warrantyController = TextEditingController();
  final _imageService = ProductImageService();

  Uint8List? _imageBytes;
  String? _imageFileName;
  bool _isSubmitting = false;
  bool _showPhotoError = false;
  bool _cameraAvailable = true;

  @override
  void initState() {
    super.initState();
    _loadCameraAvailability();
    for (final controller in [
      _nameController,
      _descriptionController,
      _priceController,
      _materialsController,
      _widthController,
      _depthController,
      _heightController,
      _careController,
    ]) {
      controller.addListener(_onFieldChanged);
    }
  }

  void _onFieldChanged() => setState(() {});

  void _loadCameraAvailability() {
    final available = _imageService.supportsCamera();
    if (mounted) setState(() => _cameraAvailable = available);
  }

  void _applyPickedImage(PickedProductImage picked) {
    setState(() {
      _imageBytes = picked.bytes;
      _imageFileName = picked.fileName;
      _showPhotoError = false;
    });
  }

  @override
  void dispose() {
    for (final controller in [
      _nameController,
      _descriptionController,
      _priceController,
      _materialsController,
      _widthController,
      _depthController,
      _heightController,
      _weightController,
      _assemblyController,
      _careController,
      _warrantyController,
    ]) {
      controller
        ..removeListener(_onFieldChanged)
        ..dispose();
    }
    super.dispose();
  }

  Future<void> _pickFromCamera() async {
    if (!_cameraAvailable) {
      if (mounted) {
        PlaceifyToast.show(
          context,
          'No camera on this device — use Gallery to pick a photo',
        );
      }
      return;
    }

    try {
      final picked = await _imageService.pickFromCamera();
      if (picked == null || !mounted) return;
      _applyPickedImage(picked);
    } on CameraPermissionException catch (error) {
      if (!mounted) return;
      if (error.permanentlyDenied) {
        final openSettings = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Camera access needed'),
            content: const Text(
              'Allow camera access in Settings to photograph your products.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Open Settings'),
              ),
            ],
          ),
        );
        if (openSettings == true) {
          await openAppSettings();
        }
      } else {
        PlaceifyToast.show(context, 'Camera permission is required to take photos');
      }
    } catch (_) {
      if (mounted) {
        PlaceifyToast.show(
          context,
          'Could not open camera. Try again or use Gallery.',
        );
      }
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final gallerySupported = _imageService.supportsGallery();
      if (!gallerySupported) {
        if (mounted) {
          PlaceifyToast.show(context, 'Photo picker is not available on this device');
        }
        return;
      }

      final picked = await _imageService.pickFromGallery();
      if (picked == null || !mounted) return;
      _applyPickedImage(picked);
    } catch (_) {
      if (mounted) PlaceifyToast.show(context, 'Could not open gallery');
    }
  }

  void _removeImage() {
    setState(() {
      _imageBytes = null;
      _imageFileName = null;
    });
  }

  bool get _hasPhoto => _imageBytes != null;

  bool get _hasBasics =>
      _nameController.text.trim().isNotEmpty &&
      _descriptionController.text.trim().isNotEmpty;

  bool get _hasSpecs =>
      _materialsController.text.trim().isNotEmpty &&
      _widthController.text.trim().isNotEmpty &&
      _depthController.text.trim().isNotEmpty &&
      _heightController.text.trim().isNotEmpty;

  bool get _hasCare => _careController.text.trim().isNotEmpty;

  bool get _hasValidPrice {
    final parsed = double.tryParse(_priceController.text.trim());
    return parsed != null && parsed > 0;
  }

  double? _parseDimension(String value) => double.tryParse(value.trim());

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_isSubmitting) return;

    if (!_hasPhoto) {
      setState(() => _showPhotoError = true);
      PlaceifyToast.show(context, 'Please add a product photo');
      return;
    }

    final price = double.parse(_priceController.text.trim());
    final width = _parseDimension(_widthController.text)!;
    final depth = _parseDimension(_depthController.text)!;
    final height = _parseDimension(_heightController.text)!;
    final weight = _weightController.text.trim().isEmpty
        ? null
        : _parseDimension(_weightController.text);

    setState(() => _isSubmitting = true);
    try {
      await ref.read(vendorDashboardStateProvider.notifier).addProduct(
            name: _nameController.text.trim(),
            description: _descriptionController.text.trim(),
            price: price,
            materials: _materialsController.text.trim(),
            widthCm: width,
            depthCm: depth,
            heightCm: height,
            careInstructions: _careController.text.trim(),
            imageBytes: _imageBytes!,
            imageFileName: _imageFileName!,
            weightKg: weight,
            assemblyNote: _assemblyController.text.trim().isEmpty
                ? null
                : _assemblyController.text.trim(),
            warranty: _warrantyController.text.trim().isEmpty
                ? null
                : _warrantyController.text.trim(),
          );
      if (!mounted) return;
      PlaceifyToast.show(context, 'Product published to your shop');
      context.pop();
    } on VendorRepositoryException catch (error) {
      if (mounted) PlaceifyToast.show(context, error.message);
    } catch (_) {
      if (mounted) {
        PlaceifyToast.show(
          context,
          'Could not publish this product. Please try again.',
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.espresso),
          onPressed: _isSubmitting ? null : () => context.pop(),
        ),
        title: const Text(
          'New listing',
          style: TextStyle(
            fontFamily: 'Fraunces',
            fontSize: 18,
            color: AppColors.espresso,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenPadding,
                  4,
                  AppSpacing.screenPadding,
                  24,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const VendorScreenHeader(
                        icon: Icons.chair_outlined,
                        title: 'Add a product',
                        subtitle:
                            'Provide accurate details so customers know exactly what they are buying.',
                      ),
                      const SizedBox(height: 16),
                      VendorFormChecklist(
                        items: [
                          (label: 'Photo', done: _hasPhoto),
                          (label: 'Basics', done: _hasBasics && _hasValidPrice),
                          (label: 'Specs', done: _hasSpecs),
                          (label: 'Care', done: _hasCare),
                        ],
                      ),
                      const SizedBox(height: 20),
                      VendorFormSection(
                        step: 1,
                        title: 'Product photo',
                        subtitle: 'Use good lighting and show the full item.',
                        children: [
                          DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: AppRadii.md,
                              border: Border.all(
                                color: _showPhotoError
                                    ? AppColors.rust
                                    : Colors.transparent,
                                width: 1.5,
                              ),
                            ),
                            child: ProductPhotoPicker(
                              imageBytes: _imageBytes,
                              cameraAvailable: _cameraAvailable,
                              onTakePhoto: _pickFromCamera,
                              onChooseGallery: _pickFromGallery,
                              onRemove: _removeImage,
                            ),
                          ),
                          if (_showPhotoError) ...[
                            const SizedBox(height: 8),
                            const Text(
                              'A product photo is required',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.rust,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 16),
                      VendorFormSection(
                        step: 2,
                        title: 'Listing basics',
                        subtitle: 'Name, overview, and price.',
                        children: [
                          FormTextField(
                            label: 'Product name',
                            hint: 'Astra Lounge Chair',
                            controller: _nameController,
                            textInputAction: TextInputAction.next,
                            required: true,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Enter a product name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          FormTextField(
                            label: 'Description',
                            hint: 'Style, colour, comfort, and key features…',
                            controller: _descriptionController,
                            textInputAction: TextInputAction.next,
                            maxLines: 4,
                            required: true,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Add a product description';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          FormTextField(
                            label: 'Price',
                            hint: '12,500',
                            prefixText: 'NPR ',
                            controller: _priceController,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            textInputAction: TextInputAction.next,
                            required: true,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Enter a price';
                              }
                              final parsed = double.tryParse(value.trim());
                              if (parsed == null || parsed <= 0) {
                                return 'Enter a valid amount';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      VendorFormSection(
                        step: 3,
                        title: 'Materials & specifications',
                        subtitle:
                            'Real details customers see on the product page.',
                        children: [
                          FormTextField(
                            label: 'Materials',
                            hint: 'Solid oak frame\nLinen upholstery\nFoam cushioning',
                            helperText: 'Enter one material per line.',
                            controller: _materialsController,
                            textInputAction: TextInputAction.next,
                            maxLines: 4,
                            required: true,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'List the materials used';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: FormTextField(
                                  label: 'Width (cm)',
                                  hint: '72',
                                  controller: _widthController,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                                  textInputAction: TextInputAction.next,
                                  required: true,
                                  validator: (value) =>
                                      _dimensionValidator(value, 'width'),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: FormTextField(
                                  label: 'Depth (cm)',
                                  hint: '65',
                                  controller: _depthController,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                                  textInputAction: TextInputAction.next,
                                  required: true,
                                  validator: (value) =>
                                      _dimensionValidator(value, 'depth'),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: FormTextField(
                                  label: 'Height (cm)',
                                  hint: '85',
                                  controller: _heightController,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                                  textInputAction: TextInputAction.next,
                                  required: true,
                                  validator: (value) =>
                                      _dimensionValidator(value, 'height'),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          FormTextField(
                            label: 'Weight (kg)',
                            hint: '12',
                            helperText: 'Optional but recommended.',
                            controller: _weightController,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(height: 16),
                          FormTextField(
                            label: 'Assembly',
                            hint: 'Minimal — attach legs only',
                            helperText: 'Optional assembly or setup notes.',
                            controller: _assemblyController,
                            textInputAction: TextInputAction.next,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      VendorFormSection(
                        step: 4,
                        title: 'Care & warranty',
                        subtitle: 'Help customers look after the product.',
                        children: [
                          FormTextField(
                            label: 'Care instructions',
                            hint:
                                'Spot clean with a damp cloth\nAvoid direct sunlight\nVacuum weekly',
                            helperText: 'Enter one instruction per line.',
                            controller: _careController,
                            textInputAction: TextInputAction.next,
                            maxLines: 4,
                            required: true,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Add care instructions';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          FormTextField(
                            label: 'Warranty & delivery',
                            hint: '1-year warranty · Ships in 5–7 days',
                            helperText: 'Optional warranty or delivery note.',
                            controller: _warrantyController,
                            textInputAction: TextInputAction.done,
                            maxLines: 2,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const VendorFormNote(
                        text:
                            'Your shop name appears on the product page. Customers see the details you enter here.',
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenPadding,
                12,
                AppSpacing.screenPadding,
                16,
              ),
              decoration: BoxDecoration(
                color: AppColors.cream,
                border: Border(
                  top: BorderSide(
                    color: AppColors.creamDark.withValues(alpha: 0.9),
                  ),
                ),
              ),
              child: VendorSubmitButton(
                label: 'Publish product',
                icon: Icons.check_circle_outline,
                isLoading: _isSubmitting,
                onPressed: _isSubmitting ? null : _submit,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? _dimensionValidator(String? value, String label) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter $label';
    }
    final parsed = double.tryParse(value.trim());
    if (parsed == null || parsed <= 0) {
      return 'Invalid $label';
    }
    return null;
  }
}
