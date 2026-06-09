import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../auth/domain/models/app_user.dart';
import '../../../auth/presentation/account_mode_actions.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class AccountModeCard extends ConsumerWidget {
  const AccountModeCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);

    return userAsync.when(
      loading: () => const _AccountModeSkeleton(),
      error: (_, __) => const SizedBox.shrink(),
      data: (user) {
        if (user == null) return const SizedBox.shrink();
        return _AccountModeBody(user: user);
      },
    );
  }
}

class _AccountModeSkeleton extends StatelessWidget {
  const _AccountModeSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      height: 120,
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: AppRadii.md,
        border: Border.all(color: AppColors.creamDark),
      ),
      alignment: Alignment.center,
      child: const SizedBox(
        width: 22,
        height: 22,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }
}

class _AccountModeBody extends ConsumerWidget {
  const _AccountModeBody({required this.user});

  final AppUser user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isVendor = user.isVendorMode;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.warmWhite,
            AppColors.cream.withValues(alpha: 0.65),
          ],
        ),
        borderRadius: AppRadii.md,
        border: Border.all(color: AppColors.creamDark),
        boxShadow: [
          BoxShadow(
            color: AppColors.espresso.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isVendor
                      ? AppColors.accent.withValues(alpha: 0.14)
                      : AppColors.sage.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isVendor ? Icons.storefront : Icons.shopping_bag_outlined,
                  color: isVendor ? AppColors.accent : AppColors.sage,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isVendor ? 'Vendor mode' : 'Shopping mode',
                      style: const TextStyle(
                        fontFamily: 'Fraunces',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.espresso,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isVendor
                          ? 'Managing your shop'
                          : user.hasVendorShop
                              ? 'Browsing as a customer'
                              : 'Ready to start selling?',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              _ModeBadge(isVendor: isVendor),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            isVendor
                ? 'Switch to shopping to browse furniture, use AR preview, and place orders.'
                : user.hasVendorShop
                    ? 'Your shop is registered. Switch anytime to manage products and orders.'
                    : 'Register your shop once, then switch between buying and selling with one login.',
            style: const TextStyle(
              fontSize: 13,
              height: 1.45,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          if (isVendor)
            _ModeButton(
              label: 'Switch to shopping',
              icon: Icons.shopping_bag_outlined,
              filled: true,
              onTap: () => openConsumerExperience(context, ref),
            )
          else if (user.hasVendorShop)
            _ModeButton(
              label: 'Open vendor dashboard',
              icon: Icons.storefront_outlined,
              filled: true,
              onTap: () => openVendorExperience(context, ref),
            )
          else
            _ModeButton(
              label: 'Set up my shop',
              icon: Icons.rocket_launch_outlined,
              filled: true,
              onTap: () => openVendorExperience(context, ref),
            ),
        ],
      ),
    );
  }
}

class _ModeBadge extends StatelessWidget {
  const _ModeBadge({required this.isVendor});

  final bool isVendor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isVendor
            ? AppColors.accent.withValues(alpha: 0.12)
            : AppColors.sage.withValues(alpha: 0.14),
        borderRadius: AppRadii.pill,
      ),
      child: Text(
        isVendor ? 'Vendor' : 'Customer',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: isVendor ? AppColors.accent : AppColors.sage,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  const _ModeButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.filled = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 46,
      child: filled
          ? FilledButton.icon(
              onPressed: onTap,
              icon: Icon(icon, size: 18),
              label: Text(label),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.espresso,
                foregroundColor: AppColors.warmWhite,
                shape: RoundedRectangleBorder(borderRadius: AppRadii.md),
              ),
            )
          : OutlinedButton.icon(
              onPressed: onTap,
              icon: Icon(icon, size: 18, color: AppColors.espresso),
              label: Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.espresso,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.creamDark),
                shape: RoundedRectangleBorder(borderRadius: AppRadii.md),
              ),
            ),
    );
  }
}
