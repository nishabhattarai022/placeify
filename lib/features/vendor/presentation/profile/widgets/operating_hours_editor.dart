import 'package:flutter/material.dart';

import 'package:placeify/core/constants/app_colors.dart';
import 'package:placeify/core/services/haptic_service.dart';
import 'package:placeify/core/widgets/animated_scale_tap.dart';
import 'package:placeify/features/profile/presentation/widgets/shared/profile_toggle_row.dart';
import 'package:placeify/features/vendor/domain/constants/vendor_profile_strings.dart';
import 'package:placeify/features/vendor/domain/models/vendor_operating_day.dart';
import 'package:placeify/features/vendor/domain/validators/vendor_profile_validator.dart';

/// Seven-day schedule editor with closed toggles and time pickers.
class OperatingHoursEditor extends StatelessWidget {
  const OperatingHoursEditor({
    required this.schedule,
    required this.fieldErrors,
    this.onChanged,
    super.key,
  });

  final List<VendorOperatingDay> schedule;
  final Map<String, String> fieldErrors;
  final ValueChanged<List<VendorOperatingDay>>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: schedule.isEmpty
                ? null
                : () {
                    HapticService.light();
                    final template = schedule.firstWhere(
                      (day) => !day.isClosed,
                      orElse: () => schedule.first,
                    );
                    onChanged?.call([
                      for (final day in schedule)
                        day.copyWith(
                          isClosed: template.isClosed,
                          openTime: template.openTime,
                          closeTime: template.closeTime,
                        ),
                    ]);
                  },
            child: const Text(VendorProfileStrings.copyToAllDays),
          ),
        ),
        for (final day in schedule) ...[
          _DayRow(
            day: day,
            error: fieldErrors[VendorProfileFieldKeys.schedule(day.dayKey)],
            onChanged: (updated) {
              onChanged?.call([
                for (final item in schedule)
                  item.dayKey == updated.dayKey ? updated : item,
              ]);
            },
          ),
          const SizedBox(height: 8),
        ],
      ],
    );
  }
}

class _DayRow extends StatelessWidget {
  const _DayRow({
    required this.day,
    required this.onChanged,
    this.error,
  });

  final VendorOperatingDay day;
  final ValueChanged<VendorOperatingDay> onChanged;
  final String? error;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cream.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.creamDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileToggleRow(
            title: VendorProfileStrings.dayLabel(day.dayKey),
            subtitle: day.isClosed
                ? VendorProfileStrings.closedLabel
                : '${day.openTime} – ${day.closeTime}',
            value: !day.isClosed,
            onChanged: (isOpen) {
              HapticService.selection();
              onChanged(day.copyWith(isClosed: !isOpen));
            },
          ),
          if (!day.isClosed) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _TimeButton(
                    label: VendorProfileStrings.openLabel,
                    time: day.openTime,
                    onPick: (time) => onChanged(day.copyWith(openTime: time)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _TimeButton(
                    label: VendorProfileStrings.closeLabel,
                    time: day.closeTime,
                    onPick: (time) => onChanged(day.copyWith(closeTime: time)),
                  ),
                ),
              ],
            ),
          ],
          if (error != null) ...[
            const SizedBox(height: 6),
            Text(
              error!,
              style: const TextStyle(fontSize: 12, color: AppColors.coral),
            ),
          ],
        ],
      ),
    );
  }
}

class _TimeButton extends StatelessWidget {
  const _TimeButton({
    required this.label,
    required this.time,
    required this.onPick,
  });

  final String label;
  final String time;
  final ValueChanged<String> onPick;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: AppColors.textMuted,
            letterSpacing: 0.6,
          ),
        ),
        const SizedBox(height: 4),
        AnimatedScaleTap(
          onTap: () async {
            HapticService.light();
            final picked = await _pickTime(context, time);
            if (picked != null) onPick(picked);
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.creamDark, width: 1.5),
            ),
            child: Text(
              time,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.espresso,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<String?> _pickTime(BuildContext context, String current) async {
    final parts = current.split(':');
    if (parts.length != 2) return null;

    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return null;

    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: hour, minute: minute),
    );
    if (picked == null) return null;

    final h = picked.hour.toString().padLeft(2, '0');
    final m = picked.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}
