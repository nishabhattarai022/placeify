import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/toast_overlay.dart';
import '../domain/repositories/auth_repository.dart';
import 'providers/auth_provider.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/services/haptic_service.dart';
import '../../splash/presentation/widgets/onboarding/primary_cta_button.dart';
import '../constants/auth_assets.dart';
import 'widgets/auth_text_field.dart';
import 'widgets/foggy_image_background.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  bool _isSubmitting = false;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

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
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_isSubmitting) return;

    setState(() => _isSubmitting = true);
    await HapticService.heavy();

    try {
      await ref.read(currentUserProvider.notifier).registerAccount(
            fullName: _nameController.text,
            email: _emailController.text,
            password: _passwordController.text,
          );
      if (!mounted) return;
      PlaceifyToast.show(context, 'Account created — sign in to continue');
      context.go('/login');
    } on AuthException catch (e) {
      if (mounted) PlaceifyToast.show(context, e.message);
    } catch (_) {
      if (mounted) {
        PlaceifyToast.show(context, 'Could not create account. Try again.');
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
    final required = _required(value, 'Enter a password');
    if (required != null) return required;
    if (value!.length < 8) return 'Use at least 8 characters';
    return null;
  }

  String? _confirmPasswordValidator(String? value) {
    final required = _required(value, 'Confirm your password');
    if (required != null) return required;
    if (value != _passwordController.text) return 'Passwords do not match';
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
            imageAsset: AuthAssets.registerBackground,
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8, top: 4),
                  child: IconButton(
                    onPressed: () {
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        context.go('/splash');
                      }
                    },
                    icon: Icon(
                      Icons.arrow_back_rounded,
                      color: AppColors.onboardingTextHead.withValues(
                        alpha: 0.9,
                      ),
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
                          const Text(
                            'Create your\naccount',
                            style: TextStyle(
                              fontFamily: 'Fraunces',
                              fontSize: 40,
                              fontWeight: FontWeight.w700,
                              color: AppColors.onboardingTextHead,
                              letterSpacing: -1.0,
                              height: 1.05,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Join Placeify to preview furniture in AR and shop from verified vendors.',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                              color: AppColors.onboardingTextBody.withValues(
                                alpha: 0.9,
                              ),
                              height: 1.55,
                            ),
                          ),
                          SizedBox(height: topPadding > 0 ? 28 : 32),
                          AuthTextField(
                            label: 'Full name',
                            hint: 'Alex Morgan',
                            controller: _nameController,
                            textInputAction: TextInputAction.next,
                            validator: (v) =>
                                _required(v, 'Enter your full name'),
                          ),
                          const SizedBox(height: 18),
                          AuthTextField(
                            label: 'Email',
                            hint: 'you@email.com',
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            validator: _emailValidator,
                          ),
                          const SizedBox(height: 18),
                          AuthTextField(
                            label: 'Password',
                            hint: 'At least 8 characters',
                            controller: _passwordController,
                            showVisibilityToggle: true,
                            textInputAction: TextInputAction.next,
                            validator: _passwordValidator,
                          ),
                          const SizedBox(height: 18),
                          AuthTextField(
                            label: 'Confirm password',
                            hint: 'Repeat password',
                            controller: _confirmPasswordController,
                            showVisibilityToggle: true,
                            textInputAction: TextInputAction.done,
                            validator: _confirmPasswordValidator,
                          ),
                          const SizedBox(height: 32),
                          PrimaryCtaButton(
                            label: _isSubmitting
                                ? 'Creating account...'
                                : 'Create Account',
                            onTap: _submit,
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child: TextButton(
                              onPressed: () {
                                HapticService.light();
                                context.push('/login');
                              },
                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.onboardingTextBody
                                        .withValues(alpha: 0.85),
                                  ),
                                  children: const [
                                    TextSpan(text: 'Already have an account? '),
                                    TextSpan(
                                      text: 'Log In',
                                      style: TextStyle(
                                        color: AppColors.onboardingAmber,
                                        fontWeight: FontWeight.w600,
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
