import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:placeify_flutter/core/constants/app_colors.dart';
import 'package:placeify_flutter/core/constants/app_typography.dart';
import 'package:placeify_flutter/core/services/background_removal_service.dart';
import 'package:placeify_flutter/core/services/haptic_service.dart';
import 'package:placeify_flutter/core/widgets/animated_scale_tap.dart';
import 'package:placeify_flutter/core/widgets/bottom_nav/bottom_nav_tokens.dart';
import 'package:placeify_flutter/core/widgets/placeify_bottom_sheet.dart';
import 'package:placeify_flutter/core/widgets/shimmer_loader.dart';
import 'package:placeify_flutter/core/widgets/toast_overlay.dart';
import 'package:placeify_flutter/features/auth/presentation/providers/auth_provider.dart';
import 'package:placeify_flutter/features/vendor/domain/constants/vendor_profile_strings.dart';
import 'package:placeify_flutter/features/vendor/domain/constants/vendor_settings_strings.dart';
import 'package:placeify_flutter/features/vendor/domain/enums/vendor_status.dart';
import 'package:placeify_flutter/features/vendor/domain/models/vendor_profile.dart';
import 'package:placeify_flutter/features/vendor/domain/validators/vendor_profile_validator.dart';
import 'package:placeify_flutter/features/vendor/presentation/profile/widgets/crop_guide_overlay.dart';
import 'package:placeify_flutter/features/vendor/presentation/profile/widgets/profile_edit_bottom_bar.dart';
import 'package:placeify_flutter/features/vendor/presentation/profile/widgets/profile_header.dart';
import 'package:placeify_flutter/features/vendor/presentation/profile/widgets/social_links_section.dart';
import 'package:placeify_flutter/features/vendor/presentation/profile/widgets/stats_strip.dart';
import 'package:placeify_flutter/features/vendor/presentation/profile/widgets/store_info_section.dart';
import 'package:placeify_flutter/features/vendor/presentation/providers/vendor_profile_provider.dart'
    hide VendorProfile;

class VendorProfileScreen extends ConsumerStatefulWidget {
  const VendorProfileScreen({super.key});

  @override
  ConsumerState<VendorProfileScreen> createState() =>
      _VendorProfileScreenState();
}

class _VendorProfileScreenState extends ConsumerState<VendorProfileScreen> {
  static const _switchDuration = Duration(milliseconds: 200);

  late final TextEditingController _businessName;
  late final TextEditingController _email;
  late final TextEditingController _address;
  late final TextEditingController _bio;
  late final TextEditingController _instagram;
  late final TextEditingController _facebook;
  late final TextEditingController _website;

  final _imagePicker = ImagePicker();
  final _bgRemovalService = BackgroundRemovalService();

  bool _isEditMode = false;
  bool _isDirty = false;
  bool _isSaving = false;
  bool _isLogoLoading = false;
  bool _isBannerLoading = false;
  VendorProfile? _baseline;
  VendorProfile? _form;
  String? _pendingLogoPath;
  String? _pendingBannerPath;
  Map<String, String> _fieldErrors = {};

  @override
  void initState() {
    super.initState();
    _businessName = TextEditingController();
    _email = TextEditingController();
    _address = TextEditingController();
    _bio = TextEditingController();
    _instagram = TextEditingController();
    _facebook = TextEditingController();
    _website = TextEditingController();
  }

  @override
  void dispose() {
    _businessName.dispose();
    _email.dispose();
    _address.dispose();
    _bio.dispose();
    _instagram.dispose();
    _facebook.dispose();
    _website.dispose();
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
    setIfDifferent(_website, profile.socialLinks.website);
  }

  void _initializeFromProfile(VendorProfile profile) {
    _baseline = profile;
    _form = profile;
    _syncControllers(profile);
    _pendingLogoPath = null;
    _pendingBannerPath = null;
    _isDirty = false;
    _fieldErrors = {};
  }

  void _markDirty() {
    if (!_isDirty) setState(() => _isDirty = true);
  }

  void _updateForm(VendorProfile Function(VendorProfile) updater) {
    final current = _form;
    if (current == null) return;
    setState(() {
      _form = updater(current);
      _fieldErrors = {};
    });
    _markDirty();
  }

  VendorProfile _buildFormProfile() {
    final current = _form!;
    return current.copyWith(
      businessName: _businessName.text,
      email: _email.text.trim(),
      address: _address.text,
      bio: _bio.text,
      phone: current.phone,
      socialLinks: current.socialLinks.copyWith(
        instagram: _instagram.text,
        facebook: _facebook.text,
        website: _website.text,
      ),
      logoUrl: _pendingLogoPath ?? current.logoUrl,
      bannerUrl: _pendingBannerPath ?? current.bannerUrl,
    );
  }

