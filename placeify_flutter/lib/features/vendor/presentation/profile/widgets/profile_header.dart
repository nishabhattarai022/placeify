import 'dart:io';

import 'package:flutter/material.dart';

import 'package:placeify_flutter/core/constants/app_colors.dart';
import 'package:placeify_flutter/core/constants/app_typography.dart';
import 'package:placeify_flutter/core/widgets/animated_scale_tap.dart';
import 'package:placeify_flutter/core/widgets/shimmer_loader.dart';
import 'package:placeify_flutter/features/profile/presentation/widgets/shared/profile_form_field.dart';
import 'package:placeify_flutter/features/vendor/domain/constants/vendor_profile_strings.dart';
import 'package:placeify_flutter/features/vendor/presentation/profile/widgets/profile_image_picker.dart';

/// Storefront header: 3:1 banner, overlapping circular logo, name, and member badge.
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    required this.businessName,
    required this.memberSinceText,
    required this.showActiveBadge,
    required this.isEditMode,
    required this.bannerPath,
    required this.logoPath,
    required this.bannerIsLocal,
    required this.logoIsLocal,
    this.isBannerLoading = false,
    this.isLogoLoading = false,
    this.nameController,
    this.nameError,
    this.onBusinessNameChanged,
    this.onBannerTap,
    this.onLogoTap,
    super.key,
  });

  final String businessName;
  final String memberSinceText;
  final bool showActiveBadge;
  final bool isEditMode;
  final String? bannerPath;
  final String? logoPath;
  final bool bannerIsLocal;
  final bool logoIsLocal;
  final bool isBannerLoading;
  final bool isLogoLoading;
  final TextEditingController? nameController;
  final String? nameError;
  final ValueChanged<String>? onBusinessNameChanged;
  final VoidCallback? onBannerTap;
  final VoidCallback? onLogoTap;

  static const _logoSize = 96.0;
  static const _logoOverlap = 48.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            ProfileImagePicker(
              label: VendorProfileStrings.storeBanner,
              hint: VendorProfileStrings.bannerRatioHint,
              aspectRatio: 3,
              imagePath: bannerPath,
              isLocal: bannerIsLocal,
              isEditMode: isEditMode,
              isLoading: isBannerLoading,
              onTap: onBannerTap,
            ),
            Positioned(
              left: 20,
              bottom: -_logoOverlap,
              child: _LogoCircle(
                imagePath: logoPath,
                isLocal: logoIsLocal,
                isEditMode: isEditMode,
                isLoading: isLogoLoading,
                onTap: onLogoTap,
              ),
            ),
          ],
        ),
        SizedBox(height: _logoOverlap + 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isEditMode && nameController != null)
                ProfileFormField(
                  label: VendorProfileStrings.businessNameLabel,
                  child: ProfileTextInput(
                    controller: nameController,
                    hint: VendorProfileStrings.businessNameHint,
                    onChanged: onBusinessNameChanged,
                  ),
                )
              else
                Text(businessName, style: AppTypography.sectionTitle),
              if (nameError != null) ...[
                const SizedBox(height: 4),
                Text(
                  nameError!,
                  style: const TextStyle(fontSize: 12, color: AppColors.coral),
                ),
              ],
              const SizedBox(height: 8),
              Row(
                children: [
                  if (showActiveBadge) ...[
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.sage,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      VendorProfileStrings.activeBadge,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.sage,
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Text(
                    memberSinceText,
                    style: AppTypography.bodyLight.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LogoCircle extends StatelessWidget {
  const _LogoCircle({
    required this.imagePath,
    required this.isLocal,
    required this.isEditMode,
    required this.isLoading,
    this.onTap,
  });

  final String? imagePath;
  final bool isLocal;
  final bool isEditMode;
  final bool isLoading;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final avatar = Container(
      width: ProfileHeader._logoSize,
      height: ProfileHeader._logoSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.warmWhite,
        border: Border.all(color: AppColors.creamDark, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.espresso.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipOval(
        child: isLoading
            ? const ShimmerLoader()
            : imagePath == null
            ? ColoredBox(
                color: AppColors.cream,
                child: Icon(
                  Icons.storefront_outlined,
                  color: AppColors.textMuted.withValues(alpha: 0.7),
                  size: 36,
                ),
              )
            : isLocal
            ? Image.file(File(imagePath!), fit: BoxFit.cover)
            : Image.network(
                imagePath!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.broken_image_outlined,
                ),
              ),
      ),
    );

    if (!isEditMode || onTap == null) return avatar;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        AnimatedScaleTap(onTap: onTap, child: avatar),
        Positioned(
          right: 0,
          bottom: 0,
          child: AnimatedScaleTap(
            onTap: onTap,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.vendorForest,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.warmWhite, width: 2),
              ),
              child: const Icon(
                Icons.edit_outlined,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
