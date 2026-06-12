import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:placeify/core/constants/app_colors.dart';
import 'package:placeify/core/constants/app_radii.dart';
import 'package:placeify/core/constants/app_spacing.dart';
import 'package:placeify/core/services/haptic_service.dart';
import 'package:placeify/core/widgets/bottom_nav/bottom_nav_tokens.dart';
import 'package:placeify/core/widgets/toast_overlay.dart';
import 'package:placeify/features/admin/domain/constants/admin_routes.dart';
import 'package:placeify/features/admin/domain/constants/admin_strings.dart';
import 'package:placeify/features/auth/presentation/providers/auth_provider.dart';
import 'package:placeify/features/profile/presentation/widgets/profile_sub_hero.dart';

class AdminSettingsScreen extends ConsumerWidget {
  const AdminSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value;

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Column(
        children: [
          const ProfileSubHero(title: AdminStrings.settingsTitle),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenPadding,
                20,
                AppSpacing.screenPadding,
                BottomNavTokens.scrollBottomPadding,
              ),
              children: [
                const Text(
                  AdminStrings.accountSection,
                  style: TextStyle(
                    fontFamily: 'Fraunces',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.espresso,
                  ),
                ),
                const SizedBox(height: 12),
                _AdminProfileCard(
                  name: user?.fullName ?? 'Admin',
                  email: user?.email ?? '',
                ),
                const SizedBox(height: 24),
                _AdminSettingsTile(
                  icon: Icons.history_outlined,
                  iconBackground: AppColors.espresso.withValues(alpha: 0.08),
                  iconColor: AppColors.espresso,
                  title: AdminStrings.auditLog,
                  subtitle: AdminStrings.auditLogSubtitle,
                  onTap: () {
                    HapticService.light();
                    context.push(AdminRoutes.auditLog);
                  },
                ),
                const SizedBox(height: 8),
                _AdminSettingsTile(
                  icon: Icons.logout_outlined,
                  iconBackground: AppColors.rust.withValues(alpha: 0.1),
                  iconColor: AppColors.rust,
                  title: AdminStrings.signOut,
                  subtitle: AdminStrings.signOutSubtitle,
                  isDanger: true,
                  onTap: () => _signOut(context, ref),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _signOut(BuildContext context, WidgetRef ref) async {
    HapticService.light();
    await ref.read(currentUserProvider.notifier).signOut();
    if (!context.mounted) return;
    PlaceifyToast.show(context, AdminStrings.signedOut);
    context.go('/splash');
  }
}

class _AdminProfileCard extends StatelessWidget {
  const _AdminProfileCard({
    required this.name,
    required this.email,
  });

  final String name;
  final String email;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.warmWhite,
        borderRadius: AppRadii.md,
        border: Border.all(color: AppColors.creamDark, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AdminStrings.adminProfile,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.espresso,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${AdminStrings.signedInAs} $email',
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _AdminSettingsTile extends StatelessWidget {
  const _AdminSettingsTile({
    required this.icon,
    required this.iconBackground,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isDanger = false,
  });

  final IconData icon;
  final Color iconBackground;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isDanger;

  @override
  Widget build(BuildContext context) {
    final titleColor = isDanger ? AppColors.rust : AppColors.espresso;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.md,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: iconBackground,
                  borderRadius: AppRadii.sm,
                ),
                alignment: Alignment.center,
                child: Icon(icon, size: 22, color: iconColor),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: titleColor,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: AppColors.creamDark,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.chevron_right,
                  size: 16,
                  color: isDanger ? AppColors.rust : AppColors.espresso,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
