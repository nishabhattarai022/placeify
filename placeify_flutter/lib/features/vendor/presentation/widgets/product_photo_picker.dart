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
    super.key,
  });

  final Uint8List? imageBytes;
  final VoidCallback onTakePhoto;
  final VoidCallback onChooseGallery;
  final VoidCallback onRemove;

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
                            Expanded(
                              child: _PhotoActionButton(
                                icon: Icons.photo_camera_outlined,
                                label: 'Retake',
                                onTap: onTakePhoto,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _PhotoActionButton(
                                icon: Icons.photo_library_outlined,
                                label: 'Gallery',
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
    required this.onTakePhoto,
    required this.onChooseGallery,
  });

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
            Icons.add_a_photo_outlined,
            size: 40,
            color: AppColors.textMuted.withValues(alpha: 0.8),
          ),
          const SizedBox(height: 10),
          const Text(
            'Add a photo of your product',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Take a picture or choose from your gallery',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 18),
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
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Material(
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
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
