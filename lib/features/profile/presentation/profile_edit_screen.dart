import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radii.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/app_fonts.dart';
import '../../../core/widgets/bottom_nav/bottom_nav_tokens.dart';
import '../../../core/widgets/phone_input_field.dart';
import '../../../core/widgets/toast_overlay.dart';
import '../../auth/domain/models/consumer_profile_details.dart';
import '../../auth/domain/repositories/auth_repository.dart';
import '../../auth/presentation/providers/auth_provider.dart';
import '../../home/presentation/chairs_catalog_tokens.dart';
import '../data/profile_menu_config.dart';
import '../domain/constants/edit_profile_strings.dart';
import 'widgets/profile_list_screen_header.dart';
import 'widgets/shared/profile_action_button.dart';

class ProfileEditScreen extends ConsumerStatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  ConsumerState<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _bioController = TextEditingController();
  final _cityController = TextEditingController();

  String _phone = '';
  bool _loading = true;
  bool _saving = false;
  String? _nameError;
  String? _emailError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadProfile());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    final profile =
        await ref.read(currentUserProvider.notifier).loadConsumerProfile();
    if (!mounted) return;

    if (profile == null) {
      setState(() => _loading = false);
      return;
    }

    _applyProfile(profile);
    setState(() => _loading = false);
  }

  void _applyProfile(ConsumerProfileDetails profile) {
    _nameController.text = profile.fullName;
    _usernameController.text = profile.username;
    _emailController.text = profile.email;
    _phone = profile.phone;
    _bioController.text = profile.bio;
    _cityController.text = profile.city;
  }

  bool _validate() {
    var valid = true;
    String? nameError;
    String? emailError;

    if (_nameController.text.trim().isEmpty) {
      nameError = EditProfileStrings.nameRequired;
      valid = false;
    }

    final email = _emailController.text.trim();
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (email.isEmpty) {
      emailError = EditProfileStrings.emailRequired;
      valid = false;
    } else if (!emailRegex.hasMatch(email)) {
      emailError = EditProfileStrings.emailInvalid;
      valid = false;
    }

    setState(() {
      _nameError = nameError;
      _emailError = emailError;
    });
    return valid;
  }

  Future<void> _save() async {
    if (!_validate() || _saving) return;

    setState(() => _saving = true);
    try {
      final profile = ConsumerProfileDetails(
        fullName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        username: _usernameController.text.trim(),
        phone: _phone.trim(),
        bio: _bioController.text.trim(),
        city: _cityController.text.trim(),
      );

      await ref
          .read(currentUserProvider.notifier)
          .updateConsumerProfile(profile);
      if (!mounted) return;

      PlaceifyToast.show(context, EditProfileStrings.updatedToast);
      Future.delayed(const Duration(milliseconds: 900), () {
        if (mounted) context.pop();
      });
    } on AuthException catch (e) {
      if (!mounted) return;
      PlaceifyToast.show(context, e.message);
    } catch (_) {
      if (!mounted) return;
      PlaceifyToast.show(context, EditProfileStrings.updateFailed);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider).value;
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final initial = user != null && user.fullName.isNotEmpty
        ? user.fullName.trim()[0].toUpperCase()
        : '?';

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const ProfileListScreenHeader(
              title: EditProfileStrings.title,
              subtitle: EditProfileStrings.italicLine,
            ),
            Expanded(
              child: _loading
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.black),
                    )
                  : user == null
                      ? const _SignedOutState()
                      : ListView(
                          padding: EdgeInsets.fromLTRB(
                            AppSpacing.screenPadding,
                            12,
                            AppSpacing.screenPadding,
                            BottomNavTokens.scrollBottomPadding + bottomInset,
                          ),
                          children: [
                            _ProfilePhotoHeader(
                              initial: initial,
                              onChangePhoto: () => PlaceifyToast.show(
                                context,
                                EditProfileStrings.photoComingSoon,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: ChairsCatalogTokens.imageWell,
                                borderRadius: BorderRadius.circular(
                                  ChairsCatalogTokens.wideCardRadius,
                                ),
                                boxShadow: ChairsCatalogTokens.cardShadow,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _EditFormField(
                                    label: EditProfileStrings.fullName,
                                    error: _nameError,
                                    child: _EditTextField(
                                      controller: _nameController,
                                      hint: EditProfileStrings.fullNameHint,
                                      hasError: _nameError != null,
                                      onChanged: (_) {
                                        if (_nameError != null) {
                                          setState(() => _nameError = null);
                                        }
                                      },
                                    ),
                                  ),
                                  _EditFormField(
                                    label: EditProfileStrings.username,
                                    child: _EditTextField(
                                      controller: _usernameController,
                                      hint: EditProfileStrings.usernameHint,
                                    ),
                                  ),
                                  _EditFormField(
                                    label: EditProfileStrings.bio,
                                    child: _EditTextField(
                                      controller: _bioController,
                                      hint: EditProfileStrings.bioHint,
                                      maxLines: 3,
                                    ),
                                  ),
                                  _EditFormField(
                                    label: EditProfileStrings.city,
                                    child: _EditTextField(
                                      controller: _cityController,
                                      hint: EditProfileStrings.cityHint,
                                    ),
                                  ),
                                  _EditFormField(
                                    label: EditProfileStrings.email,
                                    error: _emailError,
                                    child: _EditTextField(
                                      controller: _emailController,
                                      hint: EditProfileStrings.emailHint,
                                      keyboardType:
                                          TextInputType.emailAddress,
                                      hasError: _emailError != null,
                                      onChanged: (_) {
                                        if (_emailError != null) {
                                          setState(() => _emailError = null);
                                        }
                                      },
                                    ),
                                  ),
                                  _EditFormField(
                                    label: EditProfileStrings.phone,
                                    child: PhoneInputField(
                                      initialPhone:
                                          _phone.isNotEmpty ? _phone : null,
                                      onChanged: (value) => _phone = value,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: ProfileActionButton(
                                label: _saving
                                    ? EditProfileStrings.saving
                                    : EditProfileStrings.saveChanges,
                                onTap: _saving ? () {} : _save,
                              ),
                            ),
                          ],
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfilePhotoHeader extends StatelessWidget {
  const _ProfilePhotoHeader({
    required this.initial,
    required this.onChangePhoto,
  });

  final String initial;
  final VoidCallback onChangePhoto;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: ProfileMenuConfig.avatarSize,
          height: ProfileMenuConfig.avatarSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black,
            border: Border.all(
              color: Colors.black.withValues(alpha: 0.08),
              width: 3,
            ),
            image: initial == '?'
                ? const DecorationImage(
                    image: AssetImage(ProfileMenuConfig.avatarAsset),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          alignment: Alignment.center,
          child: initial == '?'
              ? null
              : Text(
                  initial,
                  style: AppFonts.dmSans(
                    fontSize: 40,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: onChangePhoto,
          child: Text(
            EditProfileStrings.changePhoto,
            style: AppFonts.dmSans(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}

class _EditFormField extends StatelessWidget {
  const _EditFormField({
    required this.label,
    required this.child,
    this.error,
  });

  final String label;
  final Widget child;
  final String? error;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppFonts.dmSans(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: error != null ? AppColors.coral : AppColors.textPrimary,
              letterSpacing: -0.1,
            ),
          ),
          const SizedBox(height: 8),
          child,
          if (error != null) ...[
            const SizedBox(height: 6),
            Text(
              error!,
              style: AppFonts.dmSans(
                fontSize: 12,
                color: AppColors.coral,
                height: 1.35,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _EditTextField extends StatelessWidget {
  const _EditTextField({
    required this.controller,
    required this.hint,
    this.maxLines = 1,
    this.keyboardType,
    this.hasError = false,
    this.onChanged,
  });

  final TextEditingController controller;
  final String hint;
  final int maxLines;
  final TextInputType? keyboardType;
  final bool hasError;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final borderColor = hasError
        ? AppColors.coral
        : Colors.black.withValues(alpha: 0.08);
    final focusedColor = hasError ? AppColors.coral : Colors.black;

    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      onChanged: onChanged,
      style: AppFonts.dmSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppFonts.dmSans(
          fontSize: 14,
          color: Colors.black.withValues(alpha: 0.35),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: AppRadii.md,
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadii.md,
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadii.md,
          borderSide: BorderSide(color: focusedColor, width: 1.5),
        ),
      ),
    );
  }
}

class _SignedOutState extends StatelessWidget {
  const _SignedOutState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              EditProfileStrings.signedOutTitle,
              textAlign: TextAlign.center,
              style: AppFonts.dmSans(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ProfileActionButton(
                label: EditProfileStrings.goToSignIn,
                onTap: () => context.go('/login'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
