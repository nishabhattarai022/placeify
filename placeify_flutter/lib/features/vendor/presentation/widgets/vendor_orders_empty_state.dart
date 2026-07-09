import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/services/haptic_service.dart';
import 'vendor_order_filter_tabs.dart';

class VendorOrdersEmptyState extends StatelessWidget {
  const VendorOrdersEmptyState({
    required this.tab,
    this.searchQuery,
    this.hasDateFilter = false,
    this.onClearFilters,
    this.onSwitchTab,
    super.key,
  });

  final VendorOrderTab tab;
  final String? searchQuery;
  final bool hasDateFilter;
  final VoidCallback? onClearFilters;
  final ValueChanged<VendorOrderTab>? onSwitchTab;

  bool get _hasActiveFilters =>
      (searchQuery != null && searchQuery!.trim().isNotEmpty) || hasDateFilter;

  @override
  Widget build(BuildContext context) {
    if (_hasActiveFilters) {
      return _FilteredEmptyState(onClearFilters: onClearFilters);
    }

    return switch (tab) {
      VendorOrderTab.pending => _TabEmptyState(
          icon: Icons.hourglass_empty_rounded,
          title: 'No pending orders',
          subtitle:
              'New orders awaiting your confirmation will appear here.',
        ),
      VendorOrderTab.active => _TabEmptyState(
          icon: Icons.local_shipping_outlined,
          title: 'No active orders',
          subtitle: 'Accepted, processing, and shipped orders show up here.',
          actionLabel: 'Check pending',
          onAction: onSwitchTab == null
              ? null
              : () {
                  HapticService.light();
                  onSwitchTab!(VendorOrderTab.pending);
                },
        ),
      VendorOrderTab.completed => _TabEmptyState(
          icon: Icons.check_circle_outline_rounded,
          title: 'No completed orders',
          subtitle: 'Delivered orders will be listed here once fulfilled.',
        ),
      VendorOrderTab.cancelled => _TabEmptyState(
          icon: Icons.cancel_outlined,
          title: 'No cancelled orders',
          subtitle: 'Rejected or cancelled orders will appear here.',
        ),
    };
  }
}

class _FilteredEmptyState extends StatelessWidget {
  const _FilteredEmptyState({this.onClearFilters});

  final VoidCallback? onClearFilters;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.warmWhite,
                borderRadius: AppRadii.md,
                border: Border.all(color: AppColors.creamDark, width: 1.5),
              ),
              child: const Icon(
                Icons.search_off_rounded,
                size: 28,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No matching orders',
              style: AppTypography.sectionTitle.copyWith(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search or date filter.',
              style: AppTypography.bodyLight.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (onClearFilters != null) ...[
              const SizedBox(height: 20),
              _EmptyStateButton(
                label: 'Clear filters',
                onTap: onClearFilters!,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _TabEmptyState extends StatelessWidget {
  const _TabEmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.warmWhite,
                borderRadius: AppRadii.md,
                border: Border.all(color: AppColors.creamDark, width: 1.5),
              ),
              child: Icon(icon, size: 28, color: AppColors.textMuted),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: AppTypography.sectionTitle.copyWith(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: AppTypography.bodyLight.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 20),
              _EmptyStateButton(label: actionLabel!, onTap: onAction!),
            ],
          ],
        ),
      ),
    );
  }
}

class _EmptyStateButton extends StatelessWidget {
  const _EmptyStateButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticService.light();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.espresso,
          borderRadius: AppRadii.pill,
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.warmWhite,
          ),
        ),
      ),
    );
  }
}
