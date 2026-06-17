import 'package:placeify_flutter/features/vendor/domain/models/vendor_profile.dart';

class VendorProfileEditorState {
  const VendorProfileEditorState({
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

  VendorProfileEditorState copyWith({
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
    return VendorProfileEditorState(
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