  bool get _blockPop => _isEditMode && _isDirty;

  Future<void> _enterEditMode() async {
    HapticService.light();
    setState(() => _isEditMode = true);
  }

  Future<void> _exitEditMode() async {
    setState(() {
      _isEditMode = false;
      _fieldErrors = {};
    });
  }

  Future<bool> _confirmDiscard() async {
    if (!_isDirty) return true;

    final shouldDiscard = await PlaceifyBottomSheet.show<bool>(
      context,
      builder: (sheetContext) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const PlaceifyBottomSheetHeader(
              title: VendorProfileStrings.discardTitle,
              subtitle: VendorProfileStrings.discardSubtitle,
            ),
            const SizedBox(height: 20),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.coral,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () => Navigator.pop(sheetContext, true),
              child: const Text(VendorProfileStrings.discardChanges),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () => Navigator.pop(sheetContext, false),
              child: const Text(VendorProfileStrings.keepEditing),
            ),
          ],
        );
      },
    );

    if (shouldDiscard == true) {
      _revertToBaseline();
      return true;
    }
    return false;
  }

  void _revertToBaseline() {
    final baseline = _baseline;
    if (baseline == null) return;
    setState(() {
      _form = baseline;
      _pendingLogoPath = null;
      _pendingBannerPath = null;
      _isDirty = false;
      _fieldErrors = {};
    });
    _syncControllers(baseline);
  }

  Future<void> _handleCancel() async {
    if (!_isDirty) {
      await _exitEditMode();
      return;
    }
    final discard = await _confirmDiscard();
    if (discard && mounted) {
      await _exitEditMode();
    }
  }

  Future<void> _handleSave() async {
    final candidate = _buildFormProfile();
    final errors = VendorProfileValidator.validate(candidate);
    if (errors.isNotEmpty) {
      setState(() => _fieldErrors = errors);
      PlaceifyToast.show(context, VendorProfileStrings.fixValidationErrors);
      return;
    }

    setState(() {
      _isSaving = true;
      _fieldErrors = {};
    });

    try {
      await ref.read(vendorProfileProvider.notifier).updateProfile(candidate);
      final saved = ref.read(vendorProfileProvider).value ?? candidate;
      if (!mounted) return;

      HapticService.medium();
      PlaceifyToast.show(context, VendorProfileStrings.profileUpdated);
      setState(() {
        _baseline = saved;
        _form = saved;
        _pendingLogoPath = null;
        _pendingBannerPath = null;
        _isDirty = false;
        _isSaving = false;
        _isEditMode = false;
      });
      _syncControllers(saved);
    } catch (error) {
      if (!mounted) return;
      final message = error.toString().replaceFirst('Exception: ', '');
      setState(() => _isSaving = false);
      PlaceifyToast.show(context, message);
    }
  }

  Future<void> _showImagePickerSheet({required bool isLogo}) async {
    HapticService.light();
    await PlaceifyBottomSheet.show<void>(
      context,
      builder: (sheetContext) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PlaceifyBottomSheetHeader(
              title: isLogo
                  ? VendorProfileStrings.changeLogo
                  : VendorProfileStrings.changeBanner,
            ),
            const SizedBox(height: 12),
            PlaceifySelectTile(
              label: VendorProfileStrings.chooseFromGallery,
              selected: false,
              icon: Icons.photo_library_outlined,
              onTap: () async {
                Navigator.pop(sheetContext);
                await _pickFromGallery(isLogo: isLogo);
              },
            ),
            if (isLogo) ...[
              const SizedBox(height: 4),
              PlaceifySelectTile(
                label: VendorProfileStrings.removeBackground,
                selected: false,
                icon: Icons.auto_fix_high_outlined,
                onTap: () async {
                  Navigator.pop(sheetContext);
                  await _removeLogoBackground();
                },
              ),
            ],
            const SizedBox(height: 4),
            PlaceifySelectTile(
              label: VendorProfileStrings.cancel,
              selected: false,
              onTap: () => Navigator.pop(sheetContext),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickFromGallery({required bool isLogo}) async {
    final file = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (file == null || !mounted) return;

    final confirmed = await _showCropPreview(
      path: file.path,
      aspectRatio: isLogo ? 1 : 3,
    );
    if (!confirmed || !mounted) return;

    setState(() {
      if (isLogo) {
        _pendingLogoPath = file.path;
        _isLogoLoading = true;
      } else {
        _pendingBannerPath = file.path;
        _isBannerLoading = true;
      }
    });
    _markDirty();

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
          _baseline = saved;
          _form = saved;
          _pendingLogoPath = null;
          _pendingBannerPath = null;
          _isLogoLoading = false;
          _isBannerLoading = false;
        });
      }
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _isLogoLoading = false;
        _isBannerLoading = false;
      });
      PlaceifyToast.show(
        context,
        error.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<void> _removeLogoBackground() async {
    final sourcePath = _pendingLogoPath ?? _form?.logoUrl;
    if (sourcePath == null || sourcePath.startsWith('http')) {
      PlaceifyToast.show(context, 'Choose a logo image first.');
      return;
    }

    setState(() => _isLogoLoading = true);
    try {
      final result = await _bgRemovalService.removeBackground(
        sourcePath: sourcePath,
      );
      if (!mounted) return;
      setState(() {
        _pendingLogoPath = result.processedPath;
        _isLogoLoading = false;
      });
      _markDirty();
      await ref.read(vendorProfileProvider.notifier).updateLogo(result.processedPath);
    } catch (error) {
      if (!mounted) return;
      setState(() => _isLogoLoading = false);
      PlaceifyToast.show(
        context,
        error.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<bool> _showCropPreview({
    required String path,
    required double aspectRatio,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.7),
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AspectRatio(
                aspectRatio: aspectRatio,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(File(path), fit: BoxFit.cover),
                    ),
                    CropGuideOverlay(aspectRatio: aspectRatio),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(dialogContext, false),
                      child: const Text(VendorProfileStrings.cancel),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.vendorForest,
                      ),
                      onPressed: () => Navigator.pop(dialogContext, true),
                      child: const Text('Use photo'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
    return result ?? false;
  }

  Future<void> _openSettings() async {
    if (_isEditMode && _isDirty) {
      final canLeave = await _confirmDiscard();
      if (!canLeave) return;
      await _exitEditMode();
    }
    if (!mounted) return;
    context.pushNamed('vendorSettings');
  }

  Future<void> _signOut() async {
    HapticService.light();
    await ref.read(currentUserProvider.notifier).signOut();
    if (!mounted) return;
    PlaceifyToast.show(context, VendorSettingsStrings.signedOut);
    context.go('/splash');
  }

  void _switchToShopping() {
    HapticService.light();
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(vendorProfileProvider);
    final userAsync = ref.watch(currentUserProvider);

    ref.listen(vendorProfileProvider, (previous, next) {
      next.whenData((profile) {
        if (profile == null || !mounted) return;
        if (_baseline == null) {
          setState(() => _initializeFromProfile(profile));
        }
      });
    });

    final profile = profileAsync.value;
    if (profile != null && _form == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _form == null) {
          setState(() => _initializeFromProfile(profile));
        }
      });
    }

    final isLoading = profileAsync.isLoading && _form == null;
    final showActiveBadge =
        userAsync.value?.vendorStatus == VendorStatus.approved;

    return PopScope(
      canPop: !_blockPop,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final shouldPop = await _confirmDiscard();
        if (shouldPop && context.mounted) {
          await _exitEditMode();
          if (context.mounted) Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.cream,
        body: SafeArea(
          child: isLoading
              ? const _ProfileShimmer()
              : _form == null
                  ? const _ProfileEmpty()
                  : Column(
                      children: [
                        Expanded(
                          child: AnimatedSwitcher(
                            duration: _switchDuration,
                            child: _isEditMode
                                ? _buildBody(
                                    key: const ValueKey('edit'),
                                    isEditMode: true,
                                    showActiveBadge: showActiveBadge,
                                  )
                                : _buildBody(
                                    key: const ValueKey('view'),
                                    isEditMode: false,
                                    showActiveBadge: showActiveBadge,
                                  ),
                          ),
                        ),
                        if (_isEditMode)
                          ProfileEditBottomBar(
                            isSaving: _isSaving,
                            onSave: _handleSave,
                            onCancel: _handleCancel,
                          ),
                      ],
                    ),
        ),
      ),
    );
  }

  Widget _buildBody({
    required Key key,
    required bool isEditMode,
    required bool showActiveBadge,
  }) {
    final form = _form!;
    final memberSince = VendorProfileStrings.memberSince(form.createdAt);

    return ListView(
      key: key,
      padding: EdgeInsets.fromLTRB(
        18,
        14,
        18,
        _isEditMode ? 16 : BottomNavTokens.scrollBottomPadding,
      ),
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                VendorProfileStrings.screenTitle,
                style: AppTypography.sectionTitle,
              ),
            ),
            if (!isEditMode)
              AnimatedScaleTap(
                onTap: _enterEditMode,
                child: const Text(
                  VendorProfileStrings.editProfile,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.accent,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 20),
        ProfileHeader(
          businessName: form.businessName,
          memberSinceText: memberSince,
          showActiveBadge: showActiveBadge,
          isEditMode: isEditMode,
          bannerPath: _pendingBannerPath ?? form.bannerUrl,
          logoPath: _pendingLogoPath ?? form.logoUrl,
          bannerIsLocal: _pendingBannerPath != null,
          logoIsLocal: _pendingLogoPath != null,
          isBannerLoading: _isBannerLoading,
          isLogoLoading: _isLogoLoading,
          nameController: isEditMode ? _businessName : null,
          nameError: _fieldErrors[VendorProfileFieldKeys.businessName],
          onBusinessNameChanged: isEditMode
              ? (value) => _updateForm((p) => p.copyWith(businessName: value))
              : null,
          onBannerTap:
              isEditMode ? () => _showImagePickerSheet(isLogo: false) : null,
          onLogoTap: isEditMode ? () => _showImagePickerSheet(isLogo: true) : null,
        ),
        const SizedBox(height: 20),
        const ProfileStatsStrip(),
        const SizedBox(height: 20),
        StoreInfoSection(
          profile: form,
          isEditMode: isEditMode,
          fieldErrors: _fieldErrors,
          bioController: isEditMode ? _bio : null,
          emailController: isEditMode ? _email : null,
          addressController: isEditMode ? _address : null,
          onBioChanged: isEditMode
              ? (value) => _updateForm((p) => p.copyWith(bio: value))
              : null,
          onEmailChanged: isEditMode
              ? (value) => _updateForm((p) => p.copyWith(email: value))
              : null,
          onAddressChanged: isEditMode
              ? (value) => _updateForm((p) => p.copyWith(address: value))
              : null,
          onPhoneChanged: isEditMode
              ? (value) => _updateForm((p) => p.copyWith(phone: value))
              : null,
          onTagsChanged: isEditMode
              ? (tags) => _updateForm((p) => p.copyWith(tags: tags))
              : null,
          onScheduleChanged: isEditMode
              ? (schedule) => _updateForm((p) => p.copyWith(schedule: schedule))
              : null,
        ),
        const SizedBox(height: 14),
        SocialLinksSection(
          socialLinks: form.socialLinks,
          isEditMode: isEditMode,
          fieldErrors: _fieldErrors,
          instagramController: isEditMode ? _instagram : null,
          facebookController: isEditMode ? _facebook : null,
          websiteController: isEditMode ? _website : null,
          onInstagramChanged: isEditMode
              ? (value) => _updateForm(
                    (p) => p.copyWith(
                      socialLinks: p.socialLinks.copyWith(instagram: value),
                    ),
                  )
              : null,
          onFacebookChanged: isEditMode
              ? (value) => _updateForm(
                    (p) => p.copyWith(
                      socialLinks: p.socialLinks.copyWith(facebook: value),
                    ),
                  )
              : null,
          onWebsiteChanged: isEditMode
              ? (value) => _updateForm(
                    (p) => p.copyWith(
                      socialLinks: p.socialLinks.copyWith(website: value),
                    ),
                  )
              : null,
        ),
        const SizedBox(height: 14),
        _SettingsLink(onTap: _openSettings),
        if (!isEditMode) ...[
          const SizedBox(height: 10),
          _SwitchToShoppingLink(onTap: _switchToShopping),
          const SizedBox(height: 10),
          _SignOutLink(onTap: _signOut),
        ],
      ],
    );
  }
}

