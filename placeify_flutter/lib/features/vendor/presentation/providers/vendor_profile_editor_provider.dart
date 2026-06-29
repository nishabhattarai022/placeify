import 'package:placeify_flutter/features/auth/presentation/providers/auth_provider.dart';
import 'package:placeify_flutter/features/vendor/domain/enums/vendor_status.dart';
import 'package:placeify_flutter/features/vendor/domain/models/vendor_profile.dart'
    as models;
import 'package:placeify_flutter/features/vendor/domain/models/vendor_profile_editor_state.dart';
import 'package:placeify_flutter/features/vendor/presentation/providers/vendor_profile_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'vendor_profile_editor_provider.g.dart';

@Riverpod(keepAlive: true)
class VendorProfileEditor extends _$VendorProfileEditor {
  @override
  VendorProfileEditorState build() {
    ref.listen(vendorProfileProvider, (previous, next) {
      next.whenData((profile) {
        if (profile == null) return;
        final current = state;
        if (current.isLoading || current.lastSaved == null) {
          state = VendorProfileEditorState(
            draft: profile,
            lastSaved: profile,
          );
        }
      });
    });

    _loadProfile();
    return const VendorProfileEditorState();
  }

  Future<void> _loadProfile() async {
    final user = await ref.read(currentUserProvider.future);
    if (user?.vendorStatus != VendorStatus.approved || user?.vendorId == null) {
      state = const VendorProfileEditorState(isLoading: false);
      return;
    }

    try {
      final profile = await ref.read(vendorProfileProvider.future);
      if (profile == null) {
        state = const VendorProfileEditorState(isLoading: false);
        return;
      }
      state = VendorProfileEditorState(
        draft: profile,
        lastSaved: profile,
      );
    } catch (_) {
      state = const VendorProfileEditorState(isLoading: false);
    }
  }

  void updateDraft(
    models.VendorProfile Function(models.VendorProfile current) updater,
  ) {
    final draft = state.draft;
    if (draft == null) return;
    state = state.copyWith(
      draft: updater(draft),
      clearSaveError: true,
    );
  }

  Future<void> saveOnBlur() async {
    if (!state.hasUnsavedChanges || state.isSaving) return;
    await _save();
  }

  void setLocalLogo(String path) {
    state = state.copyWith(localLogoPath: path, clearSaveError: true);
    _save();
  }

  void setLocalBanner(String path) {
    state = state.copyWith(localBannerPath: path, clearSaveError: true);
    _save();
  }

  void clearLocalLogo() {
    final draft = state.draft;
    if (draft == null) return;
    state = state.copyWith(
      draft: draft.copyWith(logoUrl: null),
      clearLocalLogo: true,
    );
    _save();
  }

  void clearLocalBanner() {
    final draft = state.draft;
    if (draft == null) return;
    state = state.copyWith(
      draft: draft.copyWith(bannerUrl: null),
      clearLocalBanner: true,
    );
    _save();
  }

  Future<void> _save() async {
    final draft = state.draft;
    final lastSaved = state.lastSaved;
    if (draft == null || lastSaved == null) return;

    final optimistic = draft.copyWith(
      logoUrl: state.localLogoPath ?? draft.logoUrl,
      bannerUrl: state.localBannerPath ?? draft.bannerUrl,
    );

    state = state.copyWith(
      draft: optimistic,
      isSaving: true,
      clearSaveError: true,
    );

    try {
      final repo = ref.read(vendorRepositoryProvider);
      final saved = await repo.updateProfile(optimistic);
      state = state.copyWith(
        draft: saved,
        lastSaved: saved,
        isSaving: false,
        clearLocalLogo: true,
        clearLocalBanner: true,
      );
      ref.invalidate(vendorProfileProvider);
    } catch (error) {
      state = state.copyWith(
        draft: lastSaved,
        isSaving: false,
        saveError: error.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<bool> discardUnsavedChanges() async {
    final lastSaved = state.lastSaved;
    if (lastSaved == null) return true;
    state = state.copyWith(
      draft: lastSaved,
      clearLocalLogo: true,
      clearLocalBanner: true,
      clearSaveError: true,
    );
    return true;
  }
}

@riverpod
bool vendorProfileHasUnsavedChanges(Ref ref) {
  return ref.watch(vendorProfileEditorProvider).hasUnsavedChanges;
}
