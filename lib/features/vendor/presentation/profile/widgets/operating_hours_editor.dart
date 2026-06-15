import 'package:flutter/material.dart';

import 'package:placeify/core/constants/app_colors.dart';
import 'package:placeify/core/services/haptic_service.dart';
import 'package:placeify/core/widgets/animated_scale_tap.dart';
import 'package:placeify/features/vendor/domain/constants/vendor_profile_strings.dart';
import 'package:placeify/features/vendor/domain/models/vendor_operating_day.dart';
import 'package:placeify/features/vendor/domain/validators/vendor_profile_validator.dart';

/// Seven-day schedule editor — compact weekly table with time pickers.
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

  List<VendorOperatingDay> get _orderedSchedule => [
        for (final key in vendorWeekDayKeys)
          schedule.firstWhere(
            (day) => day.dayKey == key,
            orElse: () => VendorOperatingDay(dayKey: key, isClosed: true),
          ),
      ];

  void _copyToAllDays() {
    if (schedule.isEmpty) return;
    HapticService.light();
    final template = schedule.firstWhere(
      (day) => !day.isClosed,
      orElse: () => schedule.first,
    );
    onChanged?.call([
      for (final day in _orderedSchedule)
        day.copyWith(
          isClosed: template.isClosed,
          openTime: template.openTime,
          closeTime: template.closeTime,
        ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final ordered = _orderedSchedule;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Set your weekly storefront hours',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textMuted,
                  height: 1.35,
                ),
              ),
            ),
            TextButton(
              onPressed: schedule.isEmpty ? null : _copyToAllDays,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(VendorProfileStrings.copyToAllDays),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: AppColors.cream.withValues(alpha: 0.35),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.creamDark),
          ),
          child: Column(
            children: [
              const _ScheduleTableHeader(),
              Divider(
                height: 1,
                thickness: 1,
                color: AppColors.creamDark.withValues(alpha: 0.85),
              ),
              for (var i = 0; i < ordered.length; i++) ...[
                _ScheduleEditRow(
                  day: ordered[i],
                  error: fieldErrors[
                      VendorProfileFieldKeys.schedule(ordered[i].dayKey)],
                  onChanged: (updated) {
                    onChanged?.call([
                      for (final item in ordered)
                        item.dayKey == updated.dayKey ? updated : item,
                    ]);
                  },
                ),
                if (i < ordered.length - 1)
                  Divider(
                    height: 1,
                    thickness: 1,
                    indent: 14,
                    endIndent: 14,
                    color: AppColors.creamDark.withValues(alpha: 0.6),
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _ScheduleTableHeader extends StatelessWidget {
  const _ScheduleTableHeader();

  @override
  Widget build(BuildContext context) {
    const labelStyle = TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w600,
      color: AppColors.textMuted,
      letterSpacing: 0.6,
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
      child: Row(
        children: [
          const SizedBox(
            width: 44,
            child: Text('DAY', style: labelStyle),
          ),
          Expanded(
            child: Text(
              VendorProfileStrings.openLabel.toUpperCase(),
              style: labelStyle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              VendorProfileStrings.closeLabel.toUpperCase(),
              style: labelStyle,
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }
}

class _ScheduleEditRow extends StatelessWidget {
  const _ScheduleEditRow({
    required this.day,
    required this.onChanged,
    this.error,
  });

  final VendorOperatingDay day;
  final ValueChanged<VendorOperatingDay> onChanged;
  final String? error;

  @override
  Widget build(BuildContext context) {
    final isOpen = !day.isClosed;

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 10, 10, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 44,
                child: Text(
                  _shortDay(day.dayKey),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.espresso,
                  ),
                ),
              ),
              Expanded(
                child: _TimeButton(
                  time: day.openTime,
                  enabled: isOpen,
                  onPick: (time) => onChanged(day.copyWith(openTime: time)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _TimeButton(
                  time: day.closeTime,
                  enabled: isOpen,
                  onPick: (time) => onChanged(day.copyWith(closeTime: time)),
                ),
              ),
              const SizedBox(width: 8),
              _OpenToggle(
                isOpen: isOpen,
                onChanged: (open) {
                  HapticService.selection();
                  onChanged(day.copyWith(isClosed: !open));
                },
              ),
            ],
          ),
          if (error != null) ...[
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.only(left: 44),
              child: Text(
                error!,
                style: const TextStyle(fontSize: 11, color: AppColors.coral),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _shortDay(String dayKey) {
    const labels = {
      'monday': 'Mon',
      'tuesday': 'Tue',
      'wednesday': 'Wed',
      'thursday': 'Thu',
      'friday': 'Fri',
      'saturday': 'Sat',
      'sunday': 'Sun',
    };
    return labels[dayKey] ?? dayKey.substring(0, 3);
  }
}

class _OpenToggle extends StatelessWidget {
  const _OpenToggle({
    required this.isOpen,
    required this.onChanged,
  });

  final bool isOpen;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: isOpen ? 'Open' : 'Closed',
      child: GestureDetector(
        onTap: () => onChanged(!isOpen),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 40,
          height: 24,
          decoration: BoxDecoration(
            color: isOpen ? AppColors.teal : AppColors.sand,
            borderRadius: BorderRadius.circular(999),
          ),
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            alignment: isOpen ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              width: 18,
              height: 18,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TimeButton extends StatelessWidget {
  const _TimeButton({
    required this.time,
    required this.enabled,
    required this.onPick,
  });

  final String time;
  final bool enabled;
  final ValueChanged<String> onPick;

  @override
  Widget build(BuildContext context) {
    final display = enabled ? formatVendorTimeDisplay(time) : '—';

    return AnimatedScaleTap(
      onTap: enabled
          ? () async {
              HapticService.light();
              final picked = await _pickTime(context, time);
              if (picked != null) onPick(picked);
            }
          : null,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
        decoration: BoxDecoration(
          color: enabled ? Colors.white : AppColors.creamDark.withValues(alpha: 0.35),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: enabled ? AppColors.creamDark : Colors.transparent,
            width: 1.5,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          display,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: enabled ? AppColors.espresso : AppColors.textMuted,
          ),
        ),
      ),
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