class _SettingsLink extends StatelessWidget {
  const _SettingsLink({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedScaleTap(
      onTap: onTap,
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
                VendorProfileStrings.storeSettings,
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

class _SwitchToShoppingLink extends StatelessWidget {
  const _SwitchToShoppingLink({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedScaleTap(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.creamDark, width: 1.5),
        ),
        child: const Row(
          children: [
            Icon(Icons.storefront_outlined, color: AppColors.espresso, size: 20),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                VendorProfileStrings.switchToShopping,
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

class _SignOutLink extends StatelessWidget {
  const _SignOutLink({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedScaleTap(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.creamDark, width: 1.5),
        ),
        child: const Row(
          children: [
            Icon(Icons.logout_outlined, color: AppColors.coral, size: 20),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                VendorSettingsStrings.signOutTitle,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.coral,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: AppColors.coral),
          ],
        ),
      ),
    );
  }
}

class _ProfileShimmer extends StatelessWidget {
  const _ProfileShimmer();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 0),
      children: [
        SizedBox(
          width: 160,
          height: 24,
          child: ShimmerLoader(borderRadius: BorderRadius.circular(8)),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 120,
          child: ShimmerLoader(borderRadius: BorderRadius.circular(14)),
        ),
        const SizedBox(height: 60),
        SizedBox(
          height: 52,
          child: ShimmerLoader(borderRadius: BorderRadius.circular(14)),
        ),
      ],
    );
  }
}

class _ProfileEmpty extends StatelessWidget {
  const _ProfileEmpty();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 100),
        child: Text(
          VendorProfileStrings.noProfileFound,
          textAlign: TextAlign.center,
          style: AppTypography.bodyLight.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
