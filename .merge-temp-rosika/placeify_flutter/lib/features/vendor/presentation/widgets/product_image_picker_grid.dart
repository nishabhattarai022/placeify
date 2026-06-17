import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:placeify_flutter/features/vendor/domain/models/vendor_product_form_state.dart';
import 'package:placeify_flutter/features/vendor/domain/models/vendor_product_image_item.dart';
import 'package:placeify_flutter/features/vendor/presentation/providers/vendor_product_form_provider.dart';

import 'background_removal_sheet.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/services/haptic_service.dart';
import '../../../../core/utils/local_image_path.dart';
import '../../../../core/utils/persist_picked_image.dart';
import '../../../../core/widgets/toast_overlay.dart';

enum _PickPhotoAction { browseFolders, photoLibrary, camera }

bool get _isDesktop =>
    !kIsWeb &&
    (Platform.isMacOS || Platform.isWindows || Platform.isLinux);

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

    ref.listen(vendorProductFormProvider, (previous, next) {
      if (previous?.images.length != next.images.length) {
        notifier.restoreCachedBackgroundRemovals();
      }
    });

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
          _isDesktop
              ? 'First photo is the primary listing image. Browse Downloads or any folder on this device.'
              : 'First photo is the primary listing image. Drag to reorder.',
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
                              onRemoveBg: images[i].isLocal
                                  ? () => BackgroundRemovalSheet.show(
                                        context,
                                        ref,
                                        item: images[i],
                                      )
                                  : null,
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

    if (_isDesktop) {
      await _pickFromFolders(context, ref, remaining);
      return;
    }

    final action = await showModalBottomSheet<_PickPhotoAction>(
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
                leading: const Icon(Icons.folder_outlined),
                title: const Text('Browse folders'),
                subtitle: const Text('Downloads, Files, and other folders'),
                onTap: () =>
                    Navigator.pop(sheetContext, _PickPhotoAction.browseFolders),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Photo library'),
                onTap: () => Navigator.pop(
                  sheetContext,
                  _PickPhotoAction.photoLibrary,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera_outlined),
                title: const Text('Take a photo'),
                onTap: () =>
                    Navigator.pop(sheetContext, _PickPhotoAction.camera),
              ),
            ],
          ),
        );
      },
    );

    if (action == null || !context.mounted) return;

    switch (action) {
      case _PickPhotoAction.browseFolders:
        await _pickFromFolders(context, ref, remaining);
      case _PickPhotoAction.photoLibrary:
        await _pickFromPhotoLibrary(context, ref, remaining);
      case _PickPhotoAction.camera:
        await _pickFromCamera(context, ref);
    }
  }

  Future<void> _pickFromFolders(
    BuildContext context,
    WidgetRef ref,
    int remaining,
  ) async {
    try {
      final allowMultiple = remaining > 1;
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: const [
          'jpg',
          'jpeg',
          'png',
          'webp',
          'gif',
          'bmp',
          'heic',
          'heif',
        ],
        allowMultiple: allowMultiple,
        withReadStream: false,
        withData: Platform.isIOS,
      );

      if (result == null || result.files.isEmpty) return;

      final paths = <String>[];
      for (final file in result.files.take(remaining)) {
        final path = file.path;
        if (path != null && path.isNotEmpty) {
          paths.add(path);
          continue;
        }

        final bytes = file.bytes;
        if (bytes == null || bytes.isEmpty) continue;

        final extension = (file.extension?.trim().isNotEmpty ?? false)
            ? '.${file.extension!.toLowerCase()}'
            : '.jpg';
        final destination = File(
          '${Directory.systemTemp.path}/placeify_${DateTime.now().microsecondsSinceEpoch}$extension',
        );
        await destination.writeAsBytes(bytes);
        paths.add(destination.path);
      }

      if (paths.isEmpty) {
        if (context.mounted) {
          PlaceifyToast.show(context, 'Could not read the selected file.');
        }
        return;
      }

      ref.read(vendorProductFormProvider.notifier).addLocalImages(
            await PersistPickedImage.copyAllToTemp(paths),
          );
    } catch (_) {
      if (context.mounted) {
        PlaceifyToast.show(
          context,
          'Could not open folders. Check file access permissions.',
        );
      }
    }
  }

  Future<void> _pickFromPhotoLibrary(
    BuildContext context,
    WidgetRef ref,
    int remaining,
  ) async {
    final picker = ImagePicker();
    try {
      if (remaining == 1) {
        final picked = await picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 85,
        );
        if (picked == null) return;
        final persisted = await PersistPickedImage.copyToTemp(picked.path);
        if (persisted == null) {
          if (context.mounted) {
            PlaceifyToast.show(context, 'Could not read the selected photo.');
          }
          return;
        }
        ref
            .read(vendorProductFormProvider.notifier)
            .addLocalImages([persisted]);
        return;
      }

      final picked = await picker.pickMultiImage(
        imageQuality: 85,
        limit: remaining,
      );
      if (picked.isEmpty) return;
      ref.read(vendorProductFormProvider.notifier).addLocalImages(
            await PersistPickedImage.copyAllToTemp(
              picked.map((file) => file.path).toList(),
            ),
          );
    } catch (_) {
      if (context.mounted) {
        PlaceifyToast.show(context, 'Could not access photos. Check permissions.');
      }
    }
  }

  Future<void> _pickFromCamera(BuildContext context, WidgetRef ref) async {
    final picker = ImagePicker();
    try {
      final picked = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );
      if (picked == null) return;
      final persisted = await PersistPickedImage.copyToTemp(picked.path);
      if (persisted == null) {
        if (context.mounted) {
          PlaceifyToast.show(context, 'Could not read the photo.');
        }
        return;
      }
      ref.read(vendorProductFormProvider.notifier).addLocalImages([persisted]);
    } catch (_) {
      if (context.mounted) {
        PlaceifyToast.show(context, 'Could not access the camera.');
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
    this.onRemoveBg,
  });

  final int index;
  final VendorProductImageItem item;
  final VoidCallback onRemove;
  final VoidCallback? onSetPrimary;
  final VoidCallback? onRemoveBg;

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
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      _ProductImagePreview(source: item.displaySource),
                      if (item.isProcessingBg)
                        Container(
                          color: Colors.black.withValues(alpha: 0.35),
                          child: const Center(
                            child: SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
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
              if (onRemoveBg != null)
                Positioned(
                  left: 4,
                  top: 4,
                  child: _CircleIconButton(
                    icon: Icons.auto_fix_high,
                    onTap: onRemoveBg!,
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _isDesktop ? Icons.folder_open_outlined : Icons.add_photo_alternate_outlined,
                color: AppColors.vendorForest,
                size: 26,
              ),
              const SizedBox(height: 6),
              Text(
                _isDesktop ? 'Browse' : 'Add',
                style: const TextStyle(
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

  @override
  Widget build(BuildContext context) {
    if (LocalImagePath.isAsset(source)) {
      return Image.asset(source, fit: BoxFit.cover);
    }
    if (LocalImagePath.isLocal(source)) {
      return Image.file(
        File(LocalImagePath.normalize(source)),
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
