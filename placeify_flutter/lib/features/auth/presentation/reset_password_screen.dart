import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/services/haptic_service.dart';
import '../../../core/widgets/toast_overlay.dart';
import '../../splash/presentation/widgets/onboarding/primary_cta_button.dart';
import '../constants/auth_assets.dart';
import '../domain/repositories/auth_repository.dart';
import 'providers/auth_provider.dart';
import 'widgets/auth_text_field.dart';
import 'widgets/foggy_image_background.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({
    required this.token,
    super.key,
  });

  final String token;

  @override
  ConsumerState<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  bool _isSubmitting = false;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool get _hasToken => widget.token.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: AppColors.onboardingBg,
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_hasToken) {
      PlaceifyToast.show(context, 'Reset link is invalid. Request a new one.');
      return;
    }
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_isSubmitting) return;

    setState(() => _isSubmitting = true);
    await HapticService.heavy();

    try {
      await ref.read(currentUserProvider.notifier).resetPassword(
            token: widget.token,
            email: _emailController.text.trim(),
            newPassword: _passwordController.text,
          );
      if (!mounted) return;
      PlaceifyToast.show(context, 'Password updated. You can log in now.');
      context.go('/login');
    } on AuthException catch (e) {
      if (mounted) PlaceifyToast.show(context, e.message);
    } catch (_) {
      if (mounted) {
        PlaceifyToast.show(context, 'Could not reset password. Try again.');
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  String? _required(String? value, String message) {
    if (value == null || value.trim().isEmpty) return message;
    return null;
  }

  String? _emailValidator(String? value) {
    final required = _required(value, 'Enter your email');
    if (required != null) return required;
    final email = value!.trim();
    if (!email.contains('@') || !email.contains('.')) {
      return 'Enter a valid email';
    }
    return null;
  }

  String? _passwordValidator(String? value) {
    final required = _required(value, 'Enter a new password');
    if (required != null) return required;
    final password = value!.trim();
    if (password.length < 8) {
      return 'Use at least 8 characters';
    }
    if (!RegExp(r'[A-Za-z]').hasMatch(password) ||
        !RegExp(r'\d').hasMatch(password)) {
      return 'Use at least 1 letter and 1 number';
    }
    return null;
  }

  String? _confirmValidator(String? value) {
    final required = _required(value, 'Confirm your new password');
    if (required != null) return required;
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.paddingOf(context).bottom;
    final topPadding = MediaQuery.paddingOf(context).top;

    return Scaffold(
      backgroundColor: AppColors.onboardingBg,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const FoggyImageBackground(
            imageAsset: AuthAssets.loginBackground,
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8, top: 4),
                  child: IconButton(
                    onPressed: () => context.go('/login'),
                    icon: Icon(
                      Icons.arrow_back_rounded,
                      color: AppColors.onboardingTextHead.withValues(alpha: 0.9),
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.screenPadding,
                      8,
                      AppSpacing.screenPadding,
                      bottomPadding + AppSpacing.xxl,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text.rich(
                            TextSpan(
                              style: const TextStyle(
                                fontFamily: 'Fraunces',
                                fontSize: 36,
                                fontWeight: FontWeight.w700,
                                color: AppColors.onboardingTextHead,
                                letterSpacing: -0.8,
                                height: 1.08,
                              ),
                              children: const [
                                TextSpan(text: 'Reset '),
                                TextSpan(
                                  text: 'Password',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _hasToken
                                ? 'Enter your email and choose a new password.'
                                : 'This reset link is invalid or incomplete. Request a new password reset email.',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                              color: AppColors.onboardingTextBody.withValues(
                                alpha: 0.9,
                              ),
                              height: 1.55,
                            ),
                          ),
                          SizedBox(height: topPadding > 0 ? 32 : 36),
                          AuthTextField(
                            label: 'Email',
                            hint: 'you@example.com',
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            validator: _emailValidator,
                          ),
                          const SizedBox(height: 18),
                          AuthTextField(
                            label: 'New password',
                            hint: 'At least 8 characters',
                            controller: _passwordController,
                            showVisibilityToggle: true,
                            textInputAction: TextInputAction.next,
                            validator: _passwordValidator,
                          ),
                          const SizedBox(height: 18),
                          AuthTextField(
                            label: 'Confirm new password',
                            hint: 'Repeat new password',
                            controller: _confirmController,
                            showVisibilityToggle: true,
                            textInputAction: TextInputAction.done,
                            validator: _confirmValidator,
                          ),
                          const SizedBox(height: 32),
                          PrimaryCtaButton(
                            label: _isSubmitting
                                ? 'Updating...'
                                : 'Update Password',
                            onTap: _submit,
                          ),
                          const SizedBox(height: 16),
                          Center(
                            child: TextButton(
                              onPressed: _isSubmitting
                                  ? null
                                  : () {
                                      HapticService.light();
                                      context.go('/login/forgot-password');
                                    },
                              child: const Text(
                                'Request a new reset email',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.onboardingAmber,
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
            ),
          ),
        ],
      ),
    );
  }
}
