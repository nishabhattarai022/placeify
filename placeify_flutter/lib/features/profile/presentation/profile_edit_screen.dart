import 'package:placeify_client/placeify_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/bottom_nav/bottom_nav_tokens.dart';
import '../../../core/widgets/toast_overlay.dart';
import 'providers/consumer_profile_provider.dart';
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
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  bool _submitting = false;
  bool _initialized = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _syncFields(User profile) {
    if (_initialized) return;
    _nameController.text = profile.name;
    _phoneController.text = profile.phone ?? '';
    _addressController.text = profile.address ?? '';
    _initialized = true;
  }

  Future<void> _submit() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      PlaceifyToast.show(context, 'Enter your name');
      return;
    }
    if (_submitting) return;

    setState(() => _submitting = true);
    final error = await ref
        .read(consumerProfileProvider.notifier)
        .updateProfile(
          name: name,
          phone: _phoneController.text.trim(),
          address: _addressController.text.trim(),
        );
    if (!mounted) return;
    setState(() => _submitting = false);

    if (error != null) {
      PlaceifyToast.show(context, error);
      return;
    }

    PlaceifyToast.show(context, 'Profile updated ✓');
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(consumerProfileProvider);

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Column(
        children: [
          const ProfileSubHero(title: 'Edit Profile'),
          Expanded(
            child: profileAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => const Center(
                child: Text(
                  'Could not load profile.',
                  style: TextStyle(color: AppColors.textMuted),
                ),
              ),
              data: (profile) {
                if (profile == null) {
                  return const Center(
                    child: Text(
                      'Sign in to edit your profile.',
                      style: TextStyle(color: AppColors.textMuted),
                    ),
                  );
                }

                _syncFields(profile);

                return ListView(
                  padding: const EdgeInsets.fromLTRB(
                    18,
                    20,
                    18,
                    BottomNavTokens.scrollBottomPadding,
                  ),
                  children: [
                    ProfileFormField(
                      label: 'Full Name',
                      child: ProfileTextInput(
                        controller: _nameController,
                        hint: 'Your name',
                      ),
                    ),
                    ProfileFormField(
                      label: 'Phone',
                      child: ProfileTextInput(
                        controller: _phoneController,
                        hint: 'Phone number',
                        keyboardType: TextInputType.phone,
                      ),
                    ),
                    ProfileFormField(
                      label: 'Address',
                      child: ProfileTextInput(
                        controller: _addressController,
                        hint: 'Default shipping address',
                        maxLines: 3,
                      ),
                    ),
                    ProfileSubmitButton(
                      label: _submitting ? 'Saving…' : 'Save Changes',
                      onPressed: _submitting ? () {} : _submit,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
