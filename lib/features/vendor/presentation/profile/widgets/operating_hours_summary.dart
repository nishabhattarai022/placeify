import 'package:flutter/material.dart';

import 'package:placeify/core/constants/app_colors.dart';
import 'package:placeify/core/constants/app_typography.dart';
import 'package:placeify/features/vendor/domain/models/vendor_operating_day.dart';

/// Read-only weekly hours table with grouped day ranges.
class OperatingHoursSummary extends StatelessWidget {
  const OperatingHoursSummary({required this.schedule, super.key});

  final List<VendorOperatingDay> schedule;

  @override
  Widget build(BuildContext context) {
    final groups = buildVendorScheduleDisplayGroups(schedule);
    if (groups.isEmpty) {
      return Text(
        '—',
        style: AppTypography.bodyLight.copyWith(color: AppColors.textPrimary),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cream.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.creamDark),
      ),
      child: Column(
        children: [
          for (var i = 0; i < groups.length; i++) ...[
            if (i > 0)
              Divider(
                height: 1,
                thickness: 1,
                color: AppColors.creamDark.withValues(alpha: 0.85),
              ),
            _ScheduleGroupRow(group: groups[i]),
          ],
        ],
      ),
    );
  }
}

class _ScheduleGroupRow extends StatelessWidget {
  const _ScheduleGroupRow({required this.group});

  final VendorScheduleDisplayGroup group;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 88,
            child: Text(
              group.daysLabel,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.espresso,
                letterSpacing: -0.1,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              group.hoursLabel,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: group.isClosed
                    ? AppColors.textMuted
                    : AppColors.textPrimary,
                fontStyle: group.isClosed ? FontStyle.italic : FontStyle.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
