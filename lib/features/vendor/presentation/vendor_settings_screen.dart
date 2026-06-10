import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:placeify/core/constants/app_colors.dart';
import 'package:placeify/core/services/haptic_service.dart';
import 'package:placeify/core/widgets/bottom_nav/bottom_nav_tokens.dart';
import 'package:placeify/core/widgets/placeify_bottom_sheet.dart';
import 'package:placeify/core/widgets/toast_overlay.dart';
import 'package:placeify/features/profile/presentation/widgets/profile_sub_hero.dart';
import 'package:placeify/features/profile/presentation/widgets/shared/profile_toggle_row.dart';
import 'package:placeify/features/vendor/domain/enums/notification_type.dart';
import 'package:placeify/features/vendor/presentation/providers/vendor_settings_provider.dart';

class VendorSettingsScreen extends ConsumerWidget {
  const VendorSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(vendorSettingsProvider);

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Column(
        children: [
          const ProfileSubHero(title: 'Store Settings'),
          Expanded(
            child: settings.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                    padding: const EdgeInsets.fromLTRB(
                      18,
                      20,
                      18,
                      BottomNavTokens.scrollBottomPadding,
                    ),
                    children: [
                      const _SectionTitle('Notifications'),
                      const SizedBox(height: 12),
                      for (final type in NotificationType.values)
                        ProfileToggleRow(
                          title: _notificationTitle(type),
                          subtitle: _notificationSubtitle(type),
                          value: settings.notifications[type] ?? true,
                          onChanged: (enabled) => ref
                              .read(vendorSettingsProvider.notifier)
                              .setNotification(type, enabled),
                        ),
                      const SizedBox(height: 20),
                      const _SectionTitle('Store'),
                      const SizedBox(height: 12),
                      ProfileToggleRow(
                        title: 'Store visible',
                        subtitle: 'When off, your store is hidden from shoppers',
                        value: settings.storeVisible,
                        onChanged: (visible) => ref
                            .read(vendorSettingsProvider.notifier)
                            .setStoreVisible(visible),
                      ),
                      const SizedBox(height: 20),
                      const _SectionTitle('Payout method'),
                      const SizedBox(height: 12),
                      const _PayoutMethodCard(),
                      const SizedBox(height: 20),
                      const _SectionTitle('Account'),
                      const SizedBox(height: 12),
                      _SettingsActionTile(
                        icon: Icons.lock_outline,
                        title: 'Change password',
                        subtitle: 'Update your login credentials',
                        onTap: () => context.pushNamed('profilePassword'),
                      ),
                      const SizedBox(height: 10),
                      _SettingsActionTile(
                        icon: Icons.storefront_outlined,
                        title: 'Deactivate store',
                        subtitle: settings.isDeactivateCooldownActive
                            ? _cooldownLabel(settings.deactivateCooldownRemaining)
                            : 'Temporarily hide your store from Placeify',
                        isDestructive: true,
                        onTap: () => _showDeactivateSheet(context, ref),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  static String _notificationTitle(NotificationType type) {
    return switch (type) {
      NotificationType.order => 'Order alerts',
      NotificationType.payment => 'Payment alerts',
      NotificationType.product => 'Product alerts',
      NotificationType.system => 'System updates',
    };
  }

  static String _notificationSubtitle(NotificationType type) {
    return switch (type) {
      NotificationType.order => 'New orders and status changes',
      NotificationType.payment => 'Payouts and payment updates',
      NotificationType.product => 'Low stock and listing issues',
      NotificationType.system => 'Policy and platform announcements',
    };
  }

  static String _cooldownLabel(Duration? remaining) {
    if (remaining == null) return 'Ready to deactivate';
    final hours = remaining.inHours;
    final minutes = remaining.inMinutes.remainder(60);
    if (hours > 0) {
      return 'Cooldown active · ${hours}h ${minutes}m remaining';
    }
    return 'Cooldown active · ${minutes}m remaining';
  }

  static Future<void> _showDeactivateSheet(
    BuildContext context,
    WidgetRef ref,
  ) async {
    HapticService.light();
    final settings = ref.read(vendorSettingsProvider);

    if (settings.isDeactivateCooldownActive) {
      PlaceifyToast.show(
        context,
        _cooldownLabel(settings.deactivateCooldownRemaining),
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
              title: 'Deactivate store?',
              subtitle:
                  'Your store will be hidden after a 24-hour cooldown. You can cancel anytime before then.',
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.cream,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Text(
                'During the cooldown, orders in progress will still be fulfilled. '
                'After 24 hours your store visibility will turn off automatically.',
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
                  'Deactivation scheduled · 24h cooldown started',
                );
              },
              child: const Text('Start 24-hour cooldown'),
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
  const _PayoutMethodCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.creamDark, width: 1.5),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.account_balance_outlined,
                  color: AppColors.espresso, size: 20),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Nepal Investment Bank',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.espresso,
                  ),
                ),
              ),
              Text(
                'Primary',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.sage,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'Account ·••• 4821 · NPR settlements',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textMuted,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Payout method changes are reviewed by Placeify support.',
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
