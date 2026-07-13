import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:placeify/core/constants/app_colors.dart';
import 'package:placeify/core/constants/app_radii.dart';
import 'package:placeify/core/constants/app_spacing.dart';
import 'package:placeify/core/constants/app_typography.dart';
import 'package:placeify/core/services/haptic_service.dart';
import 'package:placeify/core/widgets/bottom_nav/bottom_nav_tokens.dart';
import 'package:placeify/core/widgets/toast_overlay.dart';
import 'package:placeify/features/admin/domain/constants/admin_routes.dart';
import 'package:placeify/features/admin/domain/constants/admin_strings.dart';
import 'package:placeify/features/admin/presentation/providers/admin_settings_prefs_provider.dart';
import 'package:placeify/features/admin/domain/enums/user_role.dart';
import 'package:placeify/features/admin/presentation/widgets/admin_role_chip.dart';
import 'package:placeify/features/auth/presentation/providers/auth_provider.dart';
import 'package:placeify/features/profile/presentation/widgets/shared/profile_toggle_row.dart';

class AdminSettingsScreen extends ConsumerWidget {
  const AdminSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value;
    final prefs = ref.watch(adminSettingsPrefsProvider);

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(24, 14, 24, 4),
              child: Text(
                AdminStrings.settingsTitle,
                style: AppTypography.sectionTitle,
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenPadding,
                  12,
                  AppSpacing.screenPadding,
                  BottomNavTokens.scrollBottomPadding,
                ),
                children: [
                  _AdminProfileCard(
                    name: user?.fullName ?? 'Admin',
                    email: user?.email ?? '',
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    AdminStrings.notificationPrefs,
                    style: TextStyle(
                      fontFamily: 'Fraunces',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.italic,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    AdminStrings.notificationPrefsSubtitle,
                    style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                  ),
                  const SizedBox(height: 12),
                  ProfileToggleRow(
                    title: AdminStrings.newApplicationAlerts,
                    subtitle: 'Notify when vendors submit applications',
                    value: prefs.newApplicationAlerts,
                    onChanged: (value) => ref
                        .read(adminSettingsPrefsProvider.notifier)
                        .setNewApplicationAlerts(value),
                  ),
                  ProfileToggleRow(
                    title: AdminStrings.systemAlerts,
                    subtitle: 'Platform maintenance and policy updates',
                    value: prefs.systemAlerts,
                    onChanged: (value) => ref
                        .read(adminSettingsPrefsProvider.notifier)
                        .setSystemAlerts(value),
                  ),
                  const SizedBox(height: 24),
                  _AdminSettingsTile(
                    icon: Icons.people_outline,
                    title: AdminStrings.usersTitle,
                    subtitle: 'View all platform users',
                    onTap: () {
                      HapticService.light();
                      context.push(AdminRoutes.users);
                    },
                  ),
                  _AdminSettingsTile(
                    icon: Icons.notifications_outlined,
                    title: AdminStrings.notificationsTitle,
                    subtitle: 'Admin notification feed',
                    onTap: () {
                      HapticService.light();
                      context.push(AdminRoutes.notifications);
                    },
                  ),
                  _AdminSettingsTile(
                    icon: Icons.history_outlined,
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
          Row(
            children: [
              Text(
                AdminStrings.adminProfile,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMuted,
                ),
              ),
              const Spacer(),
              const AdminRoleChip(role: UserRole.admin),
            ],
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
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isDanger = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isDanger;

  @override
  Widget build(BuildContext context) {
    final titleColor = isDanger ? AppColors.rust : AppColors.espresso;
    final iconColor = isDanger ? AppColors.rust : AppColors.adminSlate;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.md,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Icon(icon, size: 22, color: iconColor),
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
              Icon(
                Icons.chevron_right,
                size: 18,
                color: isDanger ? AppColors.rust : AppColors.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
