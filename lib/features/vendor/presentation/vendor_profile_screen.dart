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
import 'package:placeify/features/vendor/presentation/providers/vendor_profile_provider.dart'
    hide VendorProfile;

class _VendorProfileFormState {
  const _VendorProfileFormState({
    this.isLoading = true,
    this.draft,
    this.lastSaved,
    this.isSaving = false,
    this.saveError,
    this.localLogoPath,
    this.localBannerPath,
  });

  final bool isLoading;
  final VendorProfile? draft;
  final VendorProfile? lastSaved;
  final bool isSaving;
  final String? saveError;
  final String? localLogoPath;
  final String? localBannerPath;

  bool get hasUnsavedChanges {
    if (draft == null || lastSaved == null) return false;
    if (localLogoPath != null || localBannerPath != null) return true;
    return draft != lastSaved;
  }

  _VendorProfileFormState copyWith({
    bool? isLoading,
    VendorProfile? draft,
    VendorProfile? lastSaved,
    bool? isSaving,
    String? saveError,
    String? localLogoPath,
    String? localBannerPath,
    bool clearSaveError = false,
    bool clearLocalLogo = false,
    bool clearLocalBanner = false,
  }) {
    return _VendorProfileFormState(
      isLoading: isLoading ?? this.isLoading,
      draft: draft ?? this.draft,
      lastSaved: lastSaved ?? this.lastSaved,
      isSaving: isSaving ?? this.isSaving,
      saveError: clearSaveError ? null : (saveError ?? this.saveError),
      localLogoPath:
          clearLocalLogo ? null : (localLogoPath ?? this.localLogoPath),
      localBannerPath:
          clearLocalBanner ? null : (localBannerPath ?? this.localBannerPath),
    );
  }
}

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
  _VendorProfileFormState _formState = const _VendorProfileFormState();

  @override
  void initState() {
    super.initState();
    _businessName = TextEditingController();
    _email = TextEditingController();
    _address = TextEditingController();
    _bio = TextEditingController();
    _instagram = TextEditingController();
    _facebook = TextEditingController();
    _operatingHours = TextEditingController();
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
    final draft = _formState.draft;
    if (draft == null) return;
    setState(() {
      _formState = _formState.copyWith(
        draft: updater(draft),
        clearSaveError: true,
      );
    });
  }

  Future<void> _saveOnBlur() async {
    if (!_formState.hasUnsavedChanges || _formState.isSaving) return;

    final draft = _formState.draft;
    final lastSaved = _formState.lastSaved;
    if (draft == null || lastSaved == null) return;

    final optimistic = draft.copyWith(
      logoUrl: _formState.localLogoPath ?? draft.logoUrl,
      bannerUrl: _formState.localBannerPath ?? draft.bannerUrl,
    );

    setState(() {
      _formState = _formState.copyWith(
        draft: optimistic,
        isSaving: true,
        clearSaveError: true,
      );
    });

    try {
      await ref.read(vendorProfileProvider.notifier).updateProfile(optimistic);
      final saved = ref.read(vendorProfileProvider).value ?? optimistic;
      if (!mounted) return;
      setState(() {
        _formState = _formState.copyWith(
          draft: saved,
          lastSaved: saved,
          isSaving: false,
          clearLocalLogo: true,
          clearLocalBanner: true,
        );
      });
    } catch (error) {
      if (!mounted) return;
      final message = error.toString().replaceFirst('Exception: ', '');
      setState(() {
        _formState = _formState.copyWith(
          draft: lastSaved,
          isSaving: false,
          saveError: message,
        );
      });
      PlaceifyToast.show(context, message);
    }
  }

  Future<bool> _confirmDiscard() async {
    final hasUnsaved = _formState.hasUnsavedChanges;
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
      final lastSaved = _formState.lastSaved;
      if (lastSaved != null) {
        setState(() {
          _formState = _formState.copyWith(
            draft: lastSaved,
            clearLocalLogo: true,
            clearLocalBanner: true,
            clearSaveError: true,
          );
        });
        _syncControllers(lastSaved);
      }
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

    setState(() {
      _formState = _formState.copyWith(
        localLogoPath: isLogo ? file.path : _formState.localLogoPath,
        localBannerPath: isLogo ? _formState.localBannerPath : file.path,
        clearSaveError: true,
      );
    });

    try {
      final notifier = ref.read(vendorProfileProvider.notifier);
      if (isLogo) {
        await notifier.updateLogo(file.path);
      } else {
        await notifier.updateBanner(file.path);
      }
      final saved = ref.read(vendorProfileProvider).value;
      if (saved != null && mounted) {
        setState(() {
          _formState = _formState.copyWith(
            draft: saved,
            lastSaved: saved,
            clearLocalLogo: true,
            clearLocalBanner: true,
          );
        });
      }
    } catch (error) {
      if (!mounted) return;
      final message = error.toString().replaceFirst('Exception: ', '');
      setState(() {
        _formState = _formState.copyWith(saveError: message);
      });
      PlaceifyToast.show(context, message);
    }
  }

  void _clearLocalLogo() {
    final draft = _formState.draft;
    if (draft == null) return;
    setState(() {
      _formState = _formState.copyWith(
        draft: draft.copyWith(logoUrl: null),
        clearLocalLogo: true,
      );
    });
    _saveOnBlur();
  }

  void _clearLocalBanner() {
    final draft = _formState.draft;
    if (draft == null) return;
    setState(() {
      _formState = _formState.copyWith(
        draft: draft.copyWith(bannerUrl: null),
        clearLocalBanner: true,
      );
    });
    _saveOnBlur();
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
    final profileAsync = ref.watch(vendorProfileProvider);

    ref.listen(vendorProfileProvider, (previous, next) {
      next.whenData((profile) {
        if (profile == null) {
          if (mounted) {
            setState(() {
              _formState = const _VendorProfileFormState(isLoading: false);
            });
          }
          return;
        }

        final current = _formState;
        if (current.isLoading || current.lastSaved == null) {
          if (mounted) {
            setState(() {
              _formState = _VendorProfileFormState(
                draft: profile,
                lastSaved: profile,
                isLoading: false,
              );
            });
            _syncControllers(profile);
            _category ??= profile.tags.firstOrNull ?? furnitureCategories.first.name;
          }
        }
      });
    });

    final formState = _formState;
    final isLoading = profileAsync.isLoading && formState.isLoading;

    return PopScope(
      canPop: !formState.hasUnsavedChanges,
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
          child: isLoading
              ? const _ProfileEditorShimmer()
              : formState.draft == null
                  ? const _ProfileEditorEmpty()
                  : _buildForm(formState),
        ),
      ),
    );
  }

  Widget _buildForm(_VendorProfileFormState formState) {
    final draft = formState.draft!;
    final category = _category ?? draft.tags.firstOrNull ?? furnitureCategories.first.name;

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 14, 24, 0),
      children: [
        Row(
          children: [
            const Expanded(
              child: Text('Store Profile', style: AppTypography.sectionTitle),
            ),
            if (formState.isSaving)
              const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            if (formState.hasUnsavedChanges && !formState.isSaving)
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
          imagePath: formState.localBannerPath ?? draft.bannerUrl,
          isLocal: formState.localBannerPath != null,
          onPick: () => _pickImage(isLogo: false),
          onClear: formState.localBannerPath != null ||
                  draft.bannerUrl != null
              ? _clearLocalBanner
              : null,
        ),
        const SizedBox(height: 16),
        _ImagePickerTile(
          label: 'Store logo',
          hint: 'Recommended 1:1 aspect ratio',
          aspectRatio: 1,
          imagePath: formState.localLogoPath ?? draft.logoUrl,
          isLocal: formState.localLogoPath != null,
          onPick: () => _pickImage(isLogo: true),
          onClear: formState.localLogoPath != null || draft.logoUrl != null
              ? _clearLocalLogo
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
            if (formState.hasUnsavedChanges) {
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
