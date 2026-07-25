import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/config/resolve_media_url.dart';
import '../../../core/constants/app_colors.dart';
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
import 'providers/consumer_profile_provider.dart';
import 'widgets/profile_list_screen_header.dart';
import 'widgets/shared/profile_action_button.dart';

final _dateOfBirthPattern = RegExp(r'^\d{4}-\d{2}-\d{2}$');

class ProfileEditScreen extends ConsumerStatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  ConsumerState<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _bioController = TextEditingController();
  final _dateOfBirthController = TextEditingController();
  final _addressLine1Controller = TextEditingController();
  final _addressLine2Controller = TextEditingController();
  final _cityController = TextEditingController();
  final _districtController = TextEditingController();
  final _provinceController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _countryController = TextEditingController();
  final _preferredLanguageController = TextEditingController();
  final _defaultDeliveryAddressController = TextEditingController();
  final _imagePicker = ImagePicker();

  String _phone = '';
  String _gender = EditProfileStrings.genders.first;
  String _profileImageUrl = '';
  bool _loading = true;
  bool _saving = false;
  bool _uploadingPhoto = false;
  String? _nameError;
  String? _dateOfBirthError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadProfile());
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _fullNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    _dateOfBirthController.dispose();
    _addressLine1Controller.dispose();
    _addressLine2Controller.dispose();
    _cityController.dispose();
    _districtController.dispose();
    _provinceController.dispose();
    _postalCodeController.dispose();
    _countryController.dispose();
    _preferredLanguageController.dispose();
    _defaultDeliveryAddressController.dispose();
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

    await _applyProfile(profile);
    setState(() => _loading = false);
  }

  Future<void> _applyProfile(ConsumerProfileDetails profile) async {
    _firstNameController.text = profile.firstName;
    _lastNameController.text = profile.lastName;
    _fullNameController.text = profile.fullName;
    _usernameController.text = profile.username;
    _emailController.text = profile.email;
    _phone = profile.phone;
    _bioController.text = profile.bio;
    _dateOfBirthController.text = profile.dateOfBirth;
    _addressLine1Controller.text = profile.addressLine1;
    _addressLine2Controller.text = profile.addressLine2;
    _cityController.text = profile.city;
    _districtController.text = profile.district;
    _provinceController.text = profile.province;
    _postalCodeController.text = profile.postalCode;
    _countryController.text = profile.country;
    _preferredLanguageController.text = profile.preferredLanguage;
    _defaultDeliveryAddressController.text = profile.defaultDeliveryAddress;

    final gender = profile.gender.trim();
    _gender = gender.isEmpty || !EditProfileStrings.genders.contains(gender)
        ? EditProfileStrings.genders.first
        : gender;

    final image = profile.profileImageUrl.trim();
    _profileImageUrl =
        image.isEmpty ? '' : await resolveMediaUrl(image);
  }

  String _resolvedFullName() {
    final first = _firstNameController.text.trim();
    final last = _lastNameController.text.trim();
    if (first.isNotEmpty || last.isNotEmpty) {
      return [first, last].where((part) => part.isNotEmpty).join(' ');
    }
    return _fullNameController.text.trim();
  }

  void _syncFullNameFromParts() {
    final first = _firstNameController.text.trim();
    final last = _lastNameController.text.trim();
    if (first.isNotEmpty || last.isNotEmpty) {
      _fullNameController.text =
          [first, last].where((part) => part.isNotEmpty).join(' ');
    }
  }

  bool _validate() {
    String? nameError;
    String? dateOfBirthError;

    if (_resolvedFullName().isEmpty) {
      nameError = EditProfileStrings.nameRequired;
    }

    final dob = _dateOfBirthController.text.trim();
    if (dob.isNotEmpty && !_dateOfBirthPattern.hasMatch(dob)) {
      dateOfBirthError = EditProfileStrings.dateOfBirthInvalid;
    }

    setState(() {
      _nameError = nameError;
      _dateOfBirthError = dateOfBirthError;
    });
    return nameError == null && dateOfBirthError == null;
  }

  Future<void> _changePhoto() async {
    if (_uploadingPhoto) return;
    final picked = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1200,
      maxHeight: 1200,
      imageQuality: 88,
    );
    if (picked == null || !mounted) return;

    setState(() => _uploadingPhoto = true);
    final error = await ref
        .read(consumerProfileProvider.notifier)
        .uploadProfileImage(picked.path);
    if (!mounted) return;

    if (error != null) {
      PlaceifyToast.show(context, error);
      setState(() => _uploadingPhoto = false);
      return;
    }

    final user = ref.read(consumerProfileProvider).value;
    final url = user?.profileImageUrl?.trim() ?? '';
    var resolved = url;
    if (url.isNotEmpty) {
      resolved = await resolveMediaUrl(url);
    }
    if (!mounted) return;
    setState(() {
      _uploadingPhoto = false;
      _profileImageUrl = resolved;
    });
    PlaceifyToast.show(context, EditProfileStrings.photoUpdated);
  }

  Future<void> _save() async {
    if (!_validate() || _saving) return;

    setState(() => _saving = true);
    try {
      final profile = ConsumerProfileDetails(
        fullName: _fullNameController.text.trim(),
        email: _emailController.text.trim(),
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        username: _usernameController.text.trim(),
        phone: _phone.trim(),
        bio: _bioController.text.trim(),
        gender: _gender.trim(),
        dateOfBirth: _dateOfBirthController.text.trim(),
        addressLine1: _addressLine1Controller.text.trim(),
        addressLine2: _addressLine2Controller.text.trim(),
        city: _cityController.text.trim(),
        district: _districtController.text.trim(),
        province: _provinceController.text.trim(),
        postalCode: _postalCodeController.text.trim(),
        country: _countryController.text.trim(),
        preferredLanguage: _preferredLanguageController.text.trim(),
        defaultDeliveryAddress: _defaultDeliveryAddressController.text.trim(),
        profileImageUrl: _profileImageUrl,
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
    final displayName = _resolvedFullName();
    final initial = displayName.isNotEmpty
        ? displayName[0].toUpperCase()
        : user != null && user.fullName.isNotEmpty
            ? user.fullName.trim()[0].toUpperCase()
            : '?';

    return Scaffold(
      backgroundColor: const Color(0xFFF7F4EF),
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
                            8,
                            AppSpacing.screenPadding,
                            BottomNavTokens.scrollBottomPadding + bottomInset,
                          ),
                          children: [
                            _ProfilePhotoHeader(
                              initial: initial,
                              imageUrl: _profileImageUrl,
                              uploading: _uploadingPhoto,
                              onChangePhoto: _changePhoto,
                            ),
                            const SizedBox(height: 22),
                            _EditSectionCard(
                              title: EditProfileStrings.personalSection,
                              subtitle: EditProfileStrings.personalSectionHint,
                              children: [
                                _EditFormField(
                                  label: EditProfileStrings.firstName,
                                  child: _EditTextField(
                                    controller: _firstNameController,
                                    hint: EditProfileStrings.firstNameHint,
                                    onChanged: (_) {
                                      _syncFullNameFromParts();
                                      if (_nameError != null) {
                                        setState(() => _nameError = null);
                                      }
                                    },
                                  ),
                                ),
                                _EditFormField(
                                  label: EditProfileStrings.lastName,
                                  child: _EditTextField(
                                    controller: _lastNameController,
                                    hint: EditProfileStrings.lastNameHint,
                                    onChanged: (_) {
                                      _syncFullNameFromParts();
                                      if (_nameError != null) {
                                        setState(() => _nameError = null);
                                      }
                                    },
                                  ),
                                ),
                                _EditFormField(
                                  label: EditProfileStrings.fullName,
                                  error: _nameError,
                                  child: _EditTextField(
                                    controller: _fullNameController,
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
                                  label: EditProfileStrings.gender,
                                  child: _EditDropdownField(
                                    value: _gender,
                                    items: EditProfileStrings.genders,
                                    onChanged: (value) {
                                      if (value == null) return;
                                      setState(() => _gender = value);
                                    },
                                  ),
                                ),
                                _EditFormField(
                                  label: EditProfileStrings.dateOfBirth,
                                  error: _dateOfBirthError,
                                  child: _EditTextField(
                                    controller: _dateOfBirthController,
                                    hint: EditProfileStrings.dateOfBirthHint,
                                    keyboardType: TextInputType.datetime,
                                    hasError: _dateOfBirthError != null,
                                    onChanged: (_) {
                                      if (_dateOfBirthError != null) {
                                        setState(() => _dateOfBirthError = null);
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 22),
                            _EditSectionCard(
                              title: EditProfileStrings.contactSection,
                              children: [
                                _EditFormField(
                                  label: EditProfileStrings.email,
                                  helper: EditProfileStrings.emailReadOnlyHint,
                                  child: _EditTextField(
                                    controller: _emailController,
                                    hint: EditProfileStrings.emailHint,
                                    keyboardType: TextInputType.emailAddress,
                                    readOnly: true,
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
                            const SizedBox(height: 22),
                            _EditSectionCard(
                              title: EditProfileStrings.addressSection,
                              children: [
                                _EditFormField(
                                  label: EditProfileStrings.addressLine1,
                                  child: _EditTextField(
                                    controller: _addressLine1Controller,
                                    hint: EditProfileStrings.addressLine1Hint,
                                  ),
                                ),
                                _EditFormField(
                                  label: EditProfileStrings.addressLine2,
                                  child: _EditTextField(
                                    controller: _addressLine2Controller,
                                    hint: EditProfileStrings.addressLine2Hint,
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
                                  label: EditProfileStrings.district,
                                  child: _EditTextField(
                                    controller: _districtController,
                                    hint: EditProfileStrings.districtHint,
                                  ),
                                ),
                                _EditFormField(
                                  label: EditProfileStrings.province,
                                  child: _EditTextField(
                                    controller: _provinceController,
                                    hint: EditProfileStrings.provinceHint,
                                  ),
                                ),
                                _EditFormField(
                                  label: EditProfileStrings.postalCode,
                                  child: _EditTextField(
                                    controller: _postalCodeController,
                                    hint: EditProfileStrings.postalCodeHint,
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                                _EditFormField(
                                  label: EditProfileStrings.country,
                                  child: _EditTextField(
                                    controller: _countryController,
                                    hint: EditProfileStrings.countryHint,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 22),
                            _EditSectionCard(
                              title: EditProfileStrings.preferencesSection,
                              children: [
                                _EditFormField(
                                  label: EditProfileStrings.preferredLanguage,
                                  child: _EditTextField(
                                    controller: _preferredLanguageController,
                                    hint: EditProfileStrings.preferredLanguageHint,
                                  ),
                                ),
                                _EditFormField(
                                  label: EditProfileStrings.defaultDeliveryAddress,
                                  child: _EditTextField(
                                    controller: _defaultDeliveryAddressController,
                                    hint: EditProfileStrings.defaultDeliveryHint,
                                    maxLines: 2,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 22),
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

class _EditSectionCard extends StatelessWidget {
  const _EditSectionCard({
    required this.title,
    required this.children,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.05),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppFonts.dmSerifDisplay(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: AppFonts.dmSans(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.35,
              ),
            ),
          ],
          const SizedBox(height: 18),
          ...children,
        ],
      ),
    );
  }
}

class _ProfilePhotoHeader extends StatelessWidget {
  const _ProfilePhotoHeader({
    required this.initial,
    required this.imageUrl,
    required this.uploading,
    required this.onChangePhoto,
  });

  final String initial;
  final String imageUrl;
  final bool uploading;
  final VoidCallback onChangePhoto;

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl.trim().isNotEmpty;

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: ProfileMenuConfig.avatarSize,
              height: ProfileMenuConfig.avatarSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black,
                border: Border.all(
                  color: Colors.white,
                  width: 4,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
                image: hasImage
                    ? DecorationImage(
                        image: NetworkImage(imageUrl),
                        fit: BoxFit.cover,
                      )
                    : initial == '?'
                        ? const DecorationImage(
                            image: AssetImage(ProfileMenuConfig.avatarAsset),
                            fit: BoxFit.cover,
                          )
                        : null,
              ),
              alignment: Alignment.center,
              child: (!hasImage && initial != '?')
                  ? Text(
                      initial,
                      style: AppFonts.dmSans(
                        fontSize: 40,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    )
                  : null,
            ),
            if (uploading)
              Container(
                width: ProfileMenuConfig.avatarSize,
                height: ProfileMenuConfig.avatarSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withValues(alpha: 0.35),
                ),
                child: const Center(
                  child: SizedBox(
                    width: 28,
                    height: 28,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 14),
        TextButton(
          onPressed: uploading ? null : onChangePhoto,
          style: TextButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(999),
              side: BorderSide(color: Colors.black.withValues(alpha: 0.08)),
            ),
          ),
          child: Text(
            uploading
                ? EditProfileStrings.photoUploading
                : EditProfileStrings.changePhoto,
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
    this.helper,
  });

  final String label;
  final Widget child;
  final String? error;
  final String? helper;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
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
          if (helper != null) ...[
            const SizedBox(height: 6),
            Text(
              helper!,
              style: AppFonts.dmSans(
                fontSize: 12,
                color: AppColors.textSecondary,
                height: 1.35,
              ),
            ),
          ],
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
    this.readOnly = false,
    this.onChanged,
  });

  final TextEditingController controller;
  final String hint;
  final int maxLines;
  final TextInputType? keyboardType;
  final bool hasError;
  final bool readOnly;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      readOnly: readOnly,
      keyboardType: keyboardType,
      onChanged: onChanged,
      style: AppFonts.dmSans(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: readOnly
            ? AppColors.textSecondary
            : AppColors.textPrimary,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppFonts.dmSans(
          fontSize: 15,
          color: AppColors.textSecondary.withValues(alpha: 0.7),
        ),
        filled: true,
        fillColor: readOnly
            ? const Color(0xFFF3F0EA)
            : ChairsCatalogTokens.imageWell,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: hasError
                ? AppColors.coral
                : Colors.black.withValues(alpha: 0.06),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: hasError ? AppColors.coral : Colors.black,
            width: 1.4,
          ),
        ),
      ),
    );
  }
}

class _EditDropdownField extends StatelessWidget {
  const _EditDropdownField({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final resolvedValue = items.contains(value) ? value : items.first;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: ChairsCatalogTokens.imageWell,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.06),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: resolvedValue,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Colors.black.withValues(alpha: 0.55),
          ),
          style: AppFonts.dmSans(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
          items: items
              .map(
                (item) => DropdownMenuItem(
                  value: item,
                  child: Text(item),
                ),
              )
              .toList(),
          onChanged: onChanged,
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
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
            ProfileActionButton(
              label: EditProfileStrings.goToSignIn,
              onTap: () => context.go('/login'),
            ),
          ],
        ),
      ),
    );
  }
}
