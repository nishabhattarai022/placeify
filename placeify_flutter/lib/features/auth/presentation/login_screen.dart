import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:placeify_flutter/features/admin/domain/enums/user_role.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/toast_overlay.dart';
import '../domain/models/app_user.dart';
import '../domain/repositories/auth_repository.dart';
import 'providers/auth_provider.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/services/haptic_service.dart';
import '../../splash/presentation/widgets/onboarding/primary_cta_button.dart';
import '../constants/auth_assets.dart';
import '../constants/demo_credentials.dart';
import 'widgets/auth_text_field.dart';
import 'widgets/foggy_image_background.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _isSubmitting = false;
  bool _isAdminLoginMode = false;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

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
    super.dispose();
  }

  void _toggleAdminLoginMode() {
    HapticService.light();
    setState(() {
      _isAdminLoginMode = !_isAdminLoginMode;
      _emailController.clear();
      _passwordController.clear();
    });
  }

  Future<void> _signInWithDemo() async {
    _emailController.text = DemoCredentials.email;
    _passwordController.text = DemoCredentials.password;
    await _submit(destination: '/home');
  }

  Future<void> _submit({required String destination}) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_isSubmitting) return;

    setState(() => _isSubmitting = true);
    await HapticService.heavy();

    try {
      await ref
          .read(currentUserProvider.notifier)
          .signIn(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );
      if (!mounted) return;
      final resolvedDestination = await _resolvePostLoginDestination(
        ref.read(currentUserProvider).value,
        destination,
      );
      if (!mounted) return;
      context.go(resolvedDestination);
    } on AuthException catch (e) {
      if (mounted) PlaceifyToast.show(context, e.message);
    } catch (_) {
      if (mounted) {
        PlaceifyToast.show(
          context,
          _isAdminLoginMode
              ? 'Admin sign in failed. Try again.'
              : 'Log in failed. Try again.',
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Future<String> _resolvePostLoginDestination(
    AppUser? user,
    String fallback,
  ) async {
    final repo = await ref.read(authRepositoryProvider.future);
    final verified = await repo.verifyAdminAccess();
    if (verified) return '/admin';

    if (_isAdminLoginMode && mounted) {
      PlaceifyToast.show(
        context,
        'Admin access denied. Check your administrator credentials.',
      );
      return fallback;
    }

    if (user?.role == UserRole.admin && mounted) {
      PlaceifyToast.show(context, 'Admin access denied.');
    }
    return fallback;
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
    final required = _required(value, 'Enter your password');
    if (required != null) return required;
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
                          Text.rich(
                            TextSpan(
                              style: const TextStyle(
                                fontFamily: 'Fraunces',
                                fontSize: 40,
                                fontWeight: FontWeight.w700,
                                color: AppColors.onboardingTextHead,
                                letterSpacing: -1.0,
                                height: 1.05,
                              ),
                              children: _isAdminLoginMode
                                  ? const [
                                      TextSpan(text: 'Admin '),
                                      TextSpan(
                                        text: 'Sign In',
                                        style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ]
                                  : const [
                                      TextSpan(text: 'Welcome '),
                                      TextSpan(
                                        text: 'Back',
                                        style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _isAdminLoginMode
                                ? 'Enter your administrator email and password.'
                                : 'Log in to continue exploring furniture in AR and connecting with vendors.',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                              color: AppColors.onboardingTextBody.withValues(
                                alpha: 0.9,
                              ),
                              height: 1.55,
                            ),
                          ),
                          SizedBox(height: topPadding > 0 ? 36 : 40),
                          AuthTextField(
                            label: 'Email',
                            hint: _isAdminLoginMode
                                ? 'Administrator email'
                                : 'you@example.com',
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            validator: _emailValidator,
                          ),
                          const SizedBox(height: 18),
                          AuthTextField(
                            label: 'Password',
                            hint: _isAdminLoginMode
                                ? 'Administrator password'
                                : 'Your password',
                            controller: _passwordController,
                            showVisibilityToggle: true,
                            textInputAction: TextInputAction.done,
                            validator: _passwordValidator,
                          ),
                          const SizedBox(height: 32),
                          PrimaryCtaButton(
                            label: _isSubmitting
                                ? (_isAdminLoginMode
                                      ? 'Signing in...'
                                      : 'Logging in...')
                                : (_isAdminLoginMode
                                      ? 'Sign in to Admin'
                                      : 'Log In'),
                            onTap: () => _submit(destination: '/home'),
                          ),
                          const SizedBox(height: 12),
                          if (!_isAdminLoginMode && kDebugMode)
                            Center(
                              child: TextButton(
                                onPressed: _isSubmitting
                                    ? null
                                    : () {
                                        HapticService.light();
                                        _signInWithDemo();
                                      },
                                child: const Text(
                                  'Use demo account',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.onboardingAmber,
                                  ),
                                ),
                              ),
                            ),
                          if (!_isAdminLoginMode && kDebugMode)
                            const SizedBox(height: 4),
                          Center(
                            child: TextButton(
                              onPressed: _isSubmitting
                                  ? null
                                  : _toggleAdminLoginMode,
                              child: Text(
                                _isAdminLoginMode
                                    ? 'Back to user sign in'
                                    : 'Admin sign in',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: _isAdminLoginMode
                                      ? AppColors.onboardingAmber
                                      : AppColors.onboardingTextBody
                                            .withValues(alpha: 0.65),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (!_isAdminLoginMode)
                            Center(
                              child: TextButton(
                                onPressed: () {
                                  HapticService.light();
                                  context.push('/register');
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
                                      TextSpan(
                                        text: "Don't have an account? ",
                                      ),
                                      TextSpan(
                                        text: 'Create one',
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
