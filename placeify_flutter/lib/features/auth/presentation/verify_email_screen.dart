
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/services/haptic_service.dart';
import '../../splash/presentation/widgets/onboarding/primary_cta_button.dart';
import '../constants/auth_assets.dart';
import '../data/serverpod_auth_repository.dart';
import '../domain/repositories/auth_repository.dart';
import 'providers/auth_provider.dart';
import 'widgets/auth_text_field.dart';
import 'widgets/foggy_image_background.dart';

class VerifyEmailScreen extends ConsumerStatefulWidget {
  const VerifyEmailScreen({
    required this.token,
    super.key,
  });

  final String token;

  @override
  ConsumerState<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  bool _loading = true;
  bool _success = false;
  bool _expired = false;
  bool _invalid = false;
  String _message = '';
  bool _submitting = false;

  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
    WidgetsBinding.instance.addPostFrameCallback((_) => _startVerification());
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _startVerification() async {
    if (!_hasToken) {
      setState(() {
        _loading = false;
        _invalid = true;
        _message = 'This verification link is invalid. Request a new one.';
      });
      return;
    }

    final repo = await ref.read(authRepositoryProvider.future);
    final pendingPassword = repo is ServerpodAuthRepository
        ? repo.pendingRegistrationPassword
        : null;


    if (pendingPassword != null && pendingPassword.isNotEmpty) {
      await _complete(password: pendingPassword);
      return;
    }

    setState(() {
      _loading = false;
      _message =
          'Enter the password you chose during registration to activate your account.';
    });
  }

  Future<void> _complete({required String password}) async {
    if (_submitting) return;
    setState(() {
      _submitting = true;
      _loading = true;
      _expired = false;
      _invalid = false;
      _success = false;
    });
    await HapticService.heavy();

    try {
      final repo = await ref.read(authRepositoryProvider.future);
      final fullName = repo is ServerpodAuthRepository
          ? repo.pendingRegistrationName
          : null;
      await ref
          .read(currentUserProvider.notifier)
          .verifyEmailRegistration(
            token: widget.token,
            password: password,
            fullName: fullName,
          );
      if (!mounted) return;
      setState(() {
        _success = true;
        _loading = false;
        _message =
            'Your email has been verified successfully. Your Placeify account is now active.';
      });
    } on AuthException catch (e) {
      if (!mounted) return;
      final lower = e.message.toLowerCase();
      setState(() {
        _loading = false;
        _expired = lower.contains('expired');
        _invalid = !_expired;
        _message = e.message;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _invalid = true;
        _message = 'Could not verify email. Request a new link and try again.';
      });
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Future<void> _submitPassword() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    await _complete(password: _passwordController.text);
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: AppColors.onboardingBg,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const FoggyImageBackground(
            imageAsset: AuthAssets.registerBackground,
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.lg,
                24,
                AppSpacing.lg,
                bottomPadding + 24,
              ),
              child: _loading
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    )
                  : _buildContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_success) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(),
          const Icon(Icons.verified_outlined, size: 64, color: Colors.white),
          const SizedBox(height: 20),
          Text(
            _message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
          const Spacer(),
          PrimaryCtaButton(
            label: 'Continue to login',
            onTap: () => context.go('/login'),
          ),
        ],
      );
    }

    if (_expired || _invalid) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(),
          Icon(
            _expired ? Icons.timer_off_outlined : Icons.link_off,
            size: 64,
            color: Colors.white,
          ),
          const SizedBox(height: 20),
          Text(
            _message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              height: 1.4,
            ),
          ),
          const Spacer(),
          PrimaryCtaButton(
            label: 'Request another email',
            onTap: () => context.go('/register'),
          ),
          TextButton(
            onPressed: () => context.go('/login'),
            child: const Text(
              'Back to login',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      );
    }

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(),
          Text(
            _message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),
          AuthTextField(
            controller: _passwordController,
            label: 'Password',
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) return 'Enter your password';
              return null;
            },
          ),
          const Spacer(),
          PrimaryCtaButton(
            label: _submitting ? 'Verifying…' : 'Activate account',
            onTap: _submitting ? () {} : _submitPassword,
          ),
        ],
      ),
    );
  }
}
