import 'dart:io';

import 'package:flutter/material.dart';

import 'package:placeify_flutter/core/constants/app_colors.dart';
import 'package:placeify_flutter/core/constants/app_radii.dart';
import 'package:placeify_flutter/core/widgets/animated_scale_tap.dart';
import 'package:placeify_flutter/core/widgets/shimmer_loader.dart';

/// Tappable banner or logo tile with optional edit overlay (edit mode).
class ProfileImagePicker extends StatelessWidget {
  const ProfileImagePicker({
    required this.label,
    required this.hint,
    required this.aspectRatio,
    required this.imagePath,
    required this.isLocal,
    required this.isEditMode,
    this.isLoading = false,
    this.onTap,
    super.key,
  });

  final String label;
  final String hint;
  final double aspectRatio;
  final String? imagePath;
  final bool isLocal;
  final bool isEditMode;
  final bool isLoading;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final content = AspectRatio(
      aspectRatio: aspectRatio,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.warmWhite,
          borderRadius: AppRadii.md,
          border: Border.all(color: AppColors.creamDark, width: 1.5),
        ),
        child: ClipRRect(
          borderRadius: AppRadii.md,
          child: _buildImageContent(),
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.espresso,
            letterSpacing: 0.84,
          ),
        ),
        const SizedBox(height: 6),
        if (isEditMode && onTap != null)
          AnimatedScaleTap(onTap: onTap, child: content)
        else
          content,
      ],
    );
  }

  Widget _buildImageContent() {
    if (isLoading) {
      return const ShimmerLoader();
    }

    if (imagePath == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.add_photo_alternate_outlined,
              color: AppColors.textMuted.withValues(alpha: 0.8),
              size: 28,
            ),
            const SizedBox(height: 6),
            Text(
              hint,
              style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
            ),
          ],
        ),
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        isLocal
            ? Image.file(File(imagePath!), fit: BoxFit.cover)
            : Image.network(
                imagePath!,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) =>
                    const Center(child: Icon(Icons.broken_image_outlined)),
              ),
        if (isEditMode && onTap != null)
          Positioned(
            right: 8,
            bottom: 8,
            child: AnimatedScaleTap(
              onTap: onTap,
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.55),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
                child: const Icon(
                  Icons.edit_outlined,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
