import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';

class ProductPhotoPicker extends StatelessWidget {
  const ProductPhotoPicker({
    required this.imageBytes,
    required this.onTakePhoto,
    required this.onChooseGallery,
    required this.onRemove,
    this.cameraAvailable = true,
    super.key,
  });

  final Uint8List? imageBytes;
  final VoidCallback onTakePhoto;
  final VoidCallback onChooseGallery;
  final VoidCallback onRemove;
  final bool cameraAvailable;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Product photo',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 10),
        AspectRatio(
          aspectRatio: 4 / 3,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.warmWhite,
              borderRadius: AppRadii.md,
              border: Border.all(color: AppColors.creamDark, width: 1.5),
            ),
            clipBehavior: Clip.antiAlias,
            child: imageBytes == null
                ? _EmptyPhotoState(
                    cameraAvailable: cameraAvailable,
                    onTakePhoto: onTakePhoto,
                    onChooseGallery: onChooseGallery,
                  )
                : Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.memory(
                        imageBytes!,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: IconButton.filled(
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.black54,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: onRemove,
                          icon: const Icon(Icons.close, size: 20),
                        ),
                      ),
                      Positioned(
                        left: 12,
                        right: 12,
                        bottom: 12,
                        child: Row(
                          children: [
                            if (cameraAvailable) ...[
                              Expanded(
                                child: _PhotoActionButton(
                                  icon: Icons.photo_camera_outlined,
                                  label: 'Retake',
                                  onTap: onTakePhoto,
                                ),
                              ),
                              const SizedBox(width: 10),
                            ],
                            Expanded(
                              child: _PhotoActionButton(
                                icon: Icons.photo_library_outlined,
                                label: cameraAvailable ? 'Gallery' : 'Replace',
                                onTap: onChooseGallery,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}

class _EmptyPhotoState extends StatelessWidget {
  const _EmptyPhotoState({
    required this.cameraAvailable,
    required this.onTakePhoto,
    required this.onChooseGallery,
  });

  final bool cameraAvailable;
  final VoidCallback onTakePhoto;
  final VoidCallback onChooseGallery;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            cameraAvailable
                ? Icons.add_a_photo_outlined
                : Icons.photo_library_outlined,
            size: 40,
            color: AppColors.textMuted.withValues(alpha: 0.8),
          ),
          const SizedBox(height: 10),
          Text(
            cameraAvailable
                ? 'Add a photo of your product'
                : 'Choose a product photo',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            cameraAvailable
                ? 'Take a picture or choose from your gallery'
                : 'No camera on this device — pick an image from your files',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 18),
          if (cameraAvailable)
            Row(
              children: [
                Expanded(
                  child: _PhotoActionButton(
                    icon: Icons.photo_camera_outlined,
                    label: 'Camera',
                    onTap: onTakePhoto,
                    filled: true,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _PhotoActionButton(
                    icon: Icons.photo_library_outlined,
                    label: 'Gallery',
                    onTap: onChooseGallery,
                    filled: true,
                  ),
                ),
              ],
            )
          else
            _PhotoActionButton(
              icon: Icons.photo_library_outlined,
              label: 'Choose from gallery',
              onTap: onChooseGallery,
              filled: true,
              expanded: true,
            ),
        ],
      ),
    );
  }
}

class _PhotoActionButton extends StatelessWidget {
  const _PhotoActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.filled = false,
    this.expanded = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool filled;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final button = Material(
      color: filled ? AppColors.espresso : Colors.black54,
      borderRadius: AppRadii.pill,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.pill,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: Colors.white),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (expanded) {
      return SizedBox(width: double.infinity, child: button);
    }
    return button;
  }
}
