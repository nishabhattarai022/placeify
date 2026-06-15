import 'package:flutter/material.dart';

import 'package:placeify/core/constants/app_colors.dart';
import 'package:placeify/core/constants/app_typography.dart';
import 'package:placeify/core/services/haptic_service.dart';
import 'package:placeify/core/widgets/phone_input_field.dart';
import 'package:placeify/data/furniture_categories.dart';
import 'package:placeify/features/profile/presentation/widgets/shared/profile_form_field.dart';
import 'package:placeify/features/vendor/domain/constants/vendor_profile_strings.dart';
import 'package:placeify/features/vendor/domain/models/vendor_operating_day.dart';
import 'package:placeify/features/vendor/domain/models/vendor_profile.dart';
import 'package:placeify/features/vendor/domain/validators/vendor_profile_validator.dart';
import 'package:placeify/features/vendor/presentation/profile/widgets/operating_hours_editor.dart';

/// Bio, tags, contact, and hours summary / editor.
class StoreInfoSection extends StatelessWidget {
  const StoreInfoSection({
    required this.profile,
    required this.isEditMode,
    required this.fieldErrors,
    this.bioController,
    this.emailController,
    this.addressController,
    this.onBioChanged,
    this.onEmailChanged,
    this.onAddressChanged,
    this.onPhoneChanged,
    this.onTagsChanged,
    this.onScheduleChanged,
    super.key,
  });

  final VendorProfile profile;
  final bool isEditMode;
  final Map<String, String> fieldErrors;
  final TextEditingController? bioController;
  final TextEditingController? emailController;
  final TextEditingController? addressController;
  final ValueChanged<String>? onBioChanged;
  final ValueChanged<String>? onEmailChanged;
  final ValueChanged<String>? onAddressChanged;
  final ValueChanged<String>? onPhoneChanged;
  final ValueChanged<List<String>>? onTagsChanged;
  final ValueChanged<List<VendorOperatingDay>>? onScheduleChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionCard(
          title: VendorProfileStrings.aboutSection,
          child: isEditMode
              ? _buildBioEditor()
              : _ReadOnlyText(
                  text: profile.bio.isEmpty ? '—' : profile.bio,
                ),
        ),
        const SizedBox(height: 14),
        _SectionCard(
          title: VendorProfileStrings.categoriesSection,
          child: isEditMode ? _buildTagEditor() : _buildTagChips(profile.tags),
        ),
        const SizedBox(height: 14),
        _SectionCard(
          title: VendorProfileStrings.contactSection,
          child: isEditMode ? _buildContactEditor() : _buildContactReadOnly(),
        ),
        const SizedBox(height: 14),
        _SectionCard(
          title: VendorProfileStrings.operatingHoursSection,
          child: isEditMode
              ? OperatingHoursEditor(
                  schedule: profile.schedule,
                  fieldErrors: fieldErrors,
                  onChanged: onScheduleChanged,
                )
              : _ReadOnlyText(text: formatVendorScheduleSummary(profile.schedule)),
        ),
      ],
    );
  }

  Widget _buildBioEditor() {
    final bioLength = bioController?.text.length ?? profile.bio.length;
    final atLimit = bioLength >= VendorProfileValidator.bioMaxLength;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfileFormField(
          label: VendorProfileStrings.bioLabel,
          child: ProfileTextInput(
            controller: bioController,
            hint: VendorProfileStrings.bioHint,
            maxLines: 4,
            onChanged: onBioChanged,
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            '$bioLength / ${VendorProfileValidator.bioMaxLength}',
            style: TextStyle(
              fontSize: 12,
              color: atLimit ? AppColors.coral : AppColors.textMuted,
            ),
          ),
        ),
        if (fieldErrors[VendorProfileFieldKeys.bio] != null)
          _FieldError(fieldErrors[VendorProfileFieldKeys.bio]!),
      ],
    );
  }

  Widget _buildTagEditor() {
    final selected = profile.tags.toSet();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final name in furnitureCategories.map((c) => c.name))
              FilterChip(
                label: Text(name),
                selected: selected.contains(name),
                onSelected: (isSelected) {
                  HapticService.light();
                  final next = List<String>.from(profile.tags);
                  if (isSelected) {
                    if (next.length < VendorProfileValidator.tagsMaxCount &&
                        !next.contains(name)) {
                      next.add(name);
                    }
                  } else {
                    next.remove(name);
                  }
                  onTagsChanged?.call(next);
                },
                selectedColor: AppColors.vendorForestBg,
                checkmarkColor: AppColors.vendorForest,
                labelStyle: TextStyle(
                  fontSize: 13,
                  fontWeight:
                      selected.contains(name) ? FontWeight.w600 : FontWeight.w400,
                  color: AppColors.espresso,
                ),
                side: BorderSide(
                  color: selected.contains(name)
                      ? AppColors.vendorForest
                      : AppColors.creamDark,
                ),
              ),
          ],
        ),
        if (fieldErrors[VendorProfileFieldKeys.tags] != null) ...[
          const SizedBox(height: 6),
          _FieldError(fieldErrors[VendorProfileFieldKeys.tags]!),
        ],
      ],
    );
  }

  Widget _buildTagChips(List<String> tags) {
    if (tags.isEmpty) {
      return const _ReadOnlyText(text: '—');
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final tag in tags)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.vendorForestBg,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: AppColors.vendorForest.withValues(alpha: 0.25)),
            ),
            child: Text(
              tag,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.vendorForest,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildContactEditor() {
    return Column(
      children: [
        ProfileFormField(
          label: VendorProfileStrings.emailLabel,
          child: ProfileTextInput(
            controller: emailController,
            hint: VendorProfileStrings.emailHint,
            keyboardType: TextInputType.emailAddress,
            onChanged: onEmailChanged,
          ),
        ),
        if (fieldErrors[VendorProfileFieldKeys.email] != null)
          _FieldError(fieldErrors[VendorProfileFieldKeys.email]!),
        ProfileFormField(
          label: VendorProfileStrings.phoneLabel,
          child: PhoneInputField(
            initialPhone: profile.phone,
            onChanged: onPhoneChanged,
          ),
        ),
        if (fieldErrors[VendorProfileFieldKeys.phone] != null)
          _FieldError(fieldErrors[VendorProfileFieldKeys.phone]!),
        ProfileFormField(
          label: VendorProfileStrings.addressLabel,
          child: ProfileTextInput(
            controller: addressController,
            hint: VendorProfileStrings.addressHint,
            maxLines: 2,
            onChanged: onAddressChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildContactReadOnly() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ContactRow(
          icon: Icons.email_outlined,
          label: VendorProfileStrings.emailLabel,
          value: profile.email,
        ),
        const SizedBox(height: 10),
        _ContactRow(
          icon: Icons.phone_outlined,
          label: VendorProfileStrings.phoneLabel,
          value: profile.phone,
        ),
        const SizedBox(height: 10),
        _ContactRow(
          icon: Icons.location_on_outlined,
          label: VendorProfileStrings.addressLabel,
          value: profile.address,
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
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
            title.toUpperCase(),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.espresso,
              letterSpacing: 0.84,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _ReadOnlyText extends StatelessWidget {
  const _ReadOnlyText({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTypography.bodyLight.copyWith(
        color: AppColors.textPrimary,
        height: 1.45,
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  const _ContactRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.textMuted),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
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
      ],
    );
  }
}

class _FieldError extends StatelessWidget {
  const _FieldError(this.message);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        message,
        style: const TextStyle(fontSize: 12, color: AppColors.coral),
      ),
    );
  }
}
