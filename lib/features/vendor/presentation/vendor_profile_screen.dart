import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:placeify/core/constants/app_colors.dart';
import 'package:placeify/core/constants/app_radii.dart';
import 'package:placeify/core/constants/app_typography.dart';
import 'package:placeify/core/services/haptic_service.dart';
import 'package:placeify/core/widgets/bottom_nav/bottom_nav_tokens.dart';
import 'package:placeify/core/widgets/phone_input_field.dart';
import 'package:placeify/core/widgets/shimmer_loader.dart';
import 'package:placeify/core/widgets/toast_overlay.dart';
import 'package:placeify/data/furniture_categories.dart';
import 'package:placeify/features/profile/presentation/widgets/shared/profile_form_field.dart';
import 'package:placeify/features/vendor/domain/constants/vendor_routes.dart';
import 'package:placeify/features/vendor/domain/models/vendor_operating_day.dart';
import 'package:placeify/features/vendor/domain/models/vendor_profile.dart';
import 'package:placeify/features/vendor/domain/models/vendor_profile_editor_state.dart';
import 'package:placeify/features/vendor/presentation/providers/vendor_profile_editor_provider.dart';

class VendorProfileScreen extends ConsumerStatefulWidget {
  const VendorProfileScreen({super.key});

  @override
  ConsumerState<VendorProfileScreen> createState() =>
      _VendorProfileScreenState();
}

class _VendorProfileScreenState extends ConsumerState<VendorProfileScreen> {
  late final TextEditingController _businessName;
  late final TextEditingController _email;
  late final TextEditingController _address;
  late final TextEditingController _bio;
  late final TextEditingController _instagram;
  late final TextEditingController _facebook;
  late final TextEditingController _operatingHours;

  final _imagePicker = ImagePicker();
  String? _category;

  @override
  void initState() {
    super.initState();
    final draft = ref.read(vendorProfileEditorProvider).draft;
    _businessName = TextEditingController(text: draft?.businessName ?? '');
    _email = TextEditingController(text: draft?.email ?? '');
    _address = TextEditingController(text: draft?.address ?? '');
    _bio = TextEditingController(text: draft?.bio ?? '');
    _instagram = TextEditingController(text: draft?.socialLinks.instagram ?? '');
    _facebook = TextEditingController(text: draft?.socialLinks.facebook ?? '');
    _operatingHours = TextEditingController(
      text: draft == null ? '' : formatVendorScheduleSummary(draft.schedule),
    );
    _category = draft?.tags.firstOrNull ?? furnitureCategories.first.name;
  }

  @override
  void dispose() {
    _businessName.dispose();
    _email.dispose();
    _address.dispose();
    _bio.dispose();
    _instagram.dispose();
    _facebook.dispose();
    _operatingHours.dispose();
    super.dispose();
  }

  void _syncControllers(VendorProfile profile) {
    void setIfDifferent(TextEditingController controller, String value) {
      if (controller.text != value) {
        controller.value = controller.value.copyWith(
          text: value,
          selection: TextSelection.collapsed(offset: value.length),
        );
      }
    }

    setIfDifferent(_businessName, profile.businessName);
    setIfDifferent(_email, profile.email);
    setIfDifferent(_address, profile.address);
    setIfDifferent(_bio, profile.bio);
    setIfDifferent(_instagram, profile.socialLinks.instagram);
    setIfDifferent(_facebook, profile.socialLinks.facebook);
    setIfDifferent(
      _operatingHours,
      formatVendorScheduleSummary(profile.schedule),
    );
    final primaryTag = profile.tags.firstOrNull;
    if (_category != primaryTag) {
      setState(() => _category = primaryTag);
    }
  }

  void _updateDraft(VendorProfile Function(VendorProfile) updater) {
    ref.read(vendorProfileEditorProvider.notifier).updateDraft(updater);
  }

  Future<void> _saveOnBlur() async {
    await ref.read(vendorProfileEditorProvider.notifier).saveOnBlur();
    final error = ref.read(vendorProfileEditorProvider).saveError;
    if (error != null && mounted) {
      PlaceifyToast.show(context, error);
    }
  }

