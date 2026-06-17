import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_typography.dart';
import '../../domain/user_dashboard_nav.dart';

class UserDashboardSidebar extends StatelessWidget {
  const UserDashboardSidebar({
    required this.currentLocation,
    this.onItemSelected,
    super.key,
  });

  final String currentLocation;
  final VoidCallback? onItemSelected;

  @override
  Widget build(BuildContext context) {
    final active = userDashboardNavForPath(currentLocation) ??
        UserDashboardNav.dashboard;

    return ColoredBox(
      color: AppColors.warmWhite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Placeify',
                  style: AppTypography.logoWordmark.copyWith(
                    color: AppColors.forest,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'My account',
                  style: AppTypography.metricLabel.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                for (final item in UserDashboardNav.values)
                  _SidebarTile(
                    item: item,
                    selected: item == active,
                    onTap: () {
                      context.go(item.routePath);
                      onItemSelected?.call();
                    },
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: OutlinedButton.icon(
              onPressed: () => context.go('/home'),
              icon: const Icon(Icons.storefront_outlined, size: 18),
              label: const Text('Back to shop'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.espresso,
                side: const BorderSide(color: AppColors.creamDark),
                shape: RoundedRectangleBorder(borderRadius: AppRadii.sm),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarTile extends StatelessWidget {
  const _SidebarTile({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final UserDashboardNav item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: selected ? AppColors.sageBg : Colors.transparent,
        borderRadius: AppRadii.sm,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadii.sm,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Icon(
                  item.icon,
                  size: 20,
                  color: selected ? AppColors.forest : AppColors.textSecondary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item.label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                      color:
                          selected ? AppColors.forest : AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
