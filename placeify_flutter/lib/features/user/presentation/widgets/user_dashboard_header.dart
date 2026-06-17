import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/user_dashboard_nav.dart';

class UserDashboardHeader extends ConsumerWidget {
  const UserDashboardHeader({
    required this.currentLocation,
    this.onMenuTap,
    super.key,
  });

  final String currentLocation;
  final VoidCallback? onMenuTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final section =
        userDashboardNavForPath(currentLocation) ?? UserDashboardNav.dashboard;
    final isMobile = MediaQuery.sizeOf(context).width < 900;
    final user = ref.watch(currentUserProvider).value;
    final displayName = _displayName(user?.fullName);

    return Container(
      padding: EdgeInsets.fromLTRB(isMobile ? 8 : 24, 16, 24, 16),
      decoration: const BoxDecoration(
        color: AppColors.warmWhite,
        border: Border(
          bottom: BorderSide(color: AppColors.creamDark, width: 1),
        ),
      ),
      child: Row(
        children: [
          if (isMobile && onMenuTap != null) ...[
            IconButton(
              onPressed: onMenuTap,
              icon: const Icon(Icons.menu_rounded),
              color: AppColors.espresso,
            ),
            const SizedBox(width: 4),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello, $displayName',
                  style: AppTypography.metricLabel.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 2),
                Text(section.pageTitle, style: AppTypography.sectionTitle),
              ],
            ),
          ),
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.sageBg,
            child: Text(
              displayName.characters.first.toUpperCase(),
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.forest,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _displayName(String? fullName) {
    final trimmed = fullName?.trim() ?? '';
    if (trimmed.isEmpty) return 'Guest';
    return trimmed.split(' ').first;
  }
}