  Future<bool> _confirmDiscard() async {
    final hasUnsaved = ref.read(vendorProfileEditorProvider).hasUnsavedChanges;
    if (!hasUnsaved) return true;

    final shouldDiscard = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Discard changes?'),
        content: const Text(
          'You have unsaved profile changes. Leave without saving?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Keep editing'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Discard'),
          ),
        ],
      ),
    );

    if (shouldDiscard == true) {
      await ref
          .read(vendorProfileEditorProvider.notifier)
          .discardUnsavedChanges();
      return true;
    }
    return false;
  }

  Future<void> _pickImage({required bool isLogo}) async {
    HapticService.light();
    final file = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (file == null || !mounted) return;

    final notifier = ref.read(vendorProfileEditorProvider.notifier);
    if (isLogo) {
      notifier.setLocalLogo(file.path);
    } else {
      notifier.setLocalBanner(file.path);
    }

    final error = ref.read(vendorProfileEditorProvider).saveError;
    if (error != null && mounted) {
      PlaceifyToast.show(context, error);
    }
  }

  List<String> get _categoryOptions {
    final names = furnitureCategories.map((c) => c.name).toList();
    final current = _category;
    if (current != null && !names.contains(current)) {
      return [current, ...names];
    }
    return names;
  }

  @override
  Widget build(BuildContext context) {
    final editorState = ref.watch(vendorProfileEditorProvider);

    ref.listen(vendorProfileEditorProvider, (previous, next) {
      final draft = next.draft;
      if (draft != null) {
        _syncControllers(draft);
      }
      if (previous?.saveError == null && next.saveError != null && mounted) {
        PlaceifyToast.show(context, next.saveError!);
      }
    });

    return PopScope(
      canPop: !editorState.hasUnsavedChanges,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final shouldPop = await _confirmDiscard();
        if (shouldPop && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.cream,
        body: SafeArea(
          child: editorState.isLoading
              ? const _ProfileEditorShimmer()
              : editorState.draft == null
                  ? const _ProfileEditorEmpty()
                  : _buildForm(editorState),
        ),
      ),
    );
  }

  Widget _buildForm(VendorProfileEditorState editorState) {
    final draft = editorState.draft!;
    final category = _category ?? draft.tags.firstOrNull ?? furnitureCategories.first.name;

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 14, 24, 0),
      children: [
        Row(
          children: [
            const Expanded(
              child: Text('Store Profile', style: AppTypography.sectionTitle),
            ),
            if (editorState.isSaving)
              const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            if (editorState.hasUnsavedChanges && !editorState.isSaving)
              Container(
                margin: const EdgeInsets.only(left: 8),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.coral.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  'Unsaved',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.coral,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Changes save automatically when you leave a field.',
          style: AppTypography.bodyLight.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 20),
        _ImagePickerTile(
          label: 'Store banner',
          hint: 'Recommended 3:1 aspect ratio',
          aspectRatio: 3,
          imagePath: editorState.localBannerPath ?? draft.bannerUrl,
          isLocal: editorState.localBannerPath != null,
          onPick: () => _pickImage(isLogo: false),
          onClear: editorState.localBannerPath != null ||
                  draft.bannerUrl != null
              ? () => ref
                  .read(vendorProfileEditorProvider.notifier)
                  .clearLocalBanner()
              : null,
        ),
        const SizedBox(height: 16),
        _ImagePickerTile(
          label: 'Store logo',
          hint: 'Recommended 1:1 aspect ratio',
          aspectRatio: 1,
          imagePath: editorState.localLogoPath ?? draft.logoUrl,
          isLocal: editorState.localLogoPath != null,
          onPick: () => _pickImage(isLogo: true),
          onClear: editorState.localLogoPath != null || draft.logoUrl != null
              ? () => ref
                  .read(vendorProfileEditorProvider.notifier)
                  .clearLocalLogo()
              : null,
        ),
        const SizedBox(height: 8),
        ProfileFormField(
          label: 'Business Name',
          child: ProfileTextInput(
            controller: _businessName,
            hint: 'Your store name',
            onChanged: (v) => _updateDraft((p) => p.copyWith(businessName: v)),
            onEditingComplete: _saveOnBlur,
          ),
        ),
        ProfileFormField(
          label: 'Email',
          child: ProfileTextInput(
            controller: _email,
            hint: 'vendor@example.com',
            keyboardType: TextInputType.emailAddress,
            onChanged: (v) => _updateDraft((p) => p.copyWith(email: v)),
            onEditingComplete: _saveOnBlur,
          ),
        ),
        ProfileFormField(
          label: 'Phone',
          child: PhoneInputField(
            initialPhone: draft.phone,
            onChanged: (full) => _updateDraft((p) => p.copyWith(phone: full)),
            onEditingComplete: _saveOnBlur,
          ),
        ),
        ProfileFormField(
          label: 'Address',
          child: ProfileTextInput(
            controller: _address,
            hint: 'Store location',
            onChanged: (v) => _updateDraft((p) => p.copyWith(address: v)),
            onEditingComplete: _saveOnBlur,
          ),
        ),
        ProfileFormField(
          label: 'Category',
          child: ProfileDropdown(
            value: category,
            items: _categoryOptions,
            onChanged: (value) {
              if (value == null) return;
              setState(() => _category = value);
              _updateDraft((p) => p.copyWith(tags: [value]));
              _saveOnBlur();
            },
          ),
        ),
        ProfileFormField(
          label: 'Bio',
          child: ProfileTextInput(
            controller: _bio,
            hint: 'Tell customers about your store',
            maxLines: 4,
            onChanged: (v) => _updateDraft((p) => p.copyWith(bio: v)),
            onEditingComplete: _saveOnBlur,
          ),
        ),
        ProfileFormField(
          label: 'Instagram',
          child: ProfileTextInput(
            controller: _instagram,
            hint: '@yourstore',
            onChanged: (v) => _updateDraft(
              (p) => p.copyWith(
                socialLinks: p.socialLinks.copyWith(instagram: v),
              ),
            ),
            onEditingComplete: _saveOnBlur,
          ),
        ),
        ProfileFormField(
          label: 'Facebook',
          child: ProfileTextInput(
            controller: _facebook,
            hint: 'facebook.com/yourstore',
            onChanged: (v) => _updateDraft(
              (p) => p.copyWith(
                socialLinks: p.socialLinks.copyWith(facebook: v),
              ),
            ),
            onEditingComplete: _saveOnBlur,
          ),
        ),
        ProfileFormField(
          label: 'Operating Hours',
          child: ProfileTextInput(
            controller: _operatingHours,
            hint: 'Sun–Fri 10:00–18:00',
          ),
        ),
        const SizedBox(height: 8),
        _SettingsLink(
          onTap: () async {
            if (editorState.hasUnsavedChanges) {
              final canLeave = await _confirmDiscard();
              if (!canLeave) return;
            }
            if (!mounted) return;
            context.push(VendorRoutes.settings);
          },
        ),
        const SizedBox(height: BottomNavTokens.scrollBottomPadding),
      ],
    );
  }
}

