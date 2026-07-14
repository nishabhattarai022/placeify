import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:placeify_flutter/features/auth/presentation/providers/auth_provider.dart';
import 'package:placeify_flutter/core/constants/app_colors.dart';
import 'package:placeify_flutter/core/services/haptic_service.dart';
import 'package:placeify_flutter/core/widgets/bottom_nav/bottom_nav_tokens.dart';
import 'package:placeify_flutter/core/widgets/placeify_bottom_sheet.dart';
import 'package:placeify_flutter/core/widgets/shimmer_loader.dart';
import 'package:placeify_flutter/core/widgets/toast_overlay.dart';
import 'package:placeify_flutter/features/profile/presentation/widgets/profile_sub_hero.dart';
import 'package:placeify_flutter/features/profile/presentation/widgets/shared/profile_toggle_row.dart';
import 'package:placeify_flutter/features/vendor/domain/constants/vendor_settings_strings.dart';
import 'package:placeify_flutter/features/vendor/domain/enums/notification_type.dart';
import 'package:placeify_flutter/features/vendor/presentation/providers/vendor_settings_provider.dart';

class VendorSettingsScreen extends ConsumerWidget {
  const VendorSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(vendorSettingsProvider);

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Column(
        children: [
          const ProfileSubHero(title: VendorSettingsStrings.screenTitle),
          Expanded(
            child: settingsAsync.when(
              loading: () => const Center(child: ShimmerLoader()),
              error: (_, __) => Center(
                child: TextButton(
                  onPressed: () =>
                      ref.read(vendorSettingsProvider.notifier).refresh(),
                  child: const Text('Retry loading settings'),
                ),
              ),
              data: (settings) => ListView(
                padding: const EdgeInsets.fromLTRB(
                  18,
                  20,
                  18,
                  BottomNavTokens.scrollBottomPadding,
                ),
                children: [
                  if (settings.isDeactivateCooldownActive) ...[
                    _DeactivateCooldownBanner(
                      remaining: settings.deactivateCooldownRemaining,
                      onCancel: () async {
                        await ref
                            .read(vendorSettingsProvider.notifier)
                            .cancelDeactivateRequest();
                        if (!context.mounted) return;
                        PlaceifyToast.show(
                          context,
                          'Store deactivation cancelled',
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                  const _SectionTitle(
                    VendorSettingsStrings.notificationsSection,
                  ),
                  const SizedBox(height: 12),
                  for (final type in NotificationType.values)
                    ProfileToggleRow(
                      title: VendorSettingsStrings.notificationTitle(
                        type.name,
                      ),
                      subtitle: VendorSettingsStrings.notificationSubtitle(
                        type.name,
                      ),
                      value: settings.notifications[type] ?? true,
                      onChanged: (enabled) async {
                        try {
                          await ref
                              .read(vendorSettingsProvider.notifier)
                              .setNotification(type, enabled);
                        } catch (_) {
                          if (!context.mounted) return;
                          PlaceifyToast.show(
                            context,
                            'Could not save notification preference',
                          );
                        }
                      },
                    ),
                  const SizedBox(height: 20),
                  const _SectionTitle(VendorSettingsStrings.storeSection),
                  const SizedBox(height: 12),
                  ProfileToggleRow(
                    title: VendorSettingsStrings.storeVisibleTitle,
                    subtitle: VendorSettingsStrings.storeVisibleSubtitle,
                    value: settings.storeVisible,
                    onChanged: (visible) async {
                      try {
                        await ref
                            .read(vendorSettingsProvider.notifier)
                            .setStoreVisible(visible);
                      } catch (_) {
                        if (!context.mounted) return;
                        PlaceifyToast.show(
                          context,
                          'Could not update store visibility',
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  const _SectionTitle(VendorSettingsStrings.payoutSection),
                  const SizedBox(height: 12),
                  _PayoutMethodCard(settings: settings),
                  const SizedBox(height: 20),
                  const _SectionTitle(VendorSettingsStrings.accountSection),
                  const SizedBox(height: 12),
                  _SettingsActionTile(
                    icon: Icons.lock_outline,
                    title: VendorSettingsStrings.changePasswordTitle,
                    subtitle: VendorSettingsStrings.changePasswordSubtitle,
                    onTap: () => context.pushNamed('profilePassword'),
                  ),
                  const SizedBox(height: 10),
                  _SettingsActionTile(
                    icon: Icons.logout_outlined,
                    title: VendorSettingsStrings.signOutTitle,
                    subtitle: VendorSettingsStrings.signOutSubtitle,
                    isDestructive: true,
                    onTap: () => _signOut(context, ref),
                  ),
                  const SizedBox(height: 10),
                  _SettingsActionTile(
                    icon: Icons.storefront_outlined,
                    title: VendorSettingsStrings.deactivateStoreTitle,
                    subtitle: settings.isDeactivateCooldownActive
                        ? VendorSettingsStrings.cooldownLabel(
                            settings.deactivateCooldownRemaining,
                          )
                        : VendorSettingsStrings.deactivateStoreSubtitle,
                    isDestructive: true,
                    onTap: () => _showDeactivateSheet(context, ref),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Future<void> _signOut(BuildContext context, WidgetRef ref) async {
    HapticService.light();
    await ref.read(currentUserProvider.notifier).signOut();
    if (!context.mounted) return;
    PlaceifyToast.show(context, VendorSettingsStrings.signedOut);
    context.go('/splash');
  }

  static Future<void> _showDeactivateSheet(
    BuildContext context,
    WidgetRef ref,
  ) async {
    HapticService.light();
    final settings = ref.read(vendorSettingsProvider).value;

    if (settings?.isDeactivateCooldownActive ?? false) {
      PlaceifyToast.show(
        context,
        VendorSettingsStrings.cooldownLabel(
          settings!.deactivateCooldownRemaining,
        ),
      );
      return;
    }

    await PlaceifyBottomSheet.show<void>(
      context,
      builder: (sheetContext) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const PlaceifyBottomSheetHeader(
              title: VendorSettingsStrings.deactivateSheetTitle,
              subtitle: VendorSettingsStrings.deactivateSheetSubtitle,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.cream,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Text(
                VendorSettingsStrings.deactivateSheetBody,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.45,
                ),
              ),
            ),
            const SizedBox(height: 20),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.coral,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () async {
                await ref
                    .read(vendorSettingsProvider.notifier)
                    .requestDeactivateStore();
                if (!sheetContext.mounted) return;
                Navigator.pop(sheetContext);
                if (!context.mounted) return;
                PlaceifyToast.show(
                  context,
                  VendorSettingsStrings.deactivateScheduledToast,
                );
              },
              child: const Text(VendorSettingsStrings.deactivateSheetConfirm),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () => Navigator.pop(sheetContext),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}

class _DeactivateCooldownBanner extends StatelessWidget {
  const _DeactivateCooldownBanner({
    required this.remaining,
    required this.onCancel,
  });

  final Duration? remaining;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.coral.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.coral.withValues(alpha: 0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.schedule, color: AppColors.coral, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Deactivation scheduled',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.espresso,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  VendorSettingsStrings.cooldownLabel(remaining),
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: onCancel,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontFamily: 'Fraunces',
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.espresso,
      ),
    );
  }
}

class _PayoutMethodCard extends StatelessWidget {
  const _PayoutMethodCard({required this.settings});

  final VendorSettingsState settings;

  @override
  Widget build(BuildContext context) {
    if (!settings.hasBankDetails) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.creamDark, width: 1.5),
        ),
        child: const Text(
          VendorSettingsStrings.payoutNoBankDetails,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
            height: 1.4,
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.creamDark, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.account_balance_outlined,
                color: AppColors.espresso,
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  settings.bankName!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.espresso,
                  ),
                ),
              ),
              const Text(
                VendorSettingsStrings.payoutPrimaryBadge,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.sage,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Account ${settings.maskedAccountNumber}',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textMuted,
            ),
          ),
          if (settings.accountHolderName != null &&
              settings.accountHolderName!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              settings.accountHolderName!,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textMuted,
              ),
            ),
          ],
          const SizedBox(height: 12),
          const Text(
            VendorSettingsStrings.payoutSupportNote,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsActionTile extends StatelessWidget {
  const _SettingsActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isDestructive = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final titleColor = isDestructive ? AppColors.coral : AppColors.espresso;

    return GestureDetector(
      onTap: () {
        HapticService.light();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.creamDark, width: 1.5),
        ),
        child: Row(
          children: [
            Icon(icon, color: titleColor, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: titleColor,
                    ),
                  ),
                  const SizedBox(height: 2),
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
              color: isDestructive ? AppColors.coral : AppColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}
