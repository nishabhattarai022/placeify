import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:placeify/core/constants/app_colors.dart';
import 'package:placeify/core/constants/app_radii.dart';
import 'package:placeify/core/constants/app_spacing.dart';
import 'package:placeify/core/constants/app_typography.dart';
import 'package:placeify/core/utils/formatters.dart';
import 'package:placeify/core/widgets/bottom_nav/bottom_nav_tokens.dart';
import 'package:placeify/features/admin/domain/constants/admin_strings.dart';
import 'package:placeify/features/admin/presentation/providers/admin_users_provider.dart';
import 'package:placeify/features/admin/presentation/widgets/admin_role_chip.dart';
import 'package:placeify/features/admin/presentation/widgets/admin_status_chip.dart';
import 'package:placeify/features/profile/presentation/widgets/profile_sub_hero.dart';
import 'package:placeify/features/vendor/domain/enums/vendor_status.dart';

class AdminUserDetailScreen extends ConsumerWidget {
  const AdminUserDetailScreen({required this.userId, super.key});

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(adminUserDetailProvider(userId));

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Column(
        children: [
          const ProfileSubHero(
            title: AdminStrings.userDetailTitle,
            subtitle: 'account overview',
          ),
          Expanded(
            child: userAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => const Center(child: Text('Could not load user')),
              data: (user) {
                if (user == null) {
                  return const Center(child: Text('User not found'));
                }

                return ListView(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenPadding,
                    16,
                    AppSpacing.screenPadding,
                    BottomNavTokens.scrollBottomPadding,
                  ),
                  children: [
                    Container(
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
                            user.name,
                            style: AppTypography.sectionTitle.copyWith(fontSize: 20),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            user.email,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              AdminRoleChip(role: user.role),
                              if (user.vendorStatus != VendorStatus.none) ...[
                                const SizedBox(width: 8),
                                AdminStatusChip(status: user.vendorStatus),
                              ],
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Joined ${Formatters.shortDate(user.createdAt)}',
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