class _ImagePickerTile extends StatelessWidget {
  const _ImagePickerTile({
    required this.label,
    required this.hint,
    required this.aspectRatio,
    required this.onPick,
    this.imagePath,
    this.isLocal = false,
    this.onClear,
  });

  final String label;
  final String hint;
  final double aspectRatio;
  final String? imagePath;
  final bool isLocal;
  final VoidCallback onPick;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
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
        AspectRatio(
          aspectRatio: aspectRatio,
          child: GestureDetector(
            onTap: onPick,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.warmWhite,
                borderRadius: AppRadii.md,
                border: Border.all(color: AppColors.creamDark, width: 1.5),
              ),
              child: imagePath == null
                  ? Center(
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
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Stack(
                      fit: StackFit.expand,
                      children: [
                        ClipRRect(
                          borderRadius: AppRadii.md,
                          child: isLocal
                              ? Image.file(
                                  File(imagePath!),
                                  fit: BoxFit.cover,
                                )
                              : Image.network(
                                  imagePath!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const Center(
                                    child: Icon(Icons.broken_image_outlined),
                                  ),
                                ),
                        ),
                        if (onClear != null)
                          Positioned(
                            top: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: onClear,
                              child: Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.45),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SettingsLink extends StatelessWidget {
  const _SettingsLink({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticService.light();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.creamDark, width: 1.5),
        ),
        child: const Row(
          children: [
            Icon(Icons.settings_outlined, color: AppColors.espresso, size: 20),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Store settings',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.espresso,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}

class _ProfileEditorShimmer extends StatelessWidget {
  const _ProfileEditorShimmer();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 14, 24, 0),
      children: [
        SizedBox(
          width: 160,
          height: 24,
          child: ShimmerLoader(borderRadius: BorderRadius.circular(8)),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 120,
          child: ShimmerLoader(borderRadius: BorderRadius.circular(14)),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: 96,
          height: 96,
          child: ShimmerLoader(borderRadius: BorderRadius.circular(14)),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 52,
          child: ShimmerLoader(borderRadius: BorderRadius.circular(14)),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 52,
          child: ShimmerLoader(borderRadius: BorderRadius.circular(14)),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 52,
          child: ShimmerLoader(borderRadius: BorderRadius.circular(14)),
        ),
      ],
    );
  }
}

class _ProfileEditorEmpty extends StatelessWidget {
  const _ProfileEditorEmpty();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          'No vendor profile found.',
          style: AppTypography.bodyLight.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
