import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_durations.dart';
import '../../../../core/services/haptic_service.dart';
import '../../../profile/presentation/widgets/shared/profile_submit_button.dart';
import '../../domain/constants/vendor_routes.dart';

class VendorRegistrationSuccessScreen extends StatefulWidget {
  const VendorRegistrationSuccessScreen({super.key});

  @override
  State<VendorRegistrationSuccessScreen> createState() =>
      _VendorRegistrationSuccessScreenState();
}

class _VendorRegistrationSuccessScreenState
    extends State<VendorRegistrationSuccessScreen> {
  bool _animate = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        HapticService.light();
        setState(() => _animate = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(24, 32, 24, bottom + 24),
          child: Column(
            children: [
              const Spacer(),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: _animate ? 1 : 0),
                duration: AppDurations.slow,
                curve: Curves.easeOutBack,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Opacity(
                      opacity: value.clamp(0.0, 1.0),
                      child: child,
                    ),
                  );
                },
                child: Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: AppColors.vendorForestBg,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.vendorForest.withValues(alpha: 0.25),
                      width: 2,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.check_rounded,
                    size: 52,
                    color: AppColors.vendorForest,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: _animate ? 1 : 0),
                duration: AppDurations.mid,
                curve: Curves.easeOutCubic,
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(0, 12 * (1 - value)),
                      child: child,
                    ),
                  );
                },
                child: const Column(
                  children: [
                    Text(
                      'Application submitted',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Fraunces',
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Your vendor application is pending review. '
                      'Our team typically responds within 2–3 business days.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        height: 1.55,
                      ),
                    ),
                    SizedBox(height: 20),
                    _InfoPill(
                      icon: Icons.schedule_outlined,
                      label: 'Estimated review: 2–3 business days',
                    ),
                  ],
                ),
              ),
              const Spacer(),
              ProfileSubmitButton(
                label: 'Back to Profile',
                onPressed: () => context.go(VendorRoutes.profileFallback),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.vendorForestBg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: AppColors.vendorForest.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: AppColors.vendorForest),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.vendorForest,
            ),
          ),
        ],
      ),
    );
  }
}
