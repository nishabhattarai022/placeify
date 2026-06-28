import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/bottom_nav/bottom_nav_tokens.dart';
import '../../../core/widgets/toast_overlay.dart';
import '../../auth/presentation/providers/auth_provider.dart';
import '../../vendor/domain/enums/vendor_status.dart';
import 'widgets/profile_sub_hero.dart';
import 'widgets/shared/profile_toggle_row.dart';

class ProfileSettingsScreen extends ConsumerWidget {
  const ProfileSettingsScreen({super.key});

  static const _demoVendorId = 'demo-vendor';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);
    final vendorStatus = userAsync.value?.vendorStatus ?? VendorStatus.none;
    final isApproved = vendorStatus == VendorStatus.approved;

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Column(
        children: [
          const ProfileSubHero(title: 'Settings'),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                18,
                20,
                18,
                BottomNavTokens.scrollBottomPadding,
              ),
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.accentBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.person_outline,
                      color: AppColors.accent,
                    ),
                  ),
                  title: const Text(
                    'Edit Profile',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.espresso,
                    ),
                  ),
                  subtitle: const Text(
                    'Name, phone, and address',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.textMuted,
                  ),
                  onTap: () => context.pushNamed('profileEdit'),
                ),
                const Divider(height: 24, color: AppColors.creamDark),
                if (kDebugMode) ...[
                  const Text(
                    'Developer',
                    style: TextStyle(
                      fontFamily: 'Fraunces',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.espresso,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ProfileToggleRow(
                    title: 'Quick Approve Vendor',
                    subtitle: 'Instantly approve vendor access for testing',
                    value: isApproved,
                    onChanged: (enabled) async {
                      final notifier = ref.read(currentUserProvider.notifier);
                      if (enabled) {
                        await notifier.updateVendorStatus(
                          status: VendorStatus.approved,
                          vendorId: _demoVendorId,
                        );
                        if (!context.mounted) return;
                        PlaceifyToast.show(context, 'Vendor approved ✓');
                      } else {
                        await notifier.updateVendorStatus(
                          status: VendorStatus.none,
                        );
                        if (!context.mounted) return;
                        PlaceifyToast.show(context, 'Vendor status reset');
                      }
                    },
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
