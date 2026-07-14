import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/bottom_nav/bottom_nav_tokens.dart';
import '../../../core/widgets/phone_input_field.dart';
import '../../../core/widgets/toast_overlay.dart';
import '../../auth/domain/models/consumer_profile_details.dart';
import '../../auth/domain/repositories/auth_repository.dart';
import '../../auth/presentation/providers/auth_provider.dart';
import '../data/profile_menu_config.dart';
import 'widgets/profile_sub_hero.dart';
import 'widgets/shared/profile_form_field.dart';
import 'widgets/shared/profile_submit_button.dart';

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
      nameError = 'Name is required';
      valid = false;
    }

    final email = _emailController.text.trim();
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (email.isEmpty) {
      emailError = 'Email is required';
      valid = false;
    } else if (!emailRegex.hasMatch(email)) {
      emailError = 'Enter a valid email address';
      valid = false;
    }

    setState(() {
      _nameError = nameError;
      _emailError = emailError;
    });
    return valid;
  }

  Future<void> _save() async {
    if (!_validate()) return;

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

      await ref.read(currentUserProvider.notifier).updateConsumerProfile(profile);
      if (!mounted) return;

      PlaceifyToast.show(context, 'Profile updated successfully');
      Future.delayed(const Duration(milliseconds: 900), () {
        if (mounted) context.pop();
      });
    } on AuthException catch (e) {
      if (!mounted) return;
      PlaceifyToast.show(context, e.message);
    } catch (_) {
      if (!mounted) return;
      PlaceifyToast.show(context, 'Could not update profile. Try again.');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider).value;
    final initial = user != null && user.fullName.isNotEmpty
        ? user.fullName.trim()[0].toUpperCase()
        : '?';

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Column(
        children: [
          const ProfileSubHero(title: 'Edit Profile'),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : user == null
                    ? const _SignedOutState()
                    : ListView(
                        padding: const EdgeInsets.fromLTRB(
                          18,
                          20,
                          18,
                          BottomNavTokens.scrollBottomPadding,
                        ),
                        children: [
                          _ProfilePhotoHeader(
                            initial: initial,
                            onChangePhoto: () => PlaceifyToast.show(
                              context,
                              'Photo upload coming soon',
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: AppColors.warmWhite,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: AppColors.creamDark,
                                width: 1.5,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ProfileFormField(
                                  label: 'Full Name',
                                  error: _nameError,
                                  child: ProfileTextInput(
                                    controller: _nameController,
                                    hint: 'Your full name',
                                    hasError: _nameError != null,
                                    onChanged: (_) {
                                      if (_nameError != null) {
                                        setState(() => _nameError = null);
                                      }
                                    },
                                  ),
                                ),
                                ProfileFormField(
                                  label: 'Username',
                                  child: ProfileTextInput(
                                    controller: _usernameController,
                                    hint: 'placeify_user',
                                  ),
                                ),
                                ProfileFormField(
                                  label: 'Bio',
                                  child: ProfileTextInput(
                                    controller: _bioController,
                                    hint: 'Tell people a little about yourself',
                                    maxLines: 3,
                                  ),
                                ),
                                ProfileFormField(
                                  label: 'City',
                                  child: ProfileTextInput(
                                    controller: _cityController,
                                    hint: 'Kathmandu',
                                  ),
                                ),
                                ProfileFormField(
                                  label: 'Email',
                                  error: _emailError,
                                  child: ProfileTextInput(
                                    controller: _emailController,
                                    hint: 'you@example.com',
                                    keyboardType: TextInputType.emailAddress,
                                    hasError: _emailError != null,
                                    onChanged: (_) {
                                      if (_emailError != null) {
                                        setState(() => _emailError = null);
                                      }
                                    },
                                  ),
                                ),
                                ProfileFormField(
                                  label: 'Phone',
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
                          ProfileSubmitButton(
                            label: _saving ? 'Saving...' : 'Save Changes',
                            onPressed: _saving ? () {} : _save,
                          ),
                        ],
                      ),
          ),
        ],
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
            color: AppColors.accent,
            border: Border.all(color: AppColors.accentLight, width: 3),
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
                  style: const TextStyle(
                    fontFamily: 'Fraunces',
                    fontSize: 40,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: onChangePhoto,
          child: const Text(
            'Change profile photo',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.accent,
            ),
          ),
        ),
      ],
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
            const Text(
              'Sign in to edit your profile',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.espresso,
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => context.go('/login'),
              child: const Text('Go to sign in'),
            ),
          ],
        ),
      ),
    );
  }
}
