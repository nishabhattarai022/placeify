import 'package:flutter/material.dart';

import 'package:placeify/core/constants/app_colors.dart';
import 'package:placeify/core/services/haptic_service.dart';
import 'package:placeify/core/widgets/animated_scale_tap.dart';
import 'package:placeify/features/profile/presentation/widgets/shared/profile_form_field.dart';
import 'package:placeify/features/vendor/domain/constants/vendor_profile_strings.dart';
import 'package:placeify/features/vendor/domain/models/vendor_social_links.dart';
import 'package:placeify/features/vendor/domain/validators/vendor_profile_validator.dart';

/// Social links — read-only tappable rows in view mode, inputs in edit mode.
class SocialLinksSection extends StatelessWidget {
  const SocialLinksSection({
    required this.socialLinks,
    required this.isEditMode,
    required this.fieldErrors,
    this.instagramController,
    this.facebookController,
    this.websiteController,
    this.onInstagramChanged,
    this.onFacebookChanged,
    this.onWebsiteChanged,
    super.key,
  });

  final VendorSocialLinks socialLinks;
  final bool isEditMode;
  final Map<String, String> fieldErrors;
  final TextEditingController? instagramController;
  final TextEditingController? facebookController;
  final TextEditingController? websiteController;
  final ValueChanged<String>? onInstagramChanged;
  final ValueChanged<String>? onFacebookChanged;
  final ValueChanged<String>? onWebsiteChanged;

  @override
  Widget build(BuildContext context) {
    if (!isEditMode && !socialLinks.hasAnyLink) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.creamDark, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            VendorProfileStrings.socialLinksSection.toUpperCase(),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.espresso,
              letterSpacing: 0.84,
            ),
          ),
          const SizedBox(height: 12),
          if (isEditMode) ..._buildEditFields() else ..._buildViewRows(),
        ],
      ),
    );
  }

  List<Widget> _buildEditFields() {
    return [
      ProfileFormField(
        label: VendorProfileStrings.instagramLabel,
        child: ProfileTextInput(
          controller: instagramController,
          hint: socialLinks.instagram.isEmpty
              ? VendorProfileStrings.addInstagram
              : VendorProfileStrings.instagramHint,
          onChanged: onInstagramChanged,
        ),
      ),
      if (fieldErrors[VendorProfileFieldKeys.instagram] != null)
        _error(fieldErrors[VendorProfileFieldKeys.instagram]!),
      ProfileFormField(
        label: VendorProfileStrings.facebookLabel,
        child: ProfileTextInput(
          controller: facebookController,
          hint: socialLinks.facebook.isEmpty
              ? VendorProfileStrings.addFacebook
              : VendorProfileStrings.facebookHint,
          onChanged: onFacebookChanged,
        ),
      ),
      if (fieldErrors[VendorProfileFieldKeys.facebook] != null)
        _error(fieldErrors[VendorProfileFieldKeys.facebook]!),
      ProfileFormField(
        label: VendorProfileStrings.websiteLabel,
        child: ProfileTextInput(
          controller: websiteController,
          hint: socialLinks.website.isEmpty
              ? VendorProfileStrings.addWebsite
              : VendorProfileStrings.websiteHint,
          keyboardType: TextInputType.url,
          onChanged: onWebsiteChanged,
        ),
      ),
      if (fieldErrors[VendorProfileFieldKeys.website] != null)
        _error(fieldErrors[VendorProfileFieldKeys.website]!),
    ];
  }

  List<Widget> _buildViewRows() {
    final rows = <Widget>[];

    void addRow({
      required IconData icon,
      required String label,
      required String value,
      required Color iconColor,
    }) {
      if (value.trim().isEmpty) return;
      rows.add(
        _SocialLinkRow(
          icon: icon,
          label: label,
          value: value,
          iconColor: iconColor,
        ),
      );
      rows.add(const SizedBox(height: 8));
    }

    addRow(
      icon: Icons.camera_alt_outlined,
      label: VendorProfileStrings.instagramLabel,
      value: socialLinks.instagram,
      iconColor: AppColors.coral,
    );
    addRow(
      icon: Icons.facebook_outlined,
      label: VendorProfileStrings.facebookLabel,
      value: socialLinks.facebook,
      iconColor: AppColors.teal,
    );
    addRow(
      icon: Icons.language_outlined,
      label: VendorProfileStrings.websiteLabel,
      value: socialLinks.website,
      iconColor: AppColors.accent,
    );

    if (rows.isNotEmpty) rows.removeLast();
    return rows;
  }

  Widget _error(String message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        message,
        style: const TextStyle(fontSize: 12, color: AppColors.coral),
      ),
    );
  }
}

class _SocialLinkRow extends StatelessWidget {
  const _SocialLinkRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.iconColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedScaleTap(
      onTap: () => HapticService.light(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.cream.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: iconColor),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.espresso,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.open_in_new, size: 16, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}

extension on VendorSocialLinks {
  bool get hasAnyLink =>
      instagram.trim().isNotEmpty ||
      facebook.trim().isNotEmpty ||
      website.trim().isNotEmpty;
}
