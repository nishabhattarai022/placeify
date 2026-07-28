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
import 'widgets/foggy_image_background.dart';

class CheckEmailScreen extends ConsumerStatefulWidget {
  const CheckEmailScreen({
    required this.email,
    super.key,
  });

  final String email;

  @override
  ConsumerState<CheckEmailScreen> createState() => _CheckEmailScreenState();
}

class _CheckEmailScreenState extends ConsumerState<CheckEmailScreen> {
  bool _isResending = false;
  bool _resendCooldown = false;

  Future<void> _resend() async {
    if (_isResending || _resendCooldown) return;
    setState(() => _isResending = true);
    await HapticService.light();
    try {
      await ref
          .read(currentUserProvider.notifier)
          .resendVerificationEmail(
            email: widget.email,
          );
      if (!mounted) return;
      PlaceifyToast.show(
        context,
        'If an unverified account exists for this email address, a new verification link has been sent.',
      );
      setState(() => _resendCooldown = true);
      Future<void>.delayed(const Duration(seconds: 30), () {
        if (mounted) setState(() => _resendCooldown = false);
      });
    } on AuthException catch (e) {
      if (mounted) PlaceifyToast.show(context, e.message);
    } catch (_) {
      if (mounted) {
        PlaceifyToast.show(context, 'Could not resend email. Try again.');
      }
    } finally {
      if (mounted) setState(() => _isResending = false);
    }
  }

  /// Console email mode prints the link in the server log — paste it here
  /// inside the same app that registered (e.g. Android emulator).
  Future<void> _pasteVerificationLink() async {
    final controller = TextEditingController();
    final raw = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1C1C1E),
          title: const Text(
            'Paste verification link',
            style: TextStyle(color: Colors.white),
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'Paste full link or token from server log',
              hintStyle: TextStyle(color: Colors.white54),
            ),
            minLines: 2,
            maxLines: 4,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.of(dialogContext).pop(controller.text),
              child: const Text('Continue'),
            ),
          ],
        );
      },
    );
    controller.dispose();
    if (!mounted || raw == null) return;

    final token = _extractVerificationToken(raw);

    if (token == null || token.isEmpty) {
      PlaceifyToast.show(
        context,
        'Could not find a token. Paste the full server link or the token value.',
      );
      return;
    }

    await HapticService.light();
    if (!mounted) return;
    context.go('/verify-email?token=${Uri.encodeComponent(token)}');
  }

  static String? _extractVerificationToken(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) return null;

    final uri = Uri.tryParse(trimmed);
    if (uri != null) {
      final fromQuery = uri.queryParameters['token']?.trim();
      if (fromQuery != null && fromQuery.isNotEmpty) return fromQuery;
    }

    // Raw token from the log (no URL).
    if (!trimmed.contains(' ') && !trimmed.contains('\n')) {
      return trimmed;
    }
    return null;
  }

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
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.lg,
                topPadding > 0 ? 12 : 24,
                AppSpacing.lg,
                bottomPadding + 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () => context.go('/login'),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.mark_email_unread_outlined,
                    size: 64,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Check your email',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Registration successful. In local development the verification link is printed in the server terminal — paste it below in this same app (do not open it in a desktop browser if you registered on the emulator).',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 15,
                      height: 1.45,
                    ),
                  ),
                  if (widget.email.trim().isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      widget.email,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                  const Spacer(),
                  PrimaryCtaButton(
                    label: 'Paste verification link',
                    onTap: _pasteVerificationLink,
                  ),
                  const SizedBox(height: 12),
                  PrimaryCtaButton(
                    label: _resendCooldown
                        ? 'Resend available soon'
                        : (_isResending
                              ? 'Sending…'
                              : 'Resend verification email'),
                    onTap: (_isResending || _resendCooldown) ? () {} : _resend,
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => context.go('/login'),
                    child: const Text(
                      'Back to login',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
