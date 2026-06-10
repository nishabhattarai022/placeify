import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:placeify/features/vendor/domain/models/vendor_product_form_state.dart';
import 'package:placeify/features/vendor/domain/models/vendor_product_image_item.dart';
import 'package:placeify/features/vendor/presentation/providers/vendor_product_form_provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/services/haptic_service.dart';
import '../../../../core/widgets/toast_overlay.dart';

/// Horizontal reorderable grid for product photos (up to 8).
class ProductImagePickerGrid extends ConsumerWidget {
  const ProductImagePickerGrid({super.key});

  static const _tileSize = 96.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(vendorProductFormProvider);
    final notifier = ref.read(vendorProductFormProvider.notifier);
    final images = form.images;
    final canAddMore = images.length < VendorProductFormState.maxImages;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Product photos',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.espresso,
                ),
              ),
            ),
            Text(
              '${images.length}/${VendorProductFormState.maxImages}',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          'First photo is the primary listing image. Drag to reorder.',
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary.withValues(alpha: 0.9),
            height: 1.35,
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: _tileSize + 8,
          child: Row(
            children: [
              Expanded(
                child: images.isEmpty
                    ? Align(
                        alignment: Alignment.centerLeft,
                        child: canAddMore
                            ? _AddImageTile(
                                onTap: () => _pickImages(context, ref),
                              )
                            : const SizedBox.shrink(),
                      )
                    : ReorderableListView(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.zero,
                        buildDefaultDragHandles: false,
                        proxyDecorator: (child, index, animation) {
                          return AnimatedBuilder(
                            animation: animation,
                            builder: (context, child) {
                              final scale = 1.0 + (animation.value * 0.04);
                              return Transform.scale(
                                scale: scale,
                                child: Material(
                                  elevation: 4 * animation.value,
                                  borderRadius: AppRadii.md,
                                  color: Colors.transparent,
                                  child: child,
                                ),
                              );
                            },
                            child: child,
                          );
                        },
                        onReorder: notifier.reorderImages,
                        children: [
                          for (var i = 0; i < images.length; i++)
                            _ImageTile(
                              key: ValueKey(images[i].id),
                              index: i,
                              item: images[i],
                              onRemove: () => notifier.removeImage(images[i].id),
                              onSetPrimary: i == 0
                                  ? null
                                  : () =>
                                      notifier.setPrimaryImage(images[i].id),
                            ),
                        ],
                      ),
              ),
              if (canAddMore && images.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: _AddImageTile(
                    onTap: () => _pickImages(context, ref),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _pickImages(BuildContext context, WidgetRef ref) async {
    final form = ref.read(vendorProductFormProvider);
    final remaining = VendorProductFormState.maxImages - form.images.length;
    if (remaining <= 0) return;

    HapticService.light();

    final source = await showModalBottomSheet<ImageSource>(
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
                    'Add photos',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.espresso,
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Choose from gallery'),
                onTap: () => Navigator.pop(sheetContext, ImageSource.gallery),
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera_outlined),
                title: const Text('Take a photo'),
                onTap: () => Navigator.pop(sheetContext, ImageSource.camera),
              ),
            ],
          ),
        );
      },
    );

    if (source == null || !context.mounted) return;

    final picker = ImagePicker();
    try {
      if (source == ImageSource.gallery) {
        final picked = await picker.pickMultiImage(
          imageQuality: 85,
          limit: remaining,
        );
        if (picked.isEmpty) return;
        ref.read(vendorProductFormProvider.notifier).addLocalImages(
              picked.map((file) => file.path).toList(),
            );
      } else {
        final picked = await picker.pickImage(
          source: ImageSource.camera,
          imageQuality: 85,
        );
        if (picked == null) return;
        ref.read(vendorProductFormProvider.notifier).addLocalImages([picked.path]);
      }
    } catch (_) {
      if (context.mounted) {
        PlaceifyToast.show(context, 'Could not access photos. Check permissions.');
      }
    }
  }
}

class _ImageTile extends StatelessWidget {
  const _ImageTile({
    required super.key,
    required this.index,
    required this.item,
    required this.onRemove,
    this.onSetPrimary,
  });

  final int index;
  final VendorProductImageItem item;
  final VoidCallback onRemove;
  final VoidCallback? onSetPrimary;

  @override
  Widget build(BuildContext context) {
    return ReorderableDragStartListener(
      index: index,
      child: Padding(
        padding: EdgeInsets.only(right: 10, left: index == 0 ? 0 : 0),
        child: SizedBox(
          width: ProductImagePickerGrid._tileSize,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              ClipRRect(
                borderRadius: AppRadii.md,
                child: SizedBox(
                  width: ProductImagePickerGrid._tileSize,
                  height: ProductImagePickerGrid._tileSize,
                  child: _ProductImagePreview(source: item.displaySource),
                ),
              ),
              if (index == 0)
                Positioned(
                  left: 6,
                  bottom: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.vendorForest,
                      borderRadius: AppRadii.pill,
                    ),
                    child: const Text(
                      'Primary',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.04 * 9,
                      ),
                    ),
                  ),
                ),
              Positioned(
                top: 4,
                right: 4,
                child: _CircleIconButton(
                  icon: Icons.close,
                  onTap: onRemove,
                ),
              ),
              if (onSetPrimary != null)
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: _CircleIconButton(
                    icon: Icons.star_outline,
                    onTap: onSetPrimary!,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddImageTile extends StatelessWidget {
  const _AddImageTile({
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: GestureDetector(
        onTap: () {
          HapticService.light();
          onTap();
        },
        child: Container(
          width: ProductImagePickerGrid._tileSize,
          height: ProductImagePickerGrid._tileSize,
          decoration: BoxDecoration(
            color: AppColors.warmWhite,
            borderRadius: AppRadii.md,
            border: Border.all(
              color: AppColors.creamDark,
              width: 1.5,
            ),
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_photo_alternate_outlined,
                color: AppColors.vendorForest,
                size: 26,
              ),
              SizedBox(height: 6),
              Text(
                'Add',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticService.selection();
        onTap();
      },
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.55),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Icon(icon, size: 14, color: Colors.white),
      ),
    );
  }
}

class _ProductImagePreview extends StatelessWidget {
  const _ProductImagePreview({required this.source});

  final String source;

  bool get _isAsset => source.startsWith('assets/');
  bool get _isLocalFile =>
      source.startsWith('/') || source.startsWith('file://');

  @override
  Widget build(BuildContext context) {
    if (_isAsset) {
      return Image.asset(source, fit: BoxFit.cover);
    }
    if (_isLocalFile) {
      final path = source.startsWith('file://')
          ? source.replaceFirst('file://', '')
          : source;
      return Image.file(
        File(path),
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _placeholder(),
      );
    }
    return Image.network(
      source,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _placeholder(),
    );
  }

  Widget _placeholder() {
    return Container(
      color: AppColors.cream,
      alignment: Alignment.center,
      child: const Icon(
        Icons.image_outlined,
        color: AppColors.bark,
        size: 28,
      ),
    );
  }
}
